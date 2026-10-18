# Project Phases

## Phase 1: Windows MVP ✅ COMPLETED
**Target**: Functional desktop app with core image conversion

### Deliverables
- [x] Flutter Windows project setup
- [x] Main dashboard with drag-and-drop zone
- [x] Radial menu (circular + accessible list)
- [x] Image conversion: PNG, JPEG, WebP
- [x] Image editing: Resize, Crop, Rotate/Flip
- [x] Batch job queue with progress/cancel/retry
- [x] File detection + metadata extraction
- [x] Safe output naming + collision handling
- [x] Settings (theme, output dir, preferences)
- [x] Recent files history
- [x] Light/dark theme support
- [x] Unit + widget tests passing
- [x] Release build successful

### Technical Debt
- [ ] Add integration tests
- [ ] Optimize large image memory usage
- [ ] Add EXIF preservation option

---

## Phase 2: Conversion Platform
**Target**: Video, Audio, PDF, Archive support

### Video (FFmpeg)
- [ ] FFmpeg binary bundling + detection
- [ ] Format conversion (MP4, MOV, MKV, WebM, AVI)
- [ ] Compression (CRF, bitrate presets)
- [ ] Resolution/framerate scaling
- [ ] Trim (start/end time)
- [ ] Audio removal/extraction
- [ ] Thumbnail generation
- [ ] Concatenation (same codec)

### Audio
- [ ] Format conversion (MP3, WAV, AAC, FLAC, OGG, Opus)
- [ ] Bitrate/sample rate options
- [ ] Trim
- [ ] Volume normalization
- [ ] Channel config (mono/stereo)

### PDF
- [ ] Merge multiple PDFs
- [ ] Split by page range
- [ ] Extract pages
- [ ] Reorder/rotate pages
- [ ] Images → PDF
- [ ] Text extraction
- [ ] Compression (ghostscript or native)

### Archives
- [ ] ZIP create/extract
- [ ] TAR/GZIP support
- [ ] Password protection (optional)

### Infrastructure
- [ ] FFmpeg service with command builder
- [ ] Process execution with streaming
- [ ] Progress parsing from FFmpeg output
- [ ] Codec detection + fallback

---

## Phase 3: Productivity & Polish
**Target**: Professional UX, advanced features

### History & Presets
- [ ] Persistent job history (SQLite)
- [ ] Saved conversion presets
- [ ] Export/import presets
- [ ] Search/filter history

### Queue & Concurrency
- [ ] Priority queue (drag to reorder)
- [ ] Pause/resume individual jobs
- [ ] Bandwidth throttling (future network)
- [ ] Smart concurrency (by file type)

### File Operations
- [ ] Batch rename (patterns, regex)
- [ ] Metadata viewer/editor
- [ ] Duplicate detection
- [ ] File size analysis

### UI Enhancements
- [ ] Keyboard shortcuts (all actions)
- [ ] Command palette (Ctrl+P)
- [ ] Drag-from-app to Explorer
- [ ] Progress notifications (Windows toast)
- [ ] High-DPI icons + splash screen

### Performance
- [ ] Streaming large file processing
- [ ] Thumbnail caching
- [ ] Lazy loading history
- [ ] Background isolate pool

---

## Phase 4: Native Windows Integration
**Target**: System-wide Shift-drag workflow

### System Tray
- [ ] Tray icon with context menu
- [ ] Minimize to tray
- [ ] Restore on click
- [ ] Quick actions in tray menu
- [ ] Notification on job complete

### Window Management
- [ ] Single instance enforcement
- [ ] Remember position/size
- [ ] Start minimized option
- [ ] Taskbar integration

### Global Shortcuts
- [ ] Register `Ctrl+Alt+C` (configurable)
- [ ] Show main window
- [ ] Show radial menu at cursor

### Shift-Drag Detection (Core Feature)
- [ ] WH_MOUSE_LL hook implementation
- [ ] Explorer window detection
- [ ] Shift+drag state tracking
- [ ] Selected file extraction via Shell API
- [ ] Radial menu at cursor position
- [ ] Multi-monitor + DPI clamping
- [ ] Graceful fallback (permissions, conflicts)

### Startup Integration
- [ ] Registry `HKCU\Run` entry
- [ ] Minimized to tray on boot
- [ ] User toggle in settings

### File Dialogs
- [ ] Native `IFileOpenDialog` (multi-select)
- [ ] `IFileSaveDialog` for output
- [ ] Folder picker for batch output

### Security & Reliability
- [ ] Hook crash recovery
- [ ] Cleanup on uninstall
- [ ] No admin required
- [ ] Code signing prep

---

## Phase 5: Release Readiness
**Target**: Production-quality distribution

### Quality Assurance
- [ ] Automated test suite (unit/widget/integration)
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Code coverage > 80%
- [ ] Performance benchmarks
- [ ] Memory leak testing
- [ ] Stress testing (1000+ files)

### Packaging
- [ ] MSIX package (Windows Store ready)
- [ ] NSIS installer (traditional)
- [ ] Portable ZIP
- [ ] Auto-update framework
- [ ] Code signing certificate
- [ ] SmartScreen reputation

### Documentation
- [ ] User guide (Markdown + in-app help)
- [ ] Keyboard shortcut reference
- [ ] Supported formats matrix
- [ ] Troubleshooting guide
- [ ] FAQ

### Compliance
- [ ] Privacy policy (local-first statement)
- [ ] Third-party license attribution
- [ ] Accessibility audit (WCAG 2.1 AA)
- [ ] Windows App Certification Kit

### Distribution
- [ ] GitHub Releases
- [ ] Website/download page
- [ ] Chocolatey package
- [ ] Scoop bucket
- [ ] Winget manifest

---

## Phase 6+: Future (Post-Launch)

### Platform Expansion
- [ ] macOS support (native menus, Finder integration)
- [ ] Linux support (AppImage, Flatpak, DBus)

### Advanced Features
- [ ] OCR (Tesseract integration)
- [ ] AI-powered enhancements (local models)
- [ ] Watermarking/batch branding
- [ ] Color profile management
- [ ] Scripting API (Lua/Dart)
- [ ] Plugin architecture

### Cloud (Optional, Opt-in)
- [ ] Cloud storage connectors
- [ ] Share via link (encrypted)
- [ ] Team presets sync

---

## Milestone Timeline (Estimated)

| Phase | Duration | Target Date |
|-------|----------|-------------|
| 1: MVP | 2 weeks | ✅ Done |
| 2: Conversion Platform | 4 weeks | TBD |
| 3: Polish | 3 weeks | TBD |
| 4: Windows Integration | 4 weeks | TBD |
| 5: Release | 2 weeks | TBD |
| **Total** | **~15 weeks** | |

---

## Definition of Done (Per Phase)

- All checkboxes complete
- `flutter analyze` = 0 errors
- `flutter test` = 100% pass
- `flutter build windows --release` succeeds
- Manual smoke test on clean VM
- Documentation updated
- CHANGELOG updated