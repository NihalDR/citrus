/// Job queue panel widget.

import 'package:flutter/material.dart';
import 'package:citrus/core/models/models.dart';
import 'package:citrus/services/job_queue_service.dart';

class JobQueuePanel extends StatelessWidget {
  final List<BatchJob> jobs;

  const JobQueuePanel({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeJobs = jobs.where((j) => !j.isComplete).toList();
    final completedJobs = jobs.where((j) => j.isComplete).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Job Queue',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (jobs.isNotEmpty)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear Done'),
                ),
            ],
          ),
        ),
        if (jobs.isEmpty)
          Flexible(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_outlined,
                      size: 32,
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No jobs yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Drop files to start',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: activeJobs.length + (completedJobs.isNotEmpty ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index < activeJobs.length) {
                  return _JobCard(job: activeJobs[index]);
                } else {
                  return _CompletedJobsHeader(
                    count: completedJobs.length,
                    onTap: () {},
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  final BatchJob job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(job.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusChip(status: job.status),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: job.overallProgress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${job.completedItems}/${job.totalItems} files',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (job.runningItems > 0) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ],
                const Spacer(),
                if (job.status == BatchJobStatus.running)
                  TextButton(
                    onPressed: () => jobQueueService.cancelJob(job.id),
                    child: const Text('Cancel'),
                  )
                else if (job.status == BatchJobStatus.partiallyCompleted)
                  TextButton(
                    onPressed: () => jobQueueService.retryJob(job.id),
                    child: const Text('Retry Failed'),
                  ),
              ],
            ),
            if (job.items.any((i) => i.status == JobStatus.failed)) ...[
              const SizedBox(height: 8),
              ...job.items
                  .where((i) => i.status == JobStatus.failed)
                  .take(2)
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 14,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.errorMessage ?? 'Unknown error',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )),
              if (job.failedItems > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... and ${job.failedItems - 2} more errors',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BatchJobStatus status) {
    switch (status) {
      case BatchJobStatus.pending:
        return Colors.grey;
      case BatchJobStatus.running:
        return Colors.blue;
      case BatchJobStatus.completed:
        return Colors.green;
      case BatchJobStatus.partiallyCompleted:
        return Colors.orange;
      case BatchJobStatus.failed:
        return Colors.red;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final BatchJobStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String label;

    switch (status) {
      case BatchJobStatus.pending:
        color = Colors.grey;
        label = 'Pending';
        break;
      case BatchJobStatus.running:
        color = Colors.blue;
        label = 'Running';
        break;
      case BatchJobStatus.completed:
        color = Colors.green;
        label = 'Done';
        break;
      case BatchJobStatus.partiallyCompleted:
        color = Colors.orange;
        label = 'Partial';
        break;
      case BatchJobStatus.failed:
        color = Colors.red;
        label = 'Failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CompletedJobsHeader extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CompletedJobsHeader({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '$count completed job${count == 1 ? '' : 's'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.expand_more,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
