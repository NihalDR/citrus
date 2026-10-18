/// Output service for safe file naming and path management.

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Service for managing output file paths and naming.
class OutputService {
  final Uuid _uuid = const Uuid();

  /// Generate a safe output path for a conversion.
  String generateOutputPath({
    required String inputPath,
    required String outputFormat,
    String? outputDirectory,
    String? customName,
    Map<String, dynamic>? parameters,
  }) {
    final inputFile = File(inputPath);
    final inputDir = outputDirectory ?? inputFile.parent.path;
    final inputName = p.basenameWithoutExtension(inputPath);
    final extension = outputFormat.toLowerCase().replaceFirst('.', '');

    // Use custom name if provided, otherwise use input name
    final baseName = customName ?? inputName;

    // Ensure output directory exists
    final outputDir = Directory(inputDir);
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    // Generate base path
    String outputPath = p.join(inputDir, '$baseName.$extension');

    // Handle collisions
    outputPath = _resolveCollision(outputPath);

    return outputPath;
  }

  /// Generate output paths for batch conversion.
  List<String> generateBatchOutputPaths({
    required List<String> inputPaths,
    required String outputFormat,
    String? outputDirectory,
    Map<String, dynamic>? parameters,
  }) {
    return inputPaths.map((inputPath) {
      return generateOutputPath(
        inputPath: inputPath,
        outputFormat: outputFormat,
        outputDirectory: outputDirectory,
        parameters: parameters,
      );
    }).toList();
  }

  /// Resolve file name collisions by appending a number.
  String _resolveCollision(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return path;
    }

    final dir = p.dirname(path);
    final name = p.basenameWithoutExtension(path);
    final ext = p.extension(path);

    int counter = 1;
    String newPath;
    do {
      newPath = p.join(dir, '${name}_$counter$ext');
      counter++;
    } while (File(newPath).existsSync());

    return newPath;
  }

  /// Generate a unique temporary file path.
  String generateTempPath({
    required String extension,
    String? prefix,
  }) {
    final tempDir = Directory.systemTemp.createTempSync('citrus_');
    final id = _uuid.v4().substring(0, 8);
    final name = '${prefix ?? 'temp'}_$id.$extension';
    return p.join(tempDir.path, name);
  }

  /// Generate a unique temporary directory.
  Directory createTempDirectory({String? prefix}) {
    final id = _uuid.v4().substring(0, 8);
    final name = '${prefix ?? 'citrus'}_$id';
    return Directory.systemTemp.createTempSync(name);
  }

  /// Clean up a temporary file.
  void cleanupTempFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Clean up a temporary directory.
  void cleanupTempDirectory(Directory dir) {
    try {
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Validate output path is safe (no path traversal).
  bool isSafeOutputPath(String outputPath, {String? allowedRoot}) {
    try {
      final normalized = p.normalize(p.absolute(outputPath));

      if (allowedRoot != null) {
        final allowedNormalized = p.normalize(p.absolute(allowedRoot));
        if (!normalized.startsWith(allowedNormalized)) {
          return false;
        }
      }

      // Check for suspicious patterns
      if (normalized.contains('..')) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the output directory for a file.
  String getOutputDirectory(String filePath) {
    return File(filePath).parent.path;
  }

  /// Ensure a directory exists.
  Future<Directory> ensureDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

/// Global output service instance.
final outputService = OutputService();
