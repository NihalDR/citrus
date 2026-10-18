# Project Memory

## Session History

### 2026-10-18 - Initial Implementation (Phase 1 Complete)

**Objective**: Build Citrus - Windows-first file conversion utility inspired by Tangerine for macOS

**Starting State**: Empty workspace at `C:\Users\nihal\Desktop\tangerine -free`

**Actions Taken**:
1. Verified Flutter/Dart environment (Flutter 3.22.2, Dart 3.11.4)
2. Created Flutter project with Windows platform support
3. Designed and implemented complete Phase 1 architecture:
   - Core models (FileMetadata, JobItem, BatchJob, ConversionAction, etc.)
   - Services (ActionRegistry, FileDetectionService, OutputService, JobQueueService)
   - Features (Dashboard, RadialMenu, DropZone, ImageTools, BatchJobs, History, Settings)
   - Theme system (Material 3, light/dark)
   - Error handling hierarchy
4. Fixed all analysis errors (46 warnings remain - style only)
5. Formatted codebase with `dart format`
6. Ran tests - all passing
7. Built release executable successfully

**Key Decisions**:
- Removed `const` from `ConversionAction` to allow non-const `ActionParameter` lists with complex defaults
- Used `img.Interpolation.cubic` instead of `lanczos3` (not available in image package v4)
- Removed `hotkey_manager` and `file_selector_windows` due to version conflicts
- Changed `listTileTheme` from `const` to non-const to fix theme constructor issues
- Made `JobQueuePanel` use `Flexible` + `ConstrainedBox` to fix test overflow

**Files Created**: ~35 source files + documentation

**Build Output**: `build/windows/x64/runner/Release/citrus.exe`

---

## Technical Context

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.6
  image: ^4.12.0           # Image processing
  path: ^1.9.0             # Path manipulation
  mime: ^1.0.6             # MIME detection
  provider: ^6.1.2         # State management
  json_annotation: ^4.9.0  # Serialization
  shared_preferences: ^2.3.3  # Settings
  file_selector: ^1.0.3    # Native dialogs
  system_tray: ^2.0.3      # Tray (future)
  window_manager: ^0.3.8   # Window control (future)
  logging: ^1.2.0
  uuid: ^3.0.7
  path_provider: ^2.1.3
```

### Project Structure
```
citrus/
├── lib/
│   ├── main.dart
│   ├── app/app.dart, theme.dart
│   ├── core/models/models.dart
│   ├── core/actions/action_registry.dart
│   ├── core/errors/app_errors.dart
│   ├── features/
│   │   ├── dashboard/ (screen, controller)
│   │   ├── radial_menu/radial_menu.dart
│   │   ├── file_drop/drop_zone.dart
│   │   ├── image_tools/image_actions.dart (6 actions)
│   │   ├── batch_jobs/job_queue_panel.dart
│   │   ├── history/recent_files_panel.dart
│   │   └── settings/settings_provider.dart
│   ├── services/ (4 services)
│   └── platform/windows_integration.dart
├── windows/ (Flutter runner)
├── test/widget_test.dart
├── docs/ (architecture, formats, windows_integration)
├── PRD.md, Architecture.md, Rules.md, Phases.md, Design.md, Memory.md
└── README.md
```

---

## Implemented Actions (Phase 1)

| Action | ID | Category | Formats |
|--------|-----|----------|---------|
| ConvertToPngAction | `convert_to_png` | convert | in: all images → out: png |
| ConvertToJpegAction | `convert_to_jpeg` | convert | in: all images → out: jpg |
| ConvertToWebpAction | `convert_to_webp` | convert | in: all images → out: webp |
| ResizeImageAction | `resize_image` | edit | in/out: all images |
| CropImageAction | `crop_image` | edit | in/out: all images |
| RotateFlipImageAction | `rotate_flip_image` | edit | in/out: all images |

---

## Known Issues / Technical Debt

| Issue | Severity | Phase |
|-------|----------|-------|
| HEIC/HEIF requires paid Windows codec | Medium | 2 |
| Large images load entirely into memory | High | 3 |
| No EXIF/metadata preservation | Medium | 2 |
| Radial menu max 8 actions (UI) | Low | 3 |
| No integration tests | Medium | 2 |
| No auto-update mechanism | Low | 5 |

---

## Commands Reference

```bash
# Development
flutter pub get                    # Install deps
flutter run -d windows             # Debug run
flutter test                       # Run tests
flutter analyze                    # Static analysis
dart format .                      # Format code

# Release
flutter build windows --release    # Build release
# Output: build/windows/x64/runner/Release/citrus.exe

# Debug
flutter clean                      # Clean build
flutter pub upgrade                # Update deps
```

---

## Next Session Priorities

1. **Phase 2**: Video/Audio/PDF/Archive support
   - Bundle FFmpeg
   - Create FFmpeg service
   - Implement video actions
   
2. **Phase 3**: Polish
   - SQLite history
   - Presets system
   - Keyboard shortcuts

3. **Phase 4**: Windows Integration
   - System tray (C++)
   - Global hotkey (C++)
   - Shift-drag hook (C++)

---

## Architecture Notes for Future Work

### Adding Video Support
1. Add `ffmpeg` binary to `windows/runner/assets/`
2. Create `VideoProcessingService` with `Process.run`
3. Parse progress from stderr (time=, speed=)
4. Register `VideoConversionAction` classes
5. Update `FileDetectionService` for video metadata

### Windows Native Integration
- Interface: `lib/platform/windows_integration.dart`
- Implementation: `windows/runner/citrus_windows.cpp`
- Channel: `MethodChannel('citrus/windows')`
- Events: `EventChannel('citrus/windows/events')`

### Testing Strategy
- Unit: mock services, temp dirs
- Widget: pump with providers
- Integration: full flows, real files in temp

---

## Environment Details

- **OS**: Windows 10/11 x64
- **Flutter**: 3.22.2 (stable)
- **Dart**: 3.11.4
- **IDE**: VS Code / Android Studio
- **Git**: Not initialized (manual tracking)

---

## Useful References

- [Flutter Windows Desktop](https://docs.flutter.dev/platform-integration/windows)
- [image package](https://pub.dev/packages/image)
- [MethodChannel](https://docs.flutter.dev/platform-integration/platform-channels)
- [Windows Hooks](https://learn.microsoft.com/en-us/windows/win32/winmsg/hooks)
- [IFileOpenDialog](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-ifileopendialog)