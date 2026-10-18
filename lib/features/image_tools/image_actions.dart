/// Image conversion and editing actions.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:citrus/core/models/models.dart';
import 'package:citrus/core/actions/action_registry.dart';
import 'package:citrus/core/errors/app_errors.dart';
import 'package:citrus/services/output_service.dart';

/// Convert image to PNG format.
class ConvertToPngAction extends ConversionAction {
  ConvertToPngAction()
      : super(
          id: 'convert_to_png',
          displayName: 'PNG',
          description: 'Convert to PNG format',
          icon: Icons.image_outlined,
          category: ActionCategory.convert,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: const ['png'],
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'preserve_transparency',
              label: 'Preserve Transparency',
              type: ParameterType.boolean,
              defaultValue: true,
              description: 'Keep transparent background if present',
            ),
            ActionParameter(
              id: 'compression_level',
              label: 'Compression Level',
              type: ParameterType.integer,
              defaultValue: 6,
              minValue: 0,
              maxValue: 9,
              description: 'PNG compression level (0-9)',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) =>
      'png';

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: 'png',
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Processing...');
      cancellationToken.throwIfCancelled();

      final preserveTransparency =
          parameters['preserve_transparency'] as bool? ?? true;
      final compressionLevel = parameters['compression_level'] as int? ?? 6;

      img.Image outputImage = image;

      if (!preserveTransparency && image.numChannels == 4) {
        // Flatten transparent image onto white background
        outputImage =
            img.Image(width: image.width, height: image.height, numChannels: 3);
        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            final pixel = image.getPixel(x, y);
            final alpha = pixel.a / 255.0;
            outputImage.setPixelRgba(
              x,
              y,
              (pixel.r * alpha + 255 * (1 - alpha)).round(),
              (pixel.g * alpha + 255 * (1 - alpha)).round(),
              (pixel.b * alpha + 255 * (1 - alpha)).round(),
              255,
            );
          }
        }
      }

      onProgress(0.7, 'Encoding PNG...');
      cancellationToken.throwIfCancelled();

      final pngBytes = img.encodePng(outputImage, level: compressionLevel);
      await File(outputPath).writeAsBytes(pngBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath);
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('PNG conversion failed: $e');
    }
  }
}

/// Convert image to JPEG format.
class ConvertToJpegAction extends ConversionAction {
  ConvertToJpegAction()
      : super(
          id: 'convert_to_jpeg',
          displayName: 'JPEG',
          description: 'Convert to JPEG format',
          icon: Icons.image_outlined,
          category: ActionCategory.convert,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: const ['jpg', 'jpeg'],
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'quality',
              label: 'Quality',
              type: ParameterType.integer,
              defaultValue: 85,
              minValue: 1,
              maxValue: 100,
              description: 'JPEG quality (1-100)',
            ),
            ActionParameter(
              id: 'background_color',
              label: 'Background Color',
              type: ParameterType.color,
              defaultValue: 0xFFFFFFFF,
              description: 'Background color for transparent images',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) =>
      'jpg';

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: 'jpg',
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Processing...');
      cancellationToken.throwIfCancelled();

      final quality = parameters['quality'] as int? ?? 85;
      final backgroundColor =
          parameters['background_color'] as int? ?? 0xFFFFFFFF;

      img.Image outputImage = image;

      // Handle transparency by flattening onto background
      if (image.numChannels == 4) {
        final bgR = (backgroundColor >> 16) & 0xFF;
        final bgG = (backgroundColor >> 8) & 0xFF;
        final bgB = backgroundColor & 0xFF;

        outputImage =
            img.Image(width: image.width, height: image.height, numChannels: 3);
        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            final pixel = image.getPixel(x, y);
            final alpha = pixel.a / 255.0;
            outputImage.setPixelRgba(
              x,
              y,
              (pixel.r * alpha + bgR * (1 - alpha)).round(),
              (pixel.g * alpha + bgG * (1 - alpha)).round(),
              (pixel.b * alpha + bgB * (1 - alpha)).round(),
              255,
            );
          }
        }
      }

      onProgress(0.7, 'Encoding JPEG...');
      cancellationToken.throwIfCancelled();

      final jpgBytes = img.encodeJpg(outputImage, quality: quality);
      await File(outputPath).writeAsBytes(jpgBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath);
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('JPEG conversion failed: $e');
    }
  }
}

/// Convert image to WebP format.
class ConvertToWebpAction extends ConversionAction {
  ConvertToWebpAction()
      : super(
          id: 'convert_to_webp',
          displayName: 'WebP',
          description: 'Convert to WebP format',
          icon: Icons.image_outlined,
          category: ActionCategory.convert,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: const ['webp'],
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'quality',
              label: 'Quality',
              type: ParameterType.integer,
              defaultValue: 80,
              minValue: 1,
              maxValue: 100,
              description: 'WebP quality (1-100)',
            ),
            ActionParameter(
              id: 'lossless',
              label: 'Lossless',
              type: ParameterType.boolean,
              defaultValue: false,
              description: 'Use lossless compression',
            ),
            ActionParameter(
              id: 'preserve_transparency',
              label: 'Preserve Transparency',
              type: ParameterType.boolean,
              defaultValue: true,
              description: 'Keep transparent background if present',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) =>
      'webp';

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: 'webp',
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Processing...');
      cancellationToken.throwIfCancelled();

      final quality = parameters['quality'] as int? ?? 80;
      final lossless = parameters['lossless'] as bool? ?? false;
      final preserveTransparency =
          parameters['preserve_transparency'] as bool? ?? true;

      img.Image outputImage = image;

      if (!preserveTransparency && image.numChannels == 4) {
        outputImage =
            img.Image(width: image.width, height: image.height, numChannels: 3);
        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            final pixel = image.getPixel(x, y);
            final alpha = pixel.a / 255.0;
            outputImage.setPixelRgba(
              x,
              y,
              (pixel.r * alpha + 255 * (1 - alpha)).round(),
              (pixel.g * alpha + 255 * (1 - alpha)).round(),
              (pixel.b * alpha + 255 * (1 - alpha)).round(),
              255,
            );
          }
        }
      }

      onProgress(0.7, 'Encoding WebP...');
      cancellationToken.throwIfCancelled();

      final webpBytes = img.encodeWebP(
        outputImage,
        quality: quality,
        lossless: lossless,
      );
      await File(outputPath).writeAsBytes(webpBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath);
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('WebP conversion failed: $e');
    }
  }
}

/// Resize image action.
class ResizeImageAction extends ConversionAction {
  ResizeImageAction()
      : super(
          id: 'resize_image',
          displayName: 'Resize',
          description: 'Resize image by dimensions or percentage',
          icon: Icons.crop_outlined,
          category: ActionCategory.edit,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: ImageFormat.supportedExtensions,
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'mode',
              label: 'Resize Mode',
              type: ParameterType.enumSelect,
              defaultValue: 'dimensions',
              options: const <String>[
                'dimensions',
                'percentage',
                'width_only',
                'height_only'
              ],
              description: 'How to specify new size',
            ),
            ActionParameter(
              id: 'width',
              label: 'Width',
              type: ParameterType.integer,
              defaultValue: 1920,
              minValue: 1,
              maxValue: 10000,
              description: 'Target width in pixels',
            ),
            ActionParameter(
              id: 'height',
              label: 'Height',
              type: ParameterType.integer,
              defaultValue: 1080,
              minValue: 1,
              maxValue: 10000,
              description: 'Target height in pixels',
            ),
            ActionParameter(
              id: 'percentage',
              label: 'Percentage',
              type: ParameterType.integer,
              defaultValue: 50,
              minValue: 1,
              maxValue: 500,
              description: 'Scale percentage',
            ),
            ActionParameter(
              id: 'maintain_aspect',
              label: 'Maintain Aspect Ratio',
              type: ParameterType.boolean,
              defaultValue: true,
              description: 'Preserve original aspect ratio',
            ),
            ActionParameter(
              id: 'resample_filter',
              label: 'Resample Filter',
              type: ParameterType.enumSelect,
              defaultValue: 'lanczos',
              options: const <String>['nearest', 'linear', 'cubic', 'lanczos'],
              description: 'Resampling algorithm',
            ),
            ActionParameter(
              id: 'output_format',
              label: 'Output Format',
              type: ParameterType.enumSelect,
              defaultValue: 'same',
              options: const <String>['same', 'png', 'jpg', 'webp'],
              description: 'Output format (same = keep original)',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) {
    final outputFormat = parameters['output_format'] as String? ?? 'same';
    return outputFormat == 'same' ? inputFormat : outputFormat;
  }

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    final outputFormat = getOutputFormat(
      FileMetadata.fromPath(inputPath).extension,
      parameters,
    );
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: outputFormat,
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Resizing...');
      cancellationToken.throwIfCancelled();

      final mode = parameters['mode'] as String? ?? 'dimensions';
      final maintainAspect = parameters['maintain_aspect'] as bool? ?? true;
      final filter =
          _getFilter(parameters['resample_filter'] as String? ?? 'lanczos');

      int targetWidth = image.width;
      int targetHeight = image.height;

      switch (mode) {
        case 'dimensions':
          targetWidth = parameters['width'] as int? ?? image.width;
          targetHeight = parameters['height'] as int? ?? image.height;
          if (maintainAspect) {
            final aspectRatio = image.width / image.height;
            if (targetWidth / targetHeight > aspectRatio) {
              targetWidth = (targetHeight * aspectRatio).round();
            } else {
              targetHeight = (targetWidth / aspectRatio).round();
            }
          }
          break;
        case 'percentage':
          final percentage = parameters['percentage'] as int? ?? 100;
          final scale = percentage / 100.0;
          targetWidth = (image.width * scale).round();
          targetHeight = (image.height * scale).round();
          break;
        case 'width_only':
          targetWidth = parameters['width'] as int? ?? image.width;
          if (maintainAspect) {
            targetHeight = (targetWidth / (image.width / image.height)).round();
          }
          break;
        case 'height_only':
          targetHeight = parameters['height'] as int? ?? image.height;
          if (maintainAspect) {
            targetWidth = (targetHeight * (image.width / image.height)).round();
          }
          break;
      }

      final resized = img.copyResize(
        image,
        width: targetWidth,
        height: targetHeight,
        interpolation: filter,
      );

      onProgress(0.7, 'Encoding...');
      cancellationToken.throwIfCancelled();

      final outputFormat = getOutputFormat(
        FileMetadata.fromPath(inputPath).extension,
        parameters,
      );
      final encodedBytes = _encodeImage(resized, outputFormat, outputPath);
      await File(outputPath).writeAsBytes(encodedBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath, metadata: {
        'original_width': image.width,
        'original_height': image.height,
        'new_width': targetWidth,
        'new_height': targetHeight,
      });
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('Resize failed: $e');
    }
  }

  img.Interpolation _getFilter(String filter) {
    switch (filter) {
      case 'nearest':
        return img.Interpolation.nearest;
      case 'linear':
        return img.Interpolation.linear;
      case 'cubic':
        return img.Interpolation.cubic;
      case 'lanczos':
      default:
        return img.Interpolation.cubic;
    }
  }

  List<int> _encodeImage(img.Image image, String format, String outputPath) {
    switch (format) {
      case 'png':
        return img.encodePng(image);
      case 'jpg':
      case 'jpeg':
        return img.encodeJpg(image, quality: 85);
      case 'webp':
        return img.encodeWebP(image, quality: 80);
      default:
        // Determine from output path extension
        if (outputPath.toLowerCase().endsWith('.png')) {
          return img.encodePng(image);
        } else if (outputPath.toLowerCase().endsWith('.webp')) {
          return img.encodeWebP(image, quality: 80);
        }
        return img.encodeJpg(image, quality: 85);
    }
  }
}

/// Crop image action.
class CropImageAction extends ConversionAction {
  CropImageAction()
      : super(
          id: 'crop_image',
          displayName: 'Crop',
          description: 'Crop image to specific region',
          icon: Icons.crop_outlined,
          category: ActionCategory.edit,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: ImageFormat.supportedExtensions,
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'x',
              label: 'X Position',
              type: ParameterType.integer,
              defaultValue: 0,
              minValue: 0,
              description: 'Left position of crop rectangle',
            ),
            ActionParameter(
              id: 'y',
              label: 'Y Position',
              type: ParameterType.integer,
              defaultValue: 0,
              minValue: 0,
              description: 'Top position of crop rectangle',
            ),
            ActionParameter(
              id: 'width',
              label: 'Width',
              type: ParameterType.integer,
              defaultValue: 100,
              minValue: 1,
              description: 'Width of crop rectangle',
            ),
            ActionParameter(
              id: 'height',
              label: 'Height',
              type: ParameterType.integer,
              defaultValue: 100,
              minValue: 1,
              description: 'Height of crop rectangle',
            ),
            ActionParameter(
              id: 'output_format',
              label: 'Output Format',
              type: ParameterType.enumSelect,
              defaultValue: 'same',
              options: const <String>['same', 'png', 'jpg', 'webp'],
              description: 'Output format (same = keep original)',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) {
    final outputFormat = parameters['output_format'] as String? ?? 'same';
    return outputFormat == 'same' ? inputFormat : outputFormat;
  }

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    final outputFormat = getOutputFormat(
      FileMetadata.fromPath(inputPath).extension,
      parameters,
    );
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: outputFormat,
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Cropping...');
      cancellationToken.throwIfCancelled();

      final x = parameters['x'] as int? ?? 0;
      final y = parameters['y'] as int? ?? 0;
      final width = parameters['width'] as int? ?? image.width;
      final height = parameters['height'] as int? ?? image.height;

      // Clamp to image bounds
      final clampedX = x.clamp(0, image.width - 1);
      final clampedY = y.clamp(0, image.height - 1);
      final clampedWidth = width.clamp(1, image.width - clampedX);
      final clampedHeight = height.clamp(1, image.height - clampedY);

      final cropped = img.copyCrop(
        image,
        x: clampedX,
        y: clampedY,
        width: clampedWidth,
        height: clampedHeight,
      );

      onProgress(0.7, 'Encoding...');
      cancellationToken.throwIfCancelled();

      final outputFormat = getOutputFormat(
        FileMetadata.fromPath(inputPath).extension,
        parameters,
      );
      final encodedBytes = _encodeImage(cropped, outputFormat, outputPath);
      await File(outputPath).writeAsBytes(encodedBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath, metadata: {
        'crop_x': clampedX,
        'crop_y': clampedY,
        'crop_width': clampedWidth,
        'crop_height': clampedHeight,
      });
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('Crop failed: $e');
    }
  }

  List<int> _encodeImage(img.Image image, String format, String outputPath) {
    switch (format) {
      case 'png':
        return img.encodePng(image);
      case 'jpg':
      case 'jpeg':
        return img.encodeJpg(image, quality: 85);
      case 'webp':
        return img.encodeWebP(image, quality: 80);
      default:
        if (outputPath.toLowerCase().endsWith('.png')) {
          return img.encodePng(image);
        } else if (outputPath.toLowerCase().endsWith('.webp')) {
          return img.encodeWebP(image, quality: 80);
        }
        return img.encodeJpg(image, quality: 85);
    }
  }
}

/// Rotate/Flip image action.
class RotateFlipImageAction extends ConversionAction {
  RotateFlipImageAction()
      : super(
          id: 'rotate_flip_image',
          displayName: 'Rotate/Flip',
          description: 'Rotate or flip image',
          icon: Icons.rotate_right_outlined,
          category: ActionCategory.edit,
          supportedInputFormats: ImageFormat.supportedExtensions,
          supportedOutputFormats: ImageFormat.supportedExtensions,
          parameters: <ActionParameter>[
            ActionParameter(
              id: 'operation',
              label: 'Operation',
              type: ParameterType.enumSelect,
              defaultValue: 'rotate_90',
              options: const <String>[
                'rotate_90',
                'rotate_180',
                'rotate_270',
                'flip_h',
                'flip_v'
              ],
              description: 'Rotation or flip operation',
            ),
            ActionParameter(
              id: 'output_format',
              label: 'Output Format',
              type: ParameterType.enumSelect,
              defaultValue: 'same',
              options: const <String>['same', 'png', 'jpg', 'webp'],
              description: 'Output format (same = keep original)',
            ),
          ],
        );

  @override
  bool isCompatible(FileMetadata metadata) => metadata.isImage;

  @override
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters) {
    final outputFormat = parameters['output_format'] as String? ?? 'same';
    return outputFormat == 'same' ? inputFormat : outputFormat;
  }

  @override
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters) {
    final outputFormat = getOutputFormat(
      FileMetadata.fromPath(inputPath).extension,
      parameters,
    );
    return outputService.generateOutputPath(
      inputPath: inputPath,
      outputFormat: outputFormat,
    );
  }

  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async {
    try {
      onProgress(0.1, 'Reading image...');
      cancellationToken.throwIfCancelled();

      final bytes = await File(inputPath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ConversionResult.failure('Failed to decode image');
      }

      onProgress(0.3, 'Processing...');
      cancellationToken.throwIfCancelled();

      final operation = parameters['operation'] as String? ?? 'rotate_90';
      img.Image result;

      switch (operation) {
        case 'rotate_90':
          result = img.copyRotate(image, angle: 90);
          break;
        case 'rotate_180':
          result = img.copyRotate(image, angle: 180);
          break;
        case 'rotate_270':
          result = img.copyRotate(image, angle: 270);
          break;
        case 'flip_h':
          result = img.flipHorizontal(image);
          break;
        case 'flip_v':
          result = img.flipVertical(image);
          break;
        default:
          result = image;
      }

      onProgress(0.7, 'Encoding...');
      cancellationToken.throwIfCancelled();

      final outputFormat = getOutputFormat(
        FileMetadata.fromPath(inputPath).extension,
        parameters,
      );
      final encodedBytes = _encodeImage(result, outputFormat, outputPath);
      await File(outputPath).writeAsBytes(encodedBytes);

      onProgress(1.0, 'Complete');

      return ConversionResult.success(outputPath, metadata: {
        'operation': operation,
      });
    } catch (e) {
      if (e is JobCancelledError) rethrow;
      return ConversionResult.failure('Rotate/Flip failed: $e');
    }
  }

  List<int> _encodeImage(img.Image image, String format, String outputPath) {
    switch (format) {
      case 'png':
        return img.encodePng(image);
      case 'jpg':
      case 'jpeg':
        return img.encodeJpg(image, quality: 85);
      case 'webp':
        return img.encodeWebP(image, quality: 80);
      default:
        if (outputPath.toLowerCase().endsWith('.png')) {
          return img.encodePng(image);
        } else if (outputPath.toLowerCase().endsWith('.webp')) {
          return img.encodeWebP(image, quality: 80);
        }
        return img.encodeJpg(image, quality: 85);
    }
  }
}

/// Register all image actions.
void registerImageActions() {
  actionRegistry.register(ConvertToPngAction());
  actionRegistry.register(ConvertToJpegAction());
  actionRegistry.register(ConvertToWebpAction());
  actionRegistry.register(ResizeImageAction());
  actionRegistry.register(CropImageAction());
  actionRegistry.register(RotateFlipImageAction());
}
