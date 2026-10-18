/// Recent files panel widget.

import 'package:flutter/material.dart';
import 'package:citrus/core/models/models.dart';

class RecentFilesPanel extends StatelessWidget {
  final List<FileMetadata> recentFiles;

  const RecentFilesPanel({super.key, required this.recentFiles});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Recent Files',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (recentFiles.isNotEmpty)
                TextButton(
                  onPressed: () {},
                  child: const Text('Clear'),
                ),
            ],
          ),
        ),
        if (recentFiles.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recent files',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recentFiles.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 56, endIndent: 16),
              itemBuilder: (context, index) {
                final file = recentFiles[index];
                return _RecentFileTile(file: file);
              },
            ),
          ),
      ],
    );
  }
}

class _RecentFileTile extends StatelessWidget {
  final FileMetadata file;

  const _RecentFileTile({required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildFileIcon(theme),
      title: Text(
        file.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${file.category.name.toUpperCase()} • ${_formatFileSize(file.sizeBytes)} • ${_formatDate(file.modifiedAt)}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleAction(context, value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'open',
            child: Row(
              children: [
                Icon(Icons.open_in_new, size: 18),
                SizedBox(width: 8),
                Text('Open'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'folder',
            child: Row(
              children: [
                Icon(Icons.folder_open, size: 18),
                SizedBox(width: 8),
                Text('Show in Folder'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'convert',
            child: Row(
              children: [
                Icon(Icons.transform, size: 18),
                SizedBox(width: 8),
                Text('Convert Again'),
              ],
            ),
          ),
        ],
      ),
      onTap: () => _handleAction(context, 'open'),
    );
  }

  Widget _buildFileIcon(ThemeData theme) {
    IconData icon;
    Color color;

    switch (file.category) {
      case FileCategory.image:
        icon = Icons.image_outlined;
        color = Colors.blue;
        break;
      case FileCategory.video:
        icon = Icons.video_file_outlined;
        color = Colors.purple;
        break;
      case FileCategory.audio:
        icon = Icons.audio_file_outlined;
        color = Colors.green;
        break;
      case FileCategory.document:
        icon = Icons.picture_as_pdf_outlined;
        color = Colors.red;
        break;
      case FileCategory.archive:
        icon = Icons.folder_zip_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file_outlined;
        color = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'open':
        // Open file
        break;
      case 'folder':
        // Show in folder
        break;
      case 'convert':
        // Add to drop zone
        break;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
