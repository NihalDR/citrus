/// Settings provider for managing application preferences.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _themeModeKey = 'theme_mode';
  static const _outputDirectoryKey = 'output_directory';
  static const _minimizeToTrayKey = 'minimize_to_tray';
  static const _startAtLoginKey = 'start_at_login';
  static const _maxConcurrentJobsKey = 'max_concurrent_jobs';
  static const _preserveMetadataKey = 'preserve_metadata';
  static const _overwriteConfirmationKey = 'overwrite_confirmation';

  ThemeMode _themeMode = ThemeMode.system;
  String? _outputDirectory;
  bool _minimizeToTray = true;
  bool _startAtLogin = false;
  int _maxConcurrentJobs = 3;
  bool _preserveMetadata = true;
  bool _overwriteConfirmation = true;

  ThemeMode get themeMode => _themeMode;
  String? get outputDirectory => _outputDirectory;
  bool get minimizeToTray => _minimizeToTray;
  bool get startAtLogin => _startAtLogin;
  int get maxConcurrentJobs => _maxConcurrentJobs;
  bool get preserveMetadata => _preserveMetadata;
  bool get overwriteConfirmation => _overwriteConfirmation;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = ThemeMode.values[prefs.getInt(_themeModeKey) ?? 0];
    _outputDirectory = prefs.getString(_outputDirectoryKey);
    _minimizeToTray = prefs.getBool(_minimizeToTrayKey) ?? true;
    _startAtLogin = prefs.getBool(_startAtLoginKey) ?? false;
    _maxConcurrentJobs = prefs.getInt(_maxConcurrentJobsKey) ?? 3;
    _preserveMetadata = prefs.getBool(_preserveMetadataKey) ?? true;
    _overwriteConfirmation = prefs.getBool(_overwriteConfirmationKey) ?? true;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setOutputDirectory(String? directory) async {
    _outputDirectory = directory;
    final prefs = await SharedPreferences.getInstance();
    if (directory != null) {
      await prefs.setString(_outputDirectoryKey, directory);
    } else {
      await prefs.remove(_outputDirectoryKey);
    }
    notifyListeners();
  }

  Future<void> setMinimizeToTray(bool value) async {
    _minimizeToTray = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_minimizeToTrayKey, value);
    notifyListeners();
  }

  Future<void> setStartAtLogin(bool value) async {
    _startAtLogin = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_startAtLoginKey, value);
    notifyListeners();
  }

  Future<void> setMaxConcurrentJobs(int value) async {
    _maxConcurrentJobs = value.clamp(1, 10);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxConcurrentJobsKey, _maxConcurrentJobs);
    notifyListeners();
  }

  Future<void> setPreserveMetadata(bool value) async {
    _preserveMetadata = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_preserveMetadataKey, value);
    notifyListeners();
  }

  Future<void> setOverwriteConfirmation(bool value) async {
    _overwriteConfirmation = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_overwriteConfirmationKey, value);
    notifyListeners();
  }
}
