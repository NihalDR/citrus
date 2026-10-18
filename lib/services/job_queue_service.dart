/// Job queue service for managing batch conversion jobs.

import 'dart:async';
import 'package:citrus/core/models/models.dart';

/// Service for managing job queue and batch processing.
class JobQueueService {
  final List<BatchJob> _jobs = [];
  final StreamController<BatchJob> _jobAddedController =
      StreamController<BatchJob>.broadcast();
  final StreamController<JobItem> _jobItemUpdatedController =
      StreamController<JobItem>.broadcast();
  final StreamController<BatchJob> _jobCompletedController =
      StreamController<BatchJob>.broadcast();

  int _maxConcurrentJobs = 3;
  final Set<String> _runningJobIds = {};

  /// Stream of job added events.
  Stream<BatchJob> get onJobAdded => _jobAddedController.stream;

  /// Stream of job item updates.
  Stream<JobItem> get onJobItemUpdated => _jobItemUpdatedController.stream;

  /// Stream of job completed events.
  Stream<BatchJob> get onJobCompleted => _jobCompletedController.stream;

  /// Maximum number of concurrent jobs.
  int get maxConcurrentJobs => _maxConcurrentJobs;

  set maxConcurrentJobs(int value) {
    _maxConcurrentJobs = value.clamp(1, 10);
  }

  /// All jobs.
  List<BatchJob> get jobs => List.unmodifiable(_jobs);

  /// Active (non-terminal) jobs.
  List<BatchJob> get activeJobs => _jobs.where((j) => !j.isComplete).toList();

  /// Completed jobs.
  List<BatchJob> get completedJobs => _jobs.where((j) => j.isComplete).toList();

  /// Add a new batch job.
  BatchJob addJob({
    required String name,
    required List<JobItem> items,
  }) {
    final job = BatchJob(name: name, items: items);
    _jobs.insert(0, job); // Add to front for recent-first ordering
    _jobAddedController.add(job);
    _processQueue();
    return job;
  }

  /// Remove a job from the queue.
  bool removeJob(String jobId) {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index >= 0) {
      _jobs.removeAt(index);
      return true;
    }
    return false;
  }

  /// Clear all completed jobs.
  void clearCompletedJobs() {
    _jobs.removeWhere((j) => j.isComplete);
  }

  /// Clear all jobs.
  void clearAllJobs() {
    _jobs.clear();
  }

  /// Get a job by ID.
  BatchJob? getJob(String jobId) {
    for (final j in _jobs) {
      if (j.id == jobId) return j;
    }
    return null;
  }

  /// Update a job item's status.
  void updateJobItem({
    required String jobId,
    required String itemId,
    JobStatus? status,
    double? progress,
    String? errorMessage,
    String? outputPath,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    final job = getJob(jobId);
    if (job == null) return;

    final itemIndex = job.items.indexWhere((i) => i.id == itemId);
    if (itemIndex < 0) return;

    final item = job.items[itemIndex];
    final updatedItem = item.copyWith(
      status: status,
      progress: progress,
      errorMessage: errorMessage,
      outputPath: outputPath,
      startedAt: startedAt,
      completedAt: completedAt,
    );

    job.items[itemIndex] = updatedItem;
    _jobItemUpdatedController.add(updatedItem);

    // Check if job is complete
    if (job.isComplete) {
      job.completedAt = DateTime.now();
      job.status = job.hasFailures
          ? BatchJobStatus.partiallyCompleted
          : BatchJobStatus.completed;
      _jobCompletedController.add(job);
      _runningJobIds.remove(jobId);
      _processQueue();
    }

    // Update batch job status
    _updateBatchJobStatus(job);
  }

  void _updateBatchJobStatus(BatchJob job) {
    if (job.items.every((i) => i.status == JobStatus.completed)) {
      job.status = BatchJobStatus.completed;
    } else if (job.items.any((i) => i.status == JobStatus.failed)) {
      job.status = BatchJobStatus.partiallyCompleted;
    } else if (job.items.any((i) => i.status == JobStatus.running)) {
      job.status = BatchJobStatus.running;
    } else {
      job.status = BatchJobStatus.pending;
    }
  }

  /// Cancel a job item.
  void cancelJobItem(String jobId, String itemId) {
    updateJobItem(
      jobId: jobId,
      itemId: itemId,
      status: JobStatus.cancelled,
      completedAt: DateTime.now(),
    );
  }

  /// Cancel all items in a job.
  void cancelJob(String jobId) {
    final job = getJob(jobId);
    if (job == null) return;

    for (final item in job.items) {
      if (!item.status.isTerminal) {
        cancelJobItem(jobId, item.id);
      }
    }
  }

  /// Retry failed items in a job.
  void retryJob(String jobId) {
    final job = getJob(jobId);
    if (job == null) return;

    for (final item in job.items) {
      if (item.status == JobStatus.failed) {
        updateJobItem(
          jobId: jobId,
          itemId: item.id,
          status: JobStatus.pending,
          progress: 0.0,
          errorMessage: null,
        );
      }
    }
    _processQueue();
  }

  /// Process the queue, starting pending jobs up to concurrency limit.
  void _processQueue() {
    final pendingJobs = _jobs
        .where((j) =>
            j.status == BatchJobStatus.pending ||
            j.status == BatchJobStatus.running)
        .toList();

    for (final job in pendingJobs) {
      if (_runningJobIds.length >= _maxConcurrentJobs) break;

      final pendingItems =
          job.items.where((i) => i.status == JobStatus.pending).toList();

      for (final item in pendingItems) {
        if (_runningJobIds.length >= _maxConcurrentJobs) break;

        // The actual processing is handled by the conversion service
        // This just marks items as queued
        updateJobItem(
          jobId: job.id,
          itemId: item.id,
          status: JobStatus.queued,
        );
      }

      if (job.items.any((i) =>
          i.status == JobStatus.queued || i.status == JobStatus.running)) {
        _runningJobIds.add(job.id);
        job.status = BatchJobStatus.running;
      }
    }
  }

  /// Mark a job item as running.
  void markItemRunning(String jobId, String itemId) {
    updateJobItem(
      jobId: jobId,
      itemId: itemId,
      status: JobStatus.running,
      startedAt: DateTime.now(),
    );
  }

  /// Mark a job item as completed.
  void markItemCompleted(String jobId, String itemId, {String? outputPath}) {
    updateJobItem(
      jobId: jobId,
      itemId: itemId,
      status: JobStatus.completed,
      progress: 1.0,
      outputPath: outputPath,
      completedAt: DateTime.now(),
    );
  }

  /// Mark a job item as failed.
  void markItemFailed(String jobId, String itemId, String errorMessage) {
    updateJobItem(
      jobId: jobId,
      itemId: itemId,
      status: JobStatus.failed,
      errorMessage: errorMessage,
      completedAt: DateTime.now(),
    );
  }

  /// Update progress for a job item.
  void updateProgress(String jobId, String itemId, double progress,
      {String? message}) {
    updateJobItem(
      jobId: jobId,
      itemId: itemId,
      progress: progress.clamp(0.0, 1.0),
    );
  }

  /// Dispose resources.
  void dispose() {
    _jobAddedController.close();
    _jobItemUpdatedController.close();
    _jobCompletedController.close();
  }
}

/// Global job queue service instance.
final jobQueueService = JobQueueService();
