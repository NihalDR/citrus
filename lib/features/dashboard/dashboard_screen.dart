/// Main dashboard screen with drag-and-drop area.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citrus/features/dashboard/dashboard_controller.dart';
import 'package:citrus/features/file_drop/drop_zone.dart';
import 'package:citrus/features/batch_jobs/job_queue_panel.dart';
import 'package:citrus/features/history/recent_files_panel.dart';
import 'package:citrus/services/job_queue_service.dart';
import 'package:citrus/core/models/models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<DashboardController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, controller),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Citrus'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: 'Settings',
        ),
        IconButton(
          icon: const Icon(Icons.history_outlined),
          onPressed: () => Navigator.pushNamed(context, '/history'),
          tooltip: 'History',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context, DashboardController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildMainContent(context, controller),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 360,
                child: _buildSidePanel(context, controller),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(child: _buildMainContent(context, controller)),
              const Divider(height: 1),
              SizedBox(
                height: 300,
                child: _buildSidePanel(context, controller),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildMainContent(
      BuildContext context, DashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          DropZone(
            onFilesDropped: controller.handleFilesDropped,
            isDragOver: controller.isDragOver,
          ),
          const SizedBox(height: 24),
          if (controller.droppedFiles.isNotEmpty) ...[
            _buildDroppedFilesSection(context, controller),
            const SizedBox(height: 24),
          ],
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Convert & Edit Files',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Drag files here or click to browse. Supports images, videos, audio, PDFs, and archives.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDroppedFilesSection(
      BuildContext context, DashboardController controller) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Selected Files (${controller.droppedFiles.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: controller.clearFiles,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.droppedFiles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final file = controller.droppedFiles[index];
              return _FilePreviewCard(
                file: file,
                onRemove: () => controller.removeFile(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _QuickActionCard(
              icon: Icons.image_outlined,
              label: 'Images',
              subtitle: 'Convert, resize, crop',
              onTap: () {},
            ),
            _QuickActionCard(
              icon: Icons.video_file_outlined,
              label: 'Videos',
              subtitle: 'Convert, compress, trim',
              onTap: () {},
            ),
            _QuickActionCard(
              icon: Icons.audio_file_outlined,
              label: 'Audio',
              subtitle: 'Convert, extract, normalize',
              onTap: () {},
            ),
            _QuickActionCard(
              icon: Icons.picture_as_pdf_outlined,
              label: 'PDFs',
              subtitle: 'Merge, split, convert',
              onTap: () {},
            ),
            _QuickActionCard(
              icon: Icons.folder_zip_outlined,
              label: 'Archives',
              subtitle: 'Create, extract, compress',
              onTap: () {},
            ),
            _QuickActionCard(
              icon: Icons.more_horiz_outlined,
              label: 'More',
              subtitle: 'Rename, metadata, etc.',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidePanel(BuildContext context, DashboardController controller) {
    return Consumer<JobQueueService>(
      builder: (context, jobQueue, _) {
        return Column(
          children: [
            Expanded(
              child: JobQueuePanel(jobs: jobQueue.jobs),
            ),
            const Divider(height: 1),
            Expanded(
              child: RecentFilesPanel(recentFiles: controller.recentFiles),
            ),
          ],
        );
      },
    );
  }
}

class _FilePreviewCard extends StatelessWidget {
  final FileMetadata file;
  final VoidCallback onRemove;

  const _FilePreviewCard({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: _buildPreview(theme),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _formatFileSize(file.sizeBytes),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    if (file.isImage) {
      return Image.file(
        File(file.path),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildIconPlaceholder(theme),
      );
    }
    return _buildIconPlaceholder(theme);
  }

  Widget _buildIconPlaceholder(ThemeData theme) {
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
      width: double.infinity,
      color: theme.colorScheme.surface,
      child: Center(
        child: Icon(icon, size: 48, color: color),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
