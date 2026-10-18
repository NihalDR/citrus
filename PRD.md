# Project Requirement Document (PRD)

## Project: Citrus
**Windows-first file conversion and editing utility inspired by Tangerine for macOS**

---

## 1. Product Vision

Build a local-first Windows desktop utility that makes file conversion and editing accessible directly from the desktop.

### Primary Interaction Flow
1. User selects one or more files in Windows File Explorer
2. User holds Shift and drags the selection
3. Citrus displays a circular radial menu containing compatible operations
4. User selects an operation (PNG, JPEG, WebP, PDF, MP4, MP3, Compress, Crop, Trim, Merge)
5. Citrus processes the file locally and saves result to selected destination
6. Application displays progress, success/failure, and option to open output folder

### Fallback
- Ordinary drag-and-drop into application window

---

## 2. Target Audience

- Windows power users who frequently convert file formats
- Developers, designers, content creators
- Users who prefer local processing over cloud services
- Privacy-conscious users

---

## 3. Core Requirements

### Functional Requirements

| ID | Requirement | Priority | Phase |
|----|-------------|----------|-------|
| FR-01 | Drag-and-drop file input | P0 | 1 |
| FR-02 | Radial menu with compatible actions | P0 | 1 |
| FR-03 | Image conversion (PNG, JPEG, WebP) | P0 | 1 |
| FR-04 | Image editing (resize, crop, rotate, flip) | P0 | 1 |
| FR-05 | Batch processing with job queue | P0 | 1 |
| FR-06 | Progress tracking and cancellation | P0 | 1 |
| FR-07 | Safe output naming (collision handling) | P0 | 1 |
| FR-08 | File format detection | P0 | 1 |
| FR-09 | Settings (theme, output dir, preferences) | P1 | 1 |
| FR-10 | Recent files history | P1 | 1 |
| FR-11 | Video conversion (FFmpeg) | P1 | 2 |
| FR-12 | Audio conversion | P1 | 2 |
| FR-13 | PDF merge/split/convert | P1 | 2 |
| FR-14 | Archive create/extract | P1 | 2 |
| FR-15 | System tray integration | P1 | 3 |
| FR-16 | Global Shift-drag detection | P1 | 4 |
| FR-17 | Launch at startup | P2 | 3 |
| FR-18 | Global keyboard shortcut | P2 | 3 |

### Non-Functional Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-01 | Local-first processing | No network uploads |
| NFR-02 | No admin privileges | Standard user |
| NFR-03 | Memory efficiency | Stream large files |
| NFR-04 | UI responsiveness | <100ms interactions |
| NFR-05 | DPI awareness | Per-monitor v2 |
| NFR-06 | Multi-monitor support | Clamped positioning |
| NFR-07 | Accessibility | Keyboard nav, screen readers |
| NFR-08 | Privacy | No analytics/telemetry |

---

## 4. Supported Formats (Phase 1)

### Images
| Format | Input | Output | Operations |
|--------|-------|--------|------------|
| PNG | ✅ | ✅ | Convert, resize, crop, rotate, flip |
| JPEG | ✅ | ✅ | Convert, resize, crop, rotate, flip |
| WebP | ✅ | ✅ | Convert, resize, crop, rotate, flip |
| BMP | ✅ | ❌ | Detect only |
| GIF | ✅ | ❌ | Detect only |
| TIFF | ✅ | ❌ | Detect only |
| ICO | ✅ | ❌ | Detect only |
| HEIC/HEIF | ⚠️ | ❌ | Requires codec |

---

## 5. User Interface Requirements

### Main Window
- Modern, minimal desktop aesthetic
- Light/dark theme support
- Large drag-and-drop area
- Recent files panel
- Job queue panel
- Quick action cards
- Clear "local processing" indicator

### Radial Menu
- Genuine circular layout (CustomPainter)
- Center file preview
- Actions evenly distributed
- Hover highlight + label
- Keyboard navigation (Esc, Enter, arrows)
- Accessible list alternative
- Clamped to display bounds

---

## 6. Technical Constraints

- **Platform**: Windows 10/11 x64 only (Phase 1)
- **Framework**: Flutter 3.22+ / Dart 3.4+
- **Native**: C++/WinRT via platform channels
- **No web backend**: Pure local processing
- **Dependencies**: Minimal, well-maintained packages

---

## 7. Success Metrics

- Build succeeds on clean Windows machine
- All unit/widget tests pass
- Release build < 50MB
- Cold start < 2 seconds
- Conversion of 10MP image < 3 seconds
- Zero crashes in 1000 operations

---

## 8. Out of Scope (Phase 1)

- macOS/Linux support
- Cloud conversion
- OCR
- Video editing (trim, merge)
- Advanced PDF manipulation
- Plugin system
- Auto-updater