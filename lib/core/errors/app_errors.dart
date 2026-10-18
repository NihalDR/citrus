/// Custom exceptions for the Citrus application.

class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  }) : super();

  @override
  String toString() => 'AppError($code): $message';
}

/// Error thrown when a file operation fails.
class FileOperationError extends AppError {
  final String filePath;
  final FileOperationType operation;

  const FileOperationError({
    required String message,
    required this.filePath,
    required this.operation,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message,
            code: code, originalError: originalError, stackTrace: stackTrace);

  @override
  String toString() =>
      'FileOperationError($code): $message (${operation.name} on $filePath)';
}

enum FileOperationType {
  read,
  write,
  delete,
  copy,
  move,
  createDirectory,
  listDirectory,
}

/// Error thrown when file format detection fails.
class FormatDetectionError extends AppError {
  final String filePath;

  const FormatDetectionError({
    required String message,
    required this.filePath,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message,
            code: code, originalError: originalError, stackTrace: stackTrace);
}

/// Error thrown when a conversion operation fails.
class ConversionError extends AppError {
  final String inputPath;
  final String? outputPath;
  final String operation;

  const ConversionError({
    required String message,
    required this.inputPath,
    this.outputPath,
    required this.operation,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message,
            code: code, originalError: originalError, stackTrace: stackTrace);

  @override
  String toString() =>
      'ConversionError($code): $message ($operation: $inputPath -> $outputPath)';
}

/// Error thrown when an action is not compatible with the input files.
class IncompatibleActionError extends AppError {
  final String actionId;
  final List<String> filePaths;

  const IncompatibleActionError({
    required String message,
    required this.actionId,
    required this.filePaths,
    String? code,
  }) : super(message, code: code);

  @override
  String toString() =>
      'IncompatibleActionError($code): $message (action: $actionId, files: $filePaths)';
}

/// Error thrown when output file naming fails.
class OutputNamingError extends AppError {
  final String basePath;
  final String extension;

  const OutputNamingError({
    required String message,
    required this.basePath,
    required this.extension,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message,
            code: code, originalError: originalError, stackTrace: stackTrace);
}

/// Error thrown when a job is cancelled.
class JobCancelledError extends AppError {
  final String jobId;

  const JobCancelledError({
    required this.jobId,
    String message = 'Job was cancelled',
    String code = 'JOB_CANCELLED',
  }) : super(message, code: code);
}

/// Error thrown when FFmpeg or external process fails.
class ExternalProcessError extends AppError {
  final String command;
  final int exitCode;
  final String stdout;
  final String stderr;

  const ExternalProcessError({
    required String message,
    required this.command,
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    String code = 'EXTERNAL_PROCESS_FAILED',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message,
            code: code, originalError: originalError, stackTrace: stackTrace);

  @override
  String toString() =>
      'ExternalProcessError($code): $message\nCommand: $command\nExit code: $exitCode\nStdout: $stdout\nStderr: $stderr';
}
