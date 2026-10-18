/// File detection service for identifying file types and metadata.

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:citrus/core/models/models.dart';
import 'package:citrus/core/errors/app_errors.dart';
import 'package:mime/mime.dart';

/// Service for detecting file types and extracting metadata.
class FileDetectionService {
  /// Detect file metadata from a file path.
  Future<FileMetadata> detectFile(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FileOperationError(
        message: 'File does not exist',
        filePath: filePath,
        operation: FileOperationType.read,
        code: 'FILE_NOT_FOUND',
      );
    }

    final stat = await file.stat();
    final metadata = FileMetadata.fromPath(filePath).copyWith(
      sizeBytes: stat.size,
      modifiedAt: stat.modified,
      createdAt: stat.changed,
    );

    // Try to detect MIME type for additional validation
    final mimeType = lookupMimeType(filePath);
    if (mimeType != null) {
      metadata.additional['mimeType'] = mimeType;
    }

    // For images, try to get dimensions
    if (metadata.isImage) {
      try {
        final dimensions = await _getImageDimensions(filePath);
        if (dimensions != null) {
          metadata.additional['width'] = dimensions.$1;
          metadata.additional['height'] = dimensions.$2;
        }
      } catch (e) {
        // Ignore errors in dimension detection
      }
    }

    return metadata;
  }

  /// Detect multiple files concurrently.
  Future<List<FileMetadata>> detectFiles(List<String> filePaths) async {
    final futures = filePaths.map(detectFile).toList();
    return Future.wait(futures);
  }

  /// Get image dimensions using the image package.
  Future<(int, int)?> _getImageDimensions(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        return (image.width, image.height);
      }
    } catch (e) {
      // Ignore decode errors
    }
    return null;
  }

  /// Check if a file is a supported format.
  bool isSupportedFormat(String filePath) {
    final metadata = FileMetadata.fromPath(filePath);
    return metadata.category != FileCategory.unknown;
  }

  /// Get the category of a file.
  FileCategory getFileCategory(String filePath) {
    return FileMetadata.fromPath(filePath).category;
  }
}

/// Global file detection service instance.
final fileDetectionService = FileDetectionService();
