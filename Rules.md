# Code Rules & Conventions

## General Principles

1. **Null Safety**: All code must be null-safe. No `!` without justification.
2. **Immutability**: Prefer `final`/`const`. Use `copyWith` for model updates.
3. **Single Responsibility**: Each class/function does one thing well.
4. **Explicit Errors**: Never swallow exceptions. Use custom error types.
5. **Local-First**: No network calls for file processing. Ever.

---

## Dart/Flutter Conventions

### File Organization
```
lib/
├── core/           # Shared models, errors, utilities
├── features/       # Feature modules (self-contained)
├── services/       # Business logic services
├── platform/       # Platform interfaces
└── app/            # App-level configuration
```

### Naming
| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `file_detection_service.dart` |
| Classes | PascalCase | `FileDetectionService` |
| Variables/Functions | camelCase | `detectFile()` |
| Constants | UPPER_SNAKE | `MAX_CONCURRENT_JOBS` |
| Enums | PascalCase | `FileCategory.image` |
| Private | `_prefix` | `_internalState` |

### Imports
```dart
// 1. Dart core
import 'dart:io';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages (alphabetical)
import 'package:provider/provider.dart';

// 4. Local (relative)
import '../core/models/models.dart';
import 'dashboard_controller.dart';
```

### Widgets
- **Stateless** by default
- **Stateful** only when needed
- Extract sub-widgets for reusability
- Use `const` constructors wherever possible
- `build()` method must be pure (no side effects)

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.value});
  
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Text(value);
  }
}
```

---

## Architecture Patterns

### Services
- Singleton pattern via global instance
- `ChangeNotifier` for reactive state
- Streams for async events
- Interface-first design (abstract class)

```dart
// Interface
abstract class FileService {
  Future<FileMetadata> detectFile(String path);
}

// Implementation
class FileDetectionService implements FileService { ... }

// Global instance
final fileDetectionService = FileDetectionService();
```

### Actions
- Extend `ConversionAction` base class
- All parameters defined as `ActionParameter`
- `execute()` returns `ConversionResult`
- Progress via `ProgressCallback`
- Cancellation via `CancellationToken`

```dart
class MyAction extends ConversionAction {
  MyAction() : super(...);
  
  @override
  Future<ConversionResult> execute({
    required String inputPath,
    required String outputPath,
    required Map<String, dynamic> parameters,
    required ProgressCallback onProgress,
    required CancellationToken cancellationToken,
  }) async { ... }
}
```

### Error Handling
```dart
try {
  await riskyOperation();
} on JobCancelledError {
  rethrow; // Always rethrow cancellation
} on FormatException catch (e) {
  return ConversionResult.failure('Invalid format: $e');
} catch (e, st) {
  return ConversionResult.failure('Unexpected error: $e');
}
```

---

## UI Rules

### Theming
- Use `Theme.of(context)` for colors/spacing
- No hardcoded colors (except brand: `0xFFFF8C00`)
- Support both light/dark themes
- Material 3 components

### Layout
- Responsive: `LayoutBuilder` for breakpoints
- Consistent spacing: 8px base unit
- Rounded corners: 8/12/16px radius
- Subtle shadows for elevation

### Accessibility
- Semantic labels on interactive elements
- Keyboard navigation (focus, Esc, Enter)
- Sufficient contrast ratios
- Screen reader support

---

## File Operations

### Path Handling
```dart
import 'package:path/path.dart' as p;

// Always use path package
final outputPath = p.join(dir, '$name.$ext');
final normalized = p.normalize(p.absolute(path));
```

### Safety
```dart
// Validate before write
if (!outputService.isSafeOutputPath(outputPath, allowedRoot: homeDir)) {
  throw OutputNamingError('Unsafe output path');
}

// Collision handling
final safePath = outputService.generateOutputPath(...);
```

### Cleanup
```dart
// Always clean temp files
final tempDir = outputService.createTempDirectory();
try {
  await process(tempDir);
} finally {
  outputService.cleanupTempDirectory(tempDir);
}
```

---

## Concurrency

### Job Processing
```dart
// Limit concurrency
jobQueueService.maxConcurrentJobs = 3;

// Progress updates
jobQueueService.updateProgress(jobId, itemId, 0.5);

// Cancellation
cancellationToken.throwIfCancelled();
```

### Background Work
```dart
// Use compute for CPU-intensive work
final result = await compute(heavyFunction, input);

// Or Isolate.spawn for streaming
final port = RawReceivePort();
await Isolate.spawn(entryPoint, port.sendPort);
```

---

## Testing

### Unit Tests
- Test services in isolation
- Mock dependencies
- Use temp directories

```dart
test('detectFile returns correct metadata', () async {
  final tempDir = await Directory.systemTemp.createTemp();
  final file = File(p.join(tempDir.path, 'test.png'));
  await file.writeAsBytes(pngBytes);
  
  final metadata = await fileDetectionService.detectFile(file.path);
  
  expect(metadata.category, FileCategory.image);
  expect(metadata.extension, 'png');
});
```

### Widget Tests
- Test UI behavior, not implementation
- Pump widget with providers
- Verify interactions

```dart
testWidgets('DropZone accepts files', (tester) async {
  await tester.pumpWidget(testWidget);
  
  await tester.drag(find.byType(DropZone), Offset(0, -100));
  await tester.pump();
  
  expect(controller.droppedFiles, isNotEmpty);
});
```

---

## Git/Version Control

### Commits
- Atomic, single-purpose commits
- Conventional commit messages:
  ```
  feat: add WebP conversion action
  fix: handle PNG transparency correctly
  refactor: extract _encodeImage helper
  docs: update architecture diagram
  ```

### Branches
- `main` - stable releases
- `develop` - integration branch
- `feature/*` - new features
- `fix/*` - bug fixes

---

## Dependencies

### Adding Packages
1. Check license compatibility (BSD/MIT/Apache preferred)
2. Verify Windows desktop support
3. Prefer pure Dart over native
4. Pin versions in `pubspec.yaml`

### Forbidden
- Analytics/telemetry packages
- Cloud SDKs (Firebase, AWS, etc.)
- Closed-source binaries without audit

---

## Performance

### Do
- Use `ListView.builder` for lists
- `const` widgets where possible
- `compute()` for heavy processing
- Stream large files

### Don't
- Load entire large files into memory
- Block UI isolate
- Rebuild entire tree on small changes
- Use `setState` in loops

---

## Documentation

### Code Comments
- Public APIs: `///` doc comments
- Complex logic: inline `//` comments
- No obvious comments (`// increment counter`)

### Files Requiring Docs
- All public classes
- All services
- All actions
- Platform interfaces