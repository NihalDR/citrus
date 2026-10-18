/// Core data models for the Citrus application.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:citrus/core/errors/app_errors.dart';

/// Supported file categories.
enum FileCategory {
  image,
  video,
  audio,
  document,
  archive,
  unknown,
}

/// Supported image formats.
enum ImageFormat {
  png('png', 'PNG', supportsTransparency: true, supportsAnimation: false),
  jpeg('jpg', 'JPEG', supportsTransparency: false, supportsAnimation: false),
  webp('webp', 'WebP', supportsTransparency: true, supportsAnimation: true),
  bmp('bmp', 'BMP', supportsTransparency: false, supportsAnimation: false),
  gif('gif', 'GIF', supportsTransparency: true, supportsAnimation: true),
  tiff('tiff', 'TIFF', supportsTransparency: true, supportsAnimation: false),
  ico('ico', 'ICO', supportsTransparency: true, supportsAnimation: false),
  heic('heic', 'HEIC', supportsTransparency: true, supportsAnimation: false),
  heif('heif', 'HEIF', supportsTransparency: true, supportsAnimation: false);

  const ImageFormat(
    this.extension,
    this.displayName, {
    required this.supportsTransparency,
    required this.supportsAnimation,
  });

  final String extension;
  final String displayName;
  final bool supportsTransparency;
  final bool supportsAnimation;

  static ImageFormat? fromExtension(String extension) {
    for (final f in ImageFormat.values) {
      if (f.extension.equalsIgnoreCase(extension)) {
        return f;
      }
    }
    return null;
  }

  static List<String> get supportedExtensions =>
      ImageFormat.values.map((f) => f.extension).toList();
}

/// Supported video formats.
enum VideoFormat {
  mp4('mp4', 'MP4'),
  mov('mov', 'MOV'),
  mkv('mkv', 'MKV'),
  avi('avi', 'AVI'),
  webm('webm', 'WebM'),
  flv('flv', 'FLV'),
  mpg('mpg', 'MPG'),
  mpeg('mpeg', 'MPEG'),
  wmv('wmv', 'WMV');

  const VideoFormat(this.extension, this.displayName);

  final String extension;
  final String displayName;

  static VideoFormat? fromExtension(String extension) {
    for (final f in VideoFormat.values) {
      if (f.extension.equalsIgnoreCase(extension)) {
        return f;
      }
    }
    return null;
  }

  static List<String> get supportedExtensions =>
      VideoFormat.values.map((f) => f.extension).toList();
}

/// Supported audio formats.
enum AudioFormat {
  mp3('mp3', 'MP3'),
  wav('wav', 'WAV'),
  aac('aac', 'AAC'),
  m4a('m4a', 'M4A'),
  flac('flac', 'FLAC'),
  ogg('ogg', 'OGG'),
  opus('opus', 'Opus'),
  aiff('aiff', 'AIFF');

  const AudioFormat(this.extension, this.displayName);

  final String extension;
  final String displayName;

  static AudioFormat? fromExtension(String extension) {
    for (final f in AudioFormat.values) {
      if (f.extension.equalsIgnoreCase(extension)) {
        return f;
      }
    }
    return null;
  }

  static List<String> get supportedExtensions =>
      AudioFormat.values.map((f) => f.extension).toList();
}

/// Supported document formats.
enum DocumentFormat {
  pdf('pdf', 'PDF'),
  txt('txt', 'Text'),
  md('md', 'Markdown');

  const DocumentFormat(this.extension, this.displayName);

  final String extension;
  final String displayName;

  static DocumentFormat? fromExtension(String extension) {
    for (final f in DocumentFormat.values) {
      if (f.extension.equalsIgnoreCase(extension)) {
        return f;
      }
    }
    return null;
  }

  static List<String> get supportedExtensions =>
      DocumentFormat.values.map((f) => f.extension).toList();
}

/// Supported archive formats.
enum ArchiveFormat {
  zip('zip', 'ZIP'),
  tar('tar', 'TAR'),
  gz('gz', 'GZIP'),
  rar('rar', 'RAR'),
  sevenZ('7z', '7-Zip');

  const ArchiveFormat(this.extension, this.displayName);

  final String extension;
  final String displayName;

  static ArchiveFormat? fromExtension(String extension) {
    for (final f in ArchiveFormat.values) {
      if (f.extension.equalsIgnoreCase(extension)) {
        return f;
      }
    }
    return null;
  }

  static List<String> get supportedExtensions =>
      ArchiveFormat.values.map((f) => f.extension).toList();
}

/// File metadata container.
class FileMetadata {
  final String path;
  final String name;
  final String extension;
  final FileCategory category;
  final int sizeBytes;
  final DateTime modifiedAt;
  final DateTime? createdAt;
  final Map<String, dynamic> additional;

  const FileMetadata({
    required this.path,
    required this.name,
    required this.extension,
    required this.category,
    required this.sizeBytes,
    required this.modifiedAt,
    this.createdAt,
    this.additional = const {},
  });

  String get displayName => name;

  bool get isImage => category == FileCategory.image;
  bool get isVideo => category == FileCategory.video;
  bool get isAudio => category == FileCategory.audio;
  bool get isDocument => category == FileCategory.document;
  bool get isArchive => category == FileCategory.archive;

  ImageFormat? get imageFormat =>
      isImage ? ImageFormat.fromExtension(extension.toLowerCase()) : null;

  VideoFormat? get videoFormat =>
      isVideo ? VideoFormat.fromExtension(extension.toLowerCase()) : null;

  AudioFormat? get audioFormat =>
      isAudio ? AudioFormat.fromExtension(extension.toLowerCase()) : null;

  DocumentFormat? get documentFormat =>
      isDocument ? DocumentFormat.fromExtension(extension.toLowerCase()) : null;

  ArchiveFormat? get archiveFormat =>
      isArchive ? ArchiveFormat.fromExtension(extension.toLowerCase()) : null;

  factory FileMetadata.fromPath(String path) {
    final uri = Uri.file(path);
    final name = uri.pathSegments.last;
    final lastDot = name.lastIndexOf('.');
    final extension =
        lastDot > 0 ? name.substring(lastDot + 1).toLowerCase() : '';
    // final nameWithoutExt = lastDot > 0 ? name.substring(0, lastDot) : name;

    FileCategory category;
    if (ImageFormat.supportedExtensions.contains(extension)) {
      category = FileCategory.image;
    } else if (VideoFormat.supportedExtensions.contains(extension)) {
      category = FileCategory.video;
    } else if (AudioFormat.supportedExtensions.contains(extension)) {
      category = FileCategory.audio;
    } else if (DocumentFormat.supportedExtensions.contains(extension)) {
      category = FileCategory.document;
    } else if (ArchiveFormat.supportedExtensions.contains(extension)) {
      category = FileCategory.archive;
    } else {
      category = FileCategory.unknown;
    }

    return FileMetadata(
      path: path,
      name: name,
      extension: extension,
      category: category,
      sizeBytes: 0, // Will be populated by file system
      modifiedAt: DateTime.now(),
    );
  }

  FileMetadata copyWith({
    String? path,
    String? name,
    String? extension,
    FileCategory? category,
    int? sizeBytes,
    DateTime? modifiedAt,
    DateTime? createdAt,
    Map<String, dynamic>? additional,
  }) {
    return FileMetadata(
      path: path ?? this.path,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      category: category ?? this.category,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      additional: additional ?? this.additional,
    );
  }
}

/// Job status enum.
enum JobStatus {
  pending('Pending'),
  queued('Queued'),
  running('Running'),
  completed('Completed'),
  failed('Failed'),
  cancelled('Cancelled');

  const JobStatus(this.displayName);
  final String displayName;

  bool get isActive => this == JobStatus.running || this == JobStatus.queued;
  bool get isTerminal =>
      this == JobStatus.completed ||
      this == JobStatus.failed ||
      this == JobStatus.cancelled;
}

/// Individual job item in a batch.
class JobItem {
  final String id;
  final String inputPath;
  final String? outputPath;
  final String actionId;
  final Map<String, dynamic> parameters;
  JobStatus status;
  double progress;
  String? errorMessage;
  DateTime? startedAt;
  DateTime? completedAt;

  JobItem({
    String? id,
    required this.inputPath,
    this.outputPath,
    required this.actionId,
    required this.parameters,
    this.status = JobStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
    this.startedAt,
    this.completedAt,
  }) : id = id ?? const Uuid().v4();

  JobItem copyWith({
    String? id,
    String? inputPath,
    String? outputPath,
    String? actionId,
    Map<String, dynamic>? parameters,
    JobStatus? status,
    double? progress,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return JobItem(
      id: id ?? this.id,
      inputPath: inputPath ?? this.inputPath,
      outputPath: outputPath ?? this.outputPath,
      actionId: actionId ?? this.actionId,
      parameters: parameters ?? this.parameters,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Duration? get duration {
    if (startedAt == null) return null;
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt!);
  }
}

/// Batch job containing multiple job items.
class BatchJob {
  final String id;
  final String name;
  final List<JobItem> items;
  final DateTime createdAt;
  DateTime? completedAt;
  BatchJobStatus status;

  BatchJob({
    String? id,
    required this.name,
    required this.items,
    DateTime? createdAt,
    this.completedAt,
    this.status = BatchJobStatus.pending,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  int get totalItems => items.length;
  int get completedItems =>
      items.where((i) => i.status == JobStatus.completed).length;
  int get failedItems =>
      items.where((i) => i.status == JobStatus.failed).length;
  int get pendingItems =>
      items.where((i) => i.status == JobStatus.pending).length;
  int get runningItems =>
      items.where((i) => i.status == JobStatus.running).length;

  double get overallProgress {
    if (items.isEmpty) return 0.0;
    return items.fold(0.0, (sum, item) => sum + item.progress) / items.length;
  }

  bool get isComplete => items.every((i) => i.status.isTerminal);
  bool get hasFailures => items.any((i) => i.status == JobStatus.failed);
}

/// Batch job status.
enum BatchJobStatus {
  pending,
  running,
  completed,
  partiallyCompleted,
  failed,
}

/// Action parameter definition.
class ActionParameter {
  final String id;
  final String label;
  final ParameterType type;
  final dynamic defaultValue;
  final dynamic minValue;
  final dynamic maxValue;
  final List<String>? options; // For enum/select types
  final String? unit;
  final String? description;
  final bool required;

  const ActionParameter({
    required this.id,
    required this.label,
    required this.type,
    this.defaultValue,
    this.minValue,
    this.maxValue,
    this.options,
    this.unit,
    this.description,
    this.required = true,
  });
}

enum ParameterType {
  integer,
  double,
  string,
  boolean,
  enumSelect,
  filePath,
  directoryPath,
  color,
}

/// Action category for grouping in UI.
enum ActionCategory {
  convert('Convert'),
  edit('Edit'),
  compress('Compress'),
  extract('Extract'),
  merge('Merge'),
  split('Split'),
  metadata('Metadata'),
  other('Other');

  const ActionCategory(this.displayName);
  final String displayName;
}

/// Base class for all conversion actions.
abstract class ConversionAction {
  final String id;
  final String displayName;
  final String description;
  final IconData icon;
  final ActionCategory category;
  final List<String> supportedInputFormats;
  final List<String> supportedOutputFormats;
  final List<ActionParameter> parameters;
  final bool supportsBatch;

  ConversionAction({
    required this.id,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.category,
    required this.supportedInputFormats,
    required this.supportedOutputFormats,
    required this.parameters,
    this.supportsBatch = true,
  });

  /// Check if this action is compatible with the given file metadata.
  bool isCompatible(FileMetadata metadata);

  /// Get the output format for the given input format and parameters.
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters);

  /// Generate output file path.
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters);

  /// Execute the conversion action.
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  });
}

/// Result of a conversion action.
class ConversionResult {
  final bool success;
  final String? outputPath;
  final String? errorMessage;
  final Map<String, dynamic> metadata;

  const ConversionResult({
    required this.success,
    this.outputPath,
    this.errorMessage,
    this.metadata = const {},
  });

  factory ConversionResult.success(String outputPath,
      {Map<String, dynamic> metadata = const {}}) {
    return ConversionResult(
      success: true,
      outputPath: outputPath,
      metadata: metadata,
    );
  }

  factory ConversionResult.failure(String errorMessage) {
    return ConversionResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Callback for progress updates.
typedef ProgressCallback = void Function(double progress, String? message);

/// Cancellation token for long-running operations.
class CancellationToken {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() => _cancelled = true;

  void throwIfCancelled() {
    if (_cancelled) {
      throw const JobCancelledError(jobId: '');
    }
  }
}

extension StringExtensions on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}
