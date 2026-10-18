/// Dashboard controller for managing file drops and state.

import 'package:flutter/material.dart';
import 'package:citrus/core/models/models.dart';
import 'package:citrus/services/file_detection_service.dart';

class DashboardController extends ChangeNotifier {
  final List<FileMetadata> _droppedFiles = [];
  final List<FileMetadata> _recentFiles = [];
  bool _isDragOver = false;

  List<FileMetadata> get droppedFiles => List.unmodifiable(_droppedFiles);
  List<FileMetadata> get recentFiles => List.unmodifiable(_recentFiles);
  bool get isDragOver => _isDragOver;

  void setDragOver(bool value) {
    if (_isDragOver != value) {
      _isDragOver = value;
      notifyListeners();
    }
  }

  Future<void> handleFilesDropped(List<String> filePaths) async {
    setDragOver(false);

    try {
      final metadataList = await fileDetectionService.detectFiles(filePaths);
      final supportedFiles = metadataList
          .where((m) => m.category != FileCategory.unknown)
          .toList();

      if (supportedFiles.isEmpty) {
        // Show error - no supported files
        return;
      }

      for (final file in supportedFiles) {
        if (!_droppedFiles.any((f) => f.path == file.path)) {
          _droppedFiles.add(file);
        }
        _addToRecent(file);
      }

      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Error processing dropped files: $e');
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < _droppedFiles.length) {
      _droppedFiles.removeAt(index);
      notifyListeners();
    }
  }

  void clearFiles() {
    _droppedFiles.clear();
    notifyListeners();
  }

  void _addToRecent(FileMetadata file) {
    _recentFiles.removeWhere((f) => f.path == file.path);
    _recentFiles.insert(0, file);
    if (_recentFiles.length > 20) {
      _recentFiles.removeRange(20, _recentFiles.length);
    }
  }

  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}
