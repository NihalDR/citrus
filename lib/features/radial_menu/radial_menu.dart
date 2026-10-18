/// Circular radial menu widget for quick action selection.

import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:citrus/core/models/models.dart';

/// Radial menu for selecting conversion actions.
class RadialMenu extends StatefulWidget {
  final List<ConversionAction> actions;
  final FileMetadata? centerFile;
  final Offset position;
  final VoidCallback onDismiss;
  final Function(ConversionAction, Map<String, dynamic>) onActionSelected;

  const RadialMenu({
    super.key,
    required this.actions,
    this.centerFile,
    required this.position,
    required this.onDismiss,
    required this.onActionSelected,
  });

  @override
  State<RadialMenu> createState() => _RadialMenuState();

  /// Show the radial menu as an overlay.
  static OverlayEntry show({
    required BuildContext context,
    required List<ConversionAction> actions,
    FileMetadata? centerFile,
    required Offset position,
    required Function(ConversionAction, Map<String, dynamic>) onActionSelected,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => _RadialMenuOverlay(
        actions: actions,
        centerFile: centerFile,
        position: position,
        onActionSelected: onActionSelected,
      ),
    );
    overlay.insert(entry);
    return entry;
  }
}

class _RadialMenuOverlay extends StatelessWidget {
  final List<ConversionAction> actions;
  final FileMetadata? centerFile;
  final Offset position;
  final Function(ConversionAction, Map<String, dynamic>) onActionSelected;

  const _RadialMenuOverlay({
    required this.actions,
    this.centerFile,
    required this.position,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay for dismiss
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        // Radial menu positioned at the given position
        Positioned(
          left: position.dx - 150,
          top: position.dy - 150,
          child: RadialMenu(
            actions: actions,
            centerFile: centerFile,
            position: position,
            onDismiss: () => Navigator.of(context).pop(),
            onActionSelected: onActionSelected,
          ),
        ),
      ],
    );
  }
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  int _hoveredIndex = -1;
  int _selectedIndex = -1;

  static const double _menuRadius = 120.0;
  static const double _centerRadius = 60.0;
  static const double _itemRadius = 44.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = widget.actions;
    final itemCount = actions.length;

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onHover: (_) {},
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: _RadialMenuPainter(
                    itemCount: itemCount,
                    hoveredIndex: _hoveredIndex,
                    selectedIndex: _selectedIndex,
                    theme: theme,
                  ),
                  child: Stack(
                    children: [
                      // Center file preview
                      Center(
                        child: _buildCenterItem(theme),
                      ),
                      // Action items around the circle
                      ...List.generate(itemCount, (index) {
                        final angle = _getItemAngle(index, itemCount);
                        final dx = _menuRadius * math.cos(angle);
                        final dy = _menuRadius * math.sin(angle);

                        return Positioned(
                          left: 150 + dx - _itemRadius,
                          top: 150 + dy - _itemRadius,
                          child: _buildActionItem(
                            context,
                            actions[index],
                            index,
                            angle,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterItem(ThemeData theme) {
    final file = widget.centerFile;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = -1),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          width: _centerRadius * 2,
          height: _centerRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: file != null && file.isImage
                ? ClipOval(
                    child: Image.file(
                      File(file.path),
                      width: _centerRadius * 1.5,
                      height: _centerRadius * 1.5,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    _getCategoryIcon(file?.category),
                    size: _centerRadius,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    ConversionAction action,
    int index,
    double angle,
  ) {
    final theme = Theme.of(context);
    final isHovered = _hoveredIndex == index;
    final isSelected = _selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _selectedIndex = index),
        onTapUp: (_) {
          setState(() => _selectedIndex = -1);
          _handleActionSelected(action);
        },
        onTapCancel: () => setState(() => _selectedIndex = -1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _itemRadius * 2,
          height: _itemRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHovered || isSelected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            border: Border.all(
              color: isHovered || isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isHovered || isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isHovered || isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  action.icon,
                  size: 24,
                  color: isHovered || isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 2),
                Text(
                  action.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHovered || isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleActionSelected(ConversionAction action) {
    // Get default parameters for the action
    final parameters = <String, dynamic>{};
    for (final param in action.parameters) {
      if (param.defaultValue != null) {
        parameters[param.id] = param.defaultValue;
      }
    }
    widget.onActionSelected(action, parameters);
    widget.onDismiss();
  }

  double _getItemAngle(int index, int count) {
    // Start from top (-pi/2) and distribute clockwise
    return -math.pi / 2 + (2 * math.pi * index / count);
  }

  IconData _getCategoryIcon(FileCategory? category) {
    switch (category) {
      case FileCategory.image:
        return Icons.image_outlined;
      case FileCategory.video:
        return Icons.video_file_outlined;
      case FileCategory.audio:
        return Icons.audio_file_outlined;
      case FileCategory.document:
        return Icons.picture_as_pdf_outlined;
      case FileCategory.archive:
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class _RadialMenuPainter extends CustomPainter {
  final int itemCount;
  final int hoveredIndex;
  final int selectedIndex;
  final ThemeData theme;

  _RadialMenuPainter({
    required this.itemCount,
    required this.hoveredIndex,
    required this.selectedIndex,
    required this.theme,
  });

  static const double _menuRadius = 120.0;
  static const double _centerRadius = 60.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw connecting lines from center to items
    final linePaint = Paint()
      ..color = theme.colorScheme.outlineVariant.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < itemCount; i++) {
      final angle = _getItemAngle(i, itemCount);
      final start = Offset(
        center.dx + _centerRadius * math.cos(angle),
        center.dy + _centerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + _menuRadius * math.cos(angle),
        center.dy + _menuRadius * math.sin(angle),
      );

      final isHighlighted = i == hoveredIndex || i == selectedIndex;
      if (isHighlighted) {
        linePaint.color = theme.colorScheme.primary.withOpacity(0.5);
        linePaint.strokeWidth = 2.5;
      } else {
        linePaint.color = theme.colorScheme.outlineVariant.withOpacity(0.3);
        linePaint.strokeWidth = 1.5;
      }

      canvas.drawLine(start, end, linePaint);
    }
  }

  double _getItemAngle(int index, int count) {
    return -math.pi / 2 + (2 * math.pi * index / count);
  }

  @override
  bool shouldRepaint(covariant _RadialMenuPainter oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

/// Accessible list-based alternative to radial menu.
class RadialMenuList extends StatelessWidget {
  final List<ConversionAction> actions;
  final FileMetadata? centerFile;
  final Function(ConversionAction, Map<String, dynamic>) onActionSelected;
  final VoidCallback onDismiss;

  const RadialMenuList({
    super.key,
    required this.actions,
    this.centerFile,
    required this.onActionSelected,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with file preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: centerFile != null && centerFile!.isImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(centerFile!.path),
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            ),
                          )
                        : Icon(
                            _getCategoryIcon(centerFile?.category),
                            color: theme.colorScheme.primary,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          centerFile?.name ?? 'Select Action',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${actions.length} actions available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Action list
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: actions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return _ActionListTile(
                    action: action,
                    onTap: () {
                      final parameters = <String, dynamic>{};
                      for (final param in action.parameters) {
                        if (param.defaultValue != null) {
                          parameters[param.id] = param.defaultValue;
                        }
                      }
                      onActionSelected(action, parameters);
                      onDismiss();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(FileCategory? category) {
    switch (category) {
      case FileCategory.image:
        return Icons.image_outlined;
      case FileCategory.video:
        return Icons.video_file_outlined;
      case FileCategory.audio:
        return Icons.audio_file_outlined;
      case FileCategory.document:
        return Icons.picture_as_pdf_outlined;
      case FileCategory.archive:
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class _ActionListTile extends StatelessWidget {
  final ConversionAction action;
  final VoidCallback onTap;

  const _ActionListTile({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  action.icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      action.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  action.category.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
