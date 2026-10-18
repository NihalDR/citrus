# Architecture Overview

## High-Level Design

Citrus follows a modular, service-oriented architecture with clear separation between UI, business logic, and platform integration.

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter UI Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │  Dashboard  │ │ Radial Menu │ │ Job Queue   │   ...      │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘            │
└─────────┼────────────────┼────────────────┼──────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                     Service Layer                           │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │  Action      │ │  Job Queue   │ │  Output      │        │
│  │  Registry    │ │  Service     │ │  Service     │        │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘        │
│         │                │                │                 │
│         ▼                ▼                ▼                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │  File        │ │  Image       │ │  Video/Audio │        │
│  │  Detection   │ │  Processing  │ │  Processing  │        │
│  └──────────────┘ └──────────────┘ └──────┬───────┘        │
└────────────────────────────────────────────┼────────────────┘
                                             │
                                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  Platform Integration Layer                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │  Windows     │ │  File System │ │  FFmpeg      │        │
│  │  Native API  │ │  Access      │ │  Process     │        │
│  └──────────────┘ └──────────────┘ └──────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## Core Concepts

### ConversionAction
Base abstraction for all file operations. Each action:
- Declares supported input/output formats
- Defines configurable parameters with validation
- Implements `execute()` with progress/cancellation
- Registered in `ActionRegistry` for discovery

### FileMetadata
Rich file information including:
- Path, name, extension, size, timestamps
- Category (image/video/audio/document/archive)
- Format-specific enums (ImageFormat, VideoFormat, etc.)
- Additional metadata (dimensions, MIME type)

### Job System
- **BatchJob**: Container for related conversions
- **JobItem**: Individual file conversion with status/progress
- **JobQueueService**: Manages lifecycle, concurrency, persistence

### OutputService
- Generates collision-free output paths
- Handles temp file/directory management
- Validates path safety (no traversal)

## Data Flow

### File Drop → Conversion
1. User drops files on `DropZone`
2. `DashboardController.handleFilesDropped()` called
3. `FileDetectionService.detectFiles()` identifies formats
4. Compatible actions fetched from `ActionRegistry`
5. User selects action via radial menu or UI
6. `JobQueueService.addJob()` creates batch job
7. Conversion runs in background (isolates for heavy ops)
8. Progress updates via streams
9. Results saved via `OutputService`
10. History updated

### Radial Menu Invocation
1. Files selected in Explorer + Shift-drag (future) OR in-app selection
2. `RadialMenu.show()` creates overlay entry
3. Actions filtered by `ActionRegistry.getCompatibleActions()`
4. User selects action → parameters dialog (future) → job created

## Concurrency Model

- UI runs on main isolate
- Heavy processing (image/video) uses `compute()` for background isolates
- `JobQueueService` limits concurrent jobs (default 3)
- Each `JobItem` tracks own progress independently
- Cancellation via `CancellationToken` propagated to workers

## Extensibility

### Adding New Actions
1. Create class extending `ConversionAction`
2. Implement required methods
3. Register in `registerImageActions()` or equivalent
4. No UI changes needed - auto-discovered

### Adding New Formats
1. Add enum value to appropriate format enum
2. Update `FileMetadata.fromPath()` detection
3. Add decoder/encoder to processing service
4. Register conversion actions

### Platform Integration
- Interface defined in `windows_integration.dart`
- Implemented via `MethodChannel` to native code
- Native code in `windows/runner/` (C++/WinRT)

## State Management

- `ChangeNotifier` for reactive UI (SettingsProvider, DashboardController)
- `Provider` for dependency injection
- Streams for real-time job updates
- `SharedPreferences` for persistent settings

## Error Handling

Custom exception hierarchy:
- `AppError` (base)
- `FileOperationError` (I/O failures)
- `ConversionError` (processing failures)
- `IncompatibleActionError` (validation)
- `OutputNamingError` (path generation)
- `JobCancelledError` (user cancellation)
- `ExternalProcessError` (FFmpeg/child processes)

All errors include context (paths, operation, original error) for debugging.

## Testing Strategy

- **Unit tests**: Services, models, action logic
- **Widget tests**: UI components, radial menu, job cards
- **Integration tests**: Full drop → convert → save flows
- **Temp directories**: Isolated file system for tests
- **Mock services**: For testing UI without processing

## Performance Considerations

- Streaming/chunked processing for large files (future)
- Background isolates for CPU-intensive work
- Thumbnail generation for previews
- Lazy loading of recent files
- Efficient list rendering with `ListView.builder`