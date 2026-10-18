# System Architecture

## Overview

Citrus follows a modular, service-oriented architecture with clear separation between UI, business logic, and platform integration. The application is built with Flutter for Windows desktop.

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Flutter UI Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌───────────┐  │
│  │  Dashboard  │  │ Radial Menu │  │ Job Queue   │  │ Settings  │  │
│  │  (Main)     │  │ (Overlay)   │  │ (Panel)     │  │ (Dialog)  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────┬─────┘  │
└─────────┼────────────────┼────────────────┼───────────────┼────────┘
          │                │                │               │
          ▼                ▼                ▼               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Service Layer (Dart)                           │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────┐ │
│  │ Action       │ │ Job Queue    │ │ Output       │ │ File       │ │
│  │ Registry     │ │ Service      │ │ Service      │ │ Detection  │ │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘ └─────┬──────┘ │
│         │                │                │               │         │
│         ▼                ▼                ▼               ▼         │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │
│  │ Image        │ │ Video/Audio  │ │ PDF/Archive  │             │
│  │ Processing   │ │ Processing   │ │ Processing   │             │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘             │
└─────────┼────────────────┼────────────────┼──────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  Platform Integration Layer                         │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────┐ │
│  │ Windows      │ │ File System  │ │ FFmpeg       │ │ Shell      │ │
│  │ Native API   │ │ Access       │ │ Process      │ │ Extensions │ │
│  └──────────────┘ └──────────────┘ └──────────────┘ └────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Data Models (`lib/core/models/models.dart`)

#### FileMetadata
Rich file information container:
```dart
class FileMetadata {
  final String path;
  final String name;
  final String extension;
  final FileCategory category;      // image, video, audio, document, archive, unknown
  final int sizeBytes;
  final DateTime modifiedAt;
  final Map<String, dynamic> additional;  // dimensions, MIME type, etc.
}
```

#### Job System
```dart
class JobItem {
  final String id;
  final String inputPath;
  String? outputPath;
  final String actionId;
  final Map<String, dynamic> parameters;
  JobStatus status;        // pending, queued, running, completed, failed, cancelled
  double progress;
  String? errorMessage;
}

class BatchJob {
  final String id;
  final String name;
  final List<JobItem> items;
  BatchJobStatus status;
  double overallProgress;
}
```

#### Action System
```dart
abstract class ConversionAction {
  final String id;
  final String displayName;
  final String description;
  final IconData icon;
  final ActionCategory category;
  final List<String> supportedInputFormats;
  final List<String> supportedOutputFormats;
  final List<ActionParameter> parameters;
  
  bool isCompatible(FileMetadata metadata);
  String getOutputFormat(String inputFormat, Map<String, dynamic> parameters);
  String generateOutputPath(String inputPath, Map<String, dynamic> parameters);
  Future<ConversionResult> execute({...});
}
```

---

### 2. Services (`lib/services/`)

#### ActionRegistry
Central registry for all conversion actions:
- Register/unregister actions
- Query compatible actions for file(s)
- Group by category
- Batch compatibility intersection

#### FileDetectionService
- Detects file category from extension
- Extracts metadata (size, timestamps)
- Gets image dimensions via `image` package
- MIME type detection via `mime` package

#### OutputService
- Generates collision-free output paths
- Handles temp file/directory management
- Validates path safety (no traversal)
- Batch output path generation

#### JobQueueService
- Manages job lifecycle (add, cancel, retry, clear)
- Concurrency control (default 3 simultaneous)
- Stream-based progress updates
- Status transitions: pending → queued → running → completed/failed/cancelled

---

### 3. Features (`lib/features/`)

| Feature | Responsibility |
|---------|----------------|
| `dashboard` | Main screen, drop zone, quick actions |
| `radial_menu` | Circular overlay menu + accessible list |
| `file_drop` | DragTarget + file picker integration |
| `image_tools` | 6 image actions (PNG, JPEG, WebP, Resize, Crop, Rotate/Flip) |
| `batch_jobs` | Job queue UI with progress cards |
| `history` | Recent files with quick actions |
| `settings` | Theme, output dir, preferences (SharedPreferences) |

---

### 4. Platform Integration (`lib/platform/windows_integration.dart`)

Abstract interface for native Windows features:
```dart
abstract class WindowsIntegration {
  // Tray
  Future<void> initializeTray();
  Future<void> showTrayNotification(String title, String body);
  
  // Window
  Future<void> minimizeToTray();
  Future<void> restoreFromTray();
  Future<void> setLaunchAtStartup(bool enabled);
  
  // Global interactions
  Future<void> registerGlobalShortcut(Hotkey hotkey);
  Future<void> startShiftDragMonitor();
  Future<void> stopShiftDragMonitor();
  
  // Dialogs
  Future<List<String>?> pickFiles({bool multiple = true});
  Future<String?> pickDirectory();
}
```

---

## Data Flow

### File Drop → Conversion
```
User drops files
    ↓
DashboardController.handleFilesDropped(paths)
    ↓
FileDetectionService.detectFiles(paths) → List<FileMetadata>
    ↓
ActionRegistry.getCompatibleActionsForBatch(metadata) → List<Action>
    ↓
User selects action (RadialMenu or UI)
    ↓
JobQueueService.addJob(name, items) → BatchJob
    ↓
Background isolate processes each JobItem
    ↓
ConversionAction.execute(input, output, params, progress, cancel)
    ↓
OutputService.generateOutputPath() → safe path
    ↓
Result saved, JobItem updated via streams
    ↓
UI updates via StreamBuilder/Listenable
    ↓
History updated
```

### Radial Menu Invocation
```
Files selected (in-app or future: Shift-drag)
    ↓
RadialMenu.show(context, actions, file, position)
    ↓
OverlayEntry inserted with CustomPainter menu
    ↓
User clicks action
    ↓
Default parameters collected
    ↓
JobQueueService.addJob() with selected action
    ↓
Menu dismissed, conversion starts
```

---

## Concurrency Model

```
Main Isolate (UI)
    │
    ├── JobQueueService (streams, state)
    │
    └── compute() / Isolate.spawn()
            │
            ├── Image Processing (image package)
            │
            ├── Future: Video Processing (FFmpeg via Process.run)
            │
            └── Future: Audio/PDF/Archive
```

- UI stays responsive on main isolate
- Heavy work offloaded to background isolates
- `CancellationToken` propagated to workers
- Progress callbacks update streams

---

## State Management

| Component | Pattern |
|-----------|---------|
| Settings | `ChangeNotifier` + `SharedPreferences` |
| Dashboard | `ChangeNotifier` (file list, drag state) |
| Job Queue | Streams (`StreamController.broadcast`) |
| Radial Menu | Local `State` + `AnimationController` |
| Theme | `Provider` + `ThemeMode` |

---

## Error Handling

```
AppError (base)
├── FileOperationError (I/O failures)
├── ConversionError (processing failures)
├── IncompatibleActionError (validation)
├── OutputNamingError (path generation)
├── JobCancelledError (user cancellation)
└── ExternalProcessError (FFmpeg/child processes)
```

All errors include: message, code, original error, stack trace, context (paths, operation)

---

## Security Considerations

| Concern | Mitigation |
|---------|------------|
| Path traversal | `OutputService.isSafeOutputPath()` validates |
| Temp file cleanup | Automatic on completion/failure/cancel |
| No code execution | No `eval`, no shell command injection |
| FFmpeg args | Argument list (not string), validated inputs |
| Permissions | Standard user, no admin required |
| Network | None (local-only) |

---

## Extensibility

### Adding New Action
1. Extend `ConversionAction`
2. Implement required methods
3. Register in `registerXxxActions()`
4. Auto-discovered by registry

### Adding New Format
1. Add to format enum
2. Update `FileMetadata.fromPath()`
3. Add decoder/encoder to processing service
4. Register conversion actions

### Platform Integration
- Interface in `windows_integration.dart`
- Implementation in `windows/runner/` (C++/WinRT)
- Communication via `MethodChannel` + `EventChannel`

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Cold start | < 2s |
| Image convert (10MP) | < 3s |
| UI frame rate | 60fps |
| Memory (idle) | < 100MB |
| Memory (converting) | < 500MB |
| Binary size (release) | < 50MB |

---

## Testing Architecture

```
test/
├── unit/           # Services, models, actions
├── widget/         # UI components, radial menu
├── integration/    # Full flows (drop → convert → save)
└── fixtures/       # Test assets
```

- Temp directories for file operations
- Mock services for UI testing
- No real user files modified