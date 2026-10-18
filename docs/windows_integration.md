# Windows Integration Design

## Overview

This document describes the planned native Windows integration for Citrus, enabling system-wide file conversion workflows inspired by Tangerine on macOS.

## Key Features

### 1. System Tray Integration
- Persistent tray icon with context menu
- Show/hide main window
- Quick access to recent conversions
- Settings and quit

### 2. Window Management
- Minimize to tray (not taskbar)
- Restore from tray
- Single instance enforcement
- Remember window position/size

### 3. Global Shift-Drag Detection
- Detect Shift+drag initiated in File Explorer
- Show radial menu at cursor position
- Pass selected files to Citrus

### 4. Global Keyboard Shortcut
- Configurable hotkey (default: `Ctrl+Alt+C`)
- Opens main window or radial menu

### 5. Launch at Startup
- Optional registry entry
- Minimized to tray on boot

### 6. Native File Dialogs
- Use Windows Common Item Dialog (IFileOpenDialog)
- Support for multiple selection
- Folder picker for output directory

## Technical Architecture

### Platform Channel Interface

```dart
// lib/platform/windows_integration.dart

abstract class WindowsIntegration {
  // Tray
  Future<void> initializeTray();
  Future<void> updateTrayMenu(List<TrayMenuItem> items);
  Future<void> showTrayNotification(String title, String body);
  
  // Window
  Future<void> minimizeToTray();
  Future<void> restoreFromTray();
  Future<bool> isMinimizedToTray();
  Future<void> setLaunchAtStartup(bool enabled);
  Future<bool> getLaunchAtStartup();
  
  // Global interactions
  Future<void> registerGlobalShortcut(Hotkey hotkey);
  Future<void> unregisterGlobalShortcut();
  Future<void> startShiftDragMonitor();
  Future<void> stopShiftDragMonitor();
  
  // File dialogs
  Future<List<String>?> pickFiles({bool multiple = true});
  Future<String?> pickDirectory();
  
  // Cleanup
  Future<void> dispose();
}
```

### Native Implementation (C++/WinRT)

Location: `windows/runner/citrus_windows.cpp` (to be created)

#### Key Windows APIs

| Feature | Windows API |
|---------|-------------|
| System Tray | `Shell_NotifyIcon` (NOTIFYICONDATA) |
| Global Hotkey | `RegisterHotKey` / `UnregisterHotKey` |
| Low-level Hooks | `SetWindowsHookEx` (WH_MOUSE_LL, WH_KEYBOARD_LL) |
| Drag Detection | `DoDragDrop` monitoring / Raw Input |
| File Dialogs | `IFileOpenDialog` / `IFileSaveDialog` |
| Startup | Registry `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` |
| DPI Awareness | `SetProcessDpiAwarenessContext` |
| Multi-monitor | `MonitorFromPoint`, `GetMonitorInfo` |

#### Shift-Drag Detection Strategy

**Option A: Low-level Mouse Hook (WH_MOUSE_LL)**
```cpp
// Pros: Captures all mouse events system-wide
// Cons: Requires careful filtering, performance impact
LRESULT CALLBACK MouseHookProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (nCode >= 0 && wParam == WM_MOUSEMOVE) {
        MSLLHOOKSTRUCT* info = (MSLLHOOKSTRUCT*)lParam;
        // Check if left button down + Shift key
        if (GetAsyncKeyState(VK_LBUTTON) & 0x8000 &&
            GetAsyncKeyState(VK_SHIFT) & 0x8000) {
            // Check if drag started in Explorer
            HWND hwnd = WindowFromPoint(info->pt);
            if (IsExplorerWindow(hwnd)) {
                // Get selected files from Explorer
                // Send to Flutter via method channel
            }
        }
    }
    return CallNextHookEx(hook, nCode, wParam, lParam);
}
```

**Option B: Raw Input (RegisterRawInputDevices)**
```cpp
// Pros: Lower level, more reliable
// Cons: More complex, no window context
```

**Option C: Explorer Extension (IShellFolderViewCB)**
```cpp
// Pros: Native integration, official API
// Cons: COM complexity, requires registration
```

**Recommended: Hybrid Approach**
1. Register global hotkey for manual trigger
2. Use WH_MOUSE_LL hook ONLY when Citrus is running
3. Filter aggressively: only process if:
   - Left mouse down + Shift held
   - Cursor over Explorer window (`CabinetWClass` or `ExploreWClass`)
   - Drag distance > threshold (SM_CXDRAG)
4. Get selected files via `IShellFolderView::GetSelectedObjects`
5. Send file list to Flutter, show radial menu

### Security Considerations

| Concern | Mitigation |
|---------|------------|
| Admin rights | None required - user-level hooks only |
| Input injection | Never inject input, only observe |
| Explorer interference | Minimal hook time, quick filtering |
| Malicious files | Validate paths, no auto-execution |
| Privacy | No file content read during detection |

### Permission Requirements

- **No elevated permissions needed**
- Hooks installed in current user session
- Registry writes to HKCU only
- File dialogs run in user context

## Implementation Plan

### Phase 4A: System Tray & Window Management
1. Create `WindowsIntegration` interface
2. Implement tray icon with `Shell_NotifyIcon`
3. Add minimize/restore logic
4. Implement startup registry toggle
5. Connect to Flutter via MethodChannel

### Phase 4B: Global Shortcut
1. Register `Ctrl+Alt+C` via `RegisterHotKey`
2. Handle `WM_HOTKEY` message
3. Forward to Flutter for window show

### Phase 4C: Shift-Drag Detection
1. Implement WH_MOUSE_LL hook
2. Filter for Explorer + Shift+drag
3. Extract selected file paths via Shell API
3. Send to Flutter, show radial menu at cursor
4. Clamp menu to monitor bounds

### Phase 4D: Polish
1. DPI-aware positioning
2. Multi-monitor support
3. Animation for radial menu
4. Accessibility (screen reader support)
5. Comprehensive error handling

## Method Channel Protocol

### Dart → Native
```dart
// Initialize
await channel.invokeMethod('initialize', {
  'trayIcon': 'assets/icons/tray.png',
  'menuItems': [...],
});

// Register hotkey
await channel.invokeMethod('registerHotkey', {
  'id': 'main',
  'modifiers': ['control', 'alt'],
  'key': 'c',
});

// Start shift-drag monitor
await channel.invokeMethod('startShiftDragMonitor');
```

### Native → Dart (Event Channel)
```dart
// Files dropped via Shift-drag
eventChannel.receiveBroadcastStream().listen((event) {
  final paths = List<String>.from(event['paths']);
  final position = Offset(event['x'], event['y']);
  showRadialMenu(paths, position);
});

// Hotkey pressed
eventChannel.receiveBroadcastStream().listen((_) {
  showMainWindow();
});

// Tray menu item clicked
eventChannel.receiveBroadcastStream().listen((event) {
  handleTrayAction(event['actionId']);
});
```

## DPI & Multi-Monitor Handling

### DPI Awareness
```cpp
// In WinMain / DLL entry
SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
```

### Menu Positioning
```cpp
// Get monitor for cursor
HMONITOR monitor = MonitorFromPoint(cursorPos, MONITOR_DEFAULTTONEAREST);
MONITORINFO info = { sizeof(MONITORINFO) };
GetMonitorInfo(monitor, &info);

// Clamp menu rect to monitor work area
RECT workArea = info.rcWork;
menuX = clamp(cursorX - menuWidth/2, workArea.left, workArea.right - menuWidth);
menuY = clamp(cursorY - menuHeight/2, workArea.top, workArea.bottom - menuHeight);
```

## Explorer File Selection

### Getting Selected Files
```cpp
// From Explorer window handle
IShellBrowser* browser;
IShellView* view;
IFolderView* folderView;

browser->QueryService(SID_SShellBrowser, IID_IShellView, (void**)&view);
view->QueryInterface(IID_IFolderView, (void**)&folderView);

IShellFolder* folder;
folderView->GetFolder(IID_IShellFolder, (void**)&folder);

IEnumIDList* enumItems;
folderView->Items(SVGIO_SELECTION, IID_IEnumIDList, (void**)&enumItems);

LPITEMIDLIST pidl;
while (enumItems->Next(1, &pidl, nullptr) == S_OK) {
  IShellItem* item;
  SHCreateItemFromIDList(pidl, IID_IShellItem, (void**)&item);
  
  LPWSTR path;
  item->GetDisplayName(SIGDN_FILESYSPATH, &path);
  filePaths.push_back(wstring_to_string(path));
  
  CoTaskMemFree(path);
  item->Release();
}
```

## Testing Strategy

### Unit Tests (Native)
- Hook installation/removal
- Hotkey registration
- File path extraction
- Monitor boundary clamping

### Integration Tests (Flutter)
- Tray icon visibility
- Minimize/restore cycle
- Hotkey triggers window
- Shift-drag shows radial menu
- Menu position on multi-monitor

### Manual Testing Checklist
- [ ] Tray icon appears on startup
- [ ] Right-click tray shows menu
- [ ] Minimize → tray, click tray → restore
- [ ] Startup toggle persists across reboots
- [ ] Ctrl+Alt+C opens window
- [ ] Shift+drag in Explorer shows menu
- [ ] Menu appears at cursor
- [ ] Menu clamped to screen edges
- [ ] Works on secondary monitor
- [ ] Works at 150%/200% DPI
- [ ] No interference with other apps
- [ ] Clean shutdown removes hooks

## Troubleshooting

### Hook Not Firing
- Verify `SetWindowsHookEx` returns non-NULL
- Check thread message pump (required for hooks)
- Ensure hook procedure in DLL (not EXE) for global hooks

### Hotkey Conflicts
- Check `RegisterHotKey` return value
- Try alternative modifiers if conflict
- Unregister on dispose

### File Paths Empty
- Verify Explorer window class detection
- Check `Items(SVGIO_SELECTION)` return value
- Ensure COM initialized (`CoInitializeEx`)

### Menu Position Wrong
- Verify `MonitorFromPoint` with `MONITOR_DEFAULTTONEAREST`
- Check DPI scaling of coordinates
- Use physical pixels for native, logical for Flutter

## Future Enhancements

- Context menu integration (right-click → "Convert with Citrus")
- Jump list for recent conversions
- Thumbnail provider for converted files
- File type association (.citrus preset files)
- PowerToys Run / Flow Launcher plugin