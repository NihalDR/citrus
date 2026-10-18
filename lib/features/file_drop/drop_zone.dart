/// Drag and drop zone widget.

import 'package:flutter/material.dart';

typedef OnFilesDropped = void Function(List<String> filePaths);

class DropZone extends StatefulWidget {
  final OnFilesDropped onFilesDropped;
  final bool isDragOver;

  const DropZone({
    super.key,
    required this.onFilesDropped,
    required this.isDragOver,
  });

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDragOver = widget.isDragOver || _isHovered;

    return DragTarget<List<String>>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        widget.onFilesDropped(details.data);
      },
      onLeave: (_) {
        // Handled by hover
      },
      builder: (context, candidateData, rejectedData) {
        final isActive = candidateData.isNotEmpty || isDragOver;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primaryContainer.withOpacity(0.5)
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: isActive ? 2 : 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 64,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isActive ? 'Drop files here' : 'Drag & drop files here',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isActive ? 'Release to add files' : 'or click to browse',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Browse Files'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Supported: Images, Videos, Audio, PDFs, Archives',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFiles() async {
    // File picking will be implemented with file_selector package
    // For now, this is a placeholder
  }
}

/// File drop handler for Windows integration.
class FileDropHandler {
  // TODO: Implement platform channel for Windows file drop
  // static const MethodChannel _channel = MethodChannel('citrus/file_drop');

  static Future<List<String>> pickFiles() async {
    // TODO: Implement file picker via platform channel
    return [];
  }

  static Future<void> initialize() async {
    // TODO: Set up method channel handler
  }
}
