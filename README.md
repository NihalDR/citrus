# Citrus - Windows File Conversion Utility

A local-first Windows desktop utility for file conversion and editing, inspired by Tangerine for macOS.

## Features

### Phase 1 (MVP) - Implemented ✅
- **Main Window**: Modern dashboard with drag-and-drop area
- **Radial Menu**: Circular action menu with hover/click support and accessible list alternative
- **Image Conversion**: PNG, JPEG, WebP format conversion
- **Image Editing**: Resize (dimensions/percentage), Crop, Rotate/Flip
- **Safe Output Naming**: Collision-resistant file naming with automatic numbering
- **Batch Processing**: Job queue with progress tracking, cancellation, retry
- **File Detection**: Automatic format detection with metadata extraction
- **Settings**: Theme (light/dark/system), output directory, preferences
- **History**: Recent files panel with quick actions

### Planned Features (Future Phases)
- Video conversion and editing (FFmpeg integration)
- Audio conversion and editing
- PDF merge, split, and conversion
- Archive creation and extraction
- System tray integration
- Global Shift-drag detection from File Explorer
- Windows startup integration
- Keyboard shortcuts

## Supported Formats

### Images
- **Input**: PNG, JPEG/JPG, WebP, BMP, GIF, TIFF, ICO, HEIC/HEIF
- **Output**: PNG, JPEG, WebP

### Operations
- Format conversion
- Resize by dimensions or percentage (with aspect ratio preservation)
- Crop to custom region
- Rotate (90°, 180°, 270°) and Flip (horizontal/vertical)
- Quality/compression settings
- Transparency preservation options

## Requirements

- Windows 10/11 (x64)
- Flutter SDK 3.22+
- Dart SDK 3.4+
- Visual Studio 2022 with C++ workload (for Windows build)

## Development Setup

```bash
# Clone and navigate
cd citrus

# Install dependencies
flutter pub get

# Run development build
flutter run -d windows

# Run tests
flutter test

# Run static analysis
flutter analyze

# Format code
dart format .

# Build release
flutter build windows --release
```

## Project Structure

```
citrus/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app/
│   │   ├── app.dart              # Main app widget
│   │   └── theme.dart            # Light/dark themes
│   ├── core/
│   │   ├── models/               # Data models (FileMetadata, Job, Action, etc.)
│   │   ├── actions/              # Action registry
│   │   ├── errors/               # Custom exceptions
│   │   └── utilities/            # Helper extensions
│   ├── features/
│   │   ├── dashboard/            # Main screen with drop zone
│   │   ├── radial_menu/          # Circular action menu
│   │   ├── file_drop/            # Drag & drop handling
│   │   ├── conversion/           # Conversion orchestration
│   │   ├── image_tools/          # Image actions (PNG, JPEG, WebP, Resize, Crop, Rotate)
│   │   ├── video_tools/          # Video actions (placeholder)
│   │   ├── audio_tools/          # Audio actions (placeholder)
│   │   ├── pdf_tools/            # PDF actions (placeholder)
│   │   ├── batch_jobs/           # Job queue UI
│   │   ├── history/              # Recent files
│   │   └── settings/             # Settings provider
│   ├── services/
│   │   ├── file_detection_service.dart
│   │   ├── action_registry.dart
│   │   ├── output_service.dart
│   │   └── job_queue_service.dart
│   └── platform/
│       └── windows_integration.dart  # Windows native integration (future)
├── windows/                      # Windows runner project
├── assets/                       # Images, icons
├── test/
│   ├── unit/                     # Unit tests
│   ├── widget/                   # Widget tests
│   └── integration/              # Integration tests
└── docs/
    ├── architecture.md
    ├── supported_formats.md
    └── windows_integration.md
```

## Architecture

### Core Services
- **FileDetectionService**: Detects file types, extracts metadata (dimensions, MIME type)
- **ActionRegistry**: Manages all conversion actions, filters by compatibility
- **OutputService**: Generates safe output paths, handles collisions, temp files
- **JobQueueService**: Manages batch jobs, progress, concurrency, cancellation

### Conversion Actions
Each action implements `ConversionAction`:
- Unique ID, display name, icon, category
- Supported input/output formats
- Configurable parameters with validation
- `execute()` method with progress callback and cancellation support

### Radial Menu
- Built with `CustomPainter` for true circular layout
- Center file preview with actions around circumference
- Mouse hover/click, keyboard navigation (Esc to dismiss)
- Accessible list-based alternative (`RadialMenuList`)

### Job Processing
- Jobs contain multiple `JobItem`s (one per input file)
- Statuses: pending → queued → running → completed/failed/cancelled
- Configurable concurrency limit (default 3)
- Per-item and overall progress tracking
- Retry failed items, cancel individual or entire jobs

## Windows Integration (Planned)

The `windows_integration.dart` file defines the interface for:
- System tray icon with context menu
- Minimize to tray / restore
- Launch at startup
- Global Shift-drag detection via Windows hooks
- Global keyboard shortcut registration
- Native file dialogs

Implementation will use platform channels to C++/WinRT code in `windows/runner/`.

## Privacy & Security

- **Local-first**: No file uploads, no network access for conversions
- **No analytics**: No telemetry or usage tracking
- **Safe paths**: Validates output paths, prevents traversal attacks
- **No admin required**: Runs with standard user permissions
- **Temp cleanup**: Automatic cleanup of temporary files

## License

Proprietary - All rights reserved.

Third-party licenses:
- Flutter (BSD-3)
- image.dart (BSD-3)
- path, mime, uuid, provider, shared_preferences, etc. (various permissive licenses)

## Known Limitations (Phase 1)

1. No video/audio/PDF/archive support yet (placeholders only)
2. No system tray integration
3. No global Shift-drag from File Explorer
4. No Windows startup integration
5. Drag-and-drop only works into app window (not from Explorer globally)
6. HEIC/HEIF decoding may not work without additional codecs
7. Large file handling not optimized (loads entire file into memory)

## Next Steps

See `docs/architecture.md` for detailed implementation plan for Phases 2-5.