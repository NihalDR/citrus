# Visual Design System

## Brand Identity

### Name: Citrus
**Tagline**: Fresh file conversion

### Color Palette

#### Primary - Citrus Orange
| Variant | Hex | Usage |
|---------|-----|-------|
| Primary | `#FF8C00` | Buttons, active states, brand |
| On Primary | `#FFFFFF` | Text on primary |
| Primary Container | `#FFD8A8` | Hover backgrounds, chips |
| On Primary Container | `#3D2B00` | Text on container |

#### Light Theme
| Role | Hex |
|------|-----|
| Background | `#FFFFFBFE` |
| Surface | `#FFFFFBFE` |
| Surface Container Highest | `#FFE8E6E1` |
| On Surface | `#FF1D1C1B` |
| On Surface Variant | `#FF494541` |
| Outline | `#FF797470` |
| Outline Variant | `#FFCAC4C0` |

#### Dark Theme
| Role | Hex |
|------|-----|
| Background | `#FF151413` |
| Surface | `#FF1D1C1B` |
| Surface Container Highest | `#FF323130` |
| On Surface | `#FFF5F0EB` |
| On Surface Variant | `#FFCAC4C0` |
| Outline | `#FF938F8A` |
| Outline Variant | `#FF494541` |

#### Semantic Colors
| State | Light | Dark |
|-------|-------|------|
| Success | `#FF4CAF50` | `#FF81C784` |
| Warning | `#FFFFB340` | `#FFFFD8A8` |
| Error | `#FFD32F2F` | `#FFEF5350` |
| Info | `#FF2196F3` | `#FF64B5F6` |

---

## Typography

### Font Family
- **Primary**: System UI (Segoe UI on Windows)
- **Monospace**: Consolas / Cascadia Code

### Scale (Material 3)
| Style | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| Display Large | 57 | 400 | 64 | -0.25 |
| Display Medium | 45 | 400 | 52 | 0 |
| Display Small | 36 | 400 | 44 | 0 |
| Headline Large | 32 | 600 | 40 | 0 |
| Headline Medium | 28 | 600 | 36 | 0 |
| Headline Small | 24 | 600 | 32 | 0 |
| Title Large | 22 | 500 | 28 | 0 |
| Title Medium | 16 | 500 | 24 | 0.15 |
| Title Small | 14 | 500 | 20 | 0.1 |
| Body Large | 16 | 400 | 24 | 0.5 |
| Body Medium | 14 | 400 | 20 | 0.25 |
| Body Small | 12 | 400 | 16 | 0.4 |
| Label Large | 14 | 500 | 20 | 0.1 |
| Label Medium | 12 | 500 | 16 | 0.5 |
| Label Small | 11 | 500 | 16 | 0.5 |

---

## Spacing System

### Base Unit: 8px
| Token | Value | Usage |
|-------|-------|-------|
| space-1 | 4px | Tight gaps |
| space-2 | 8px | Default gap |
| space-3 | 12px | Medium gap |
| space-4 | 16px | Standard padding |
| space-5 | 24px | Section gap |
| space-6 | 32px | Large section gap |
| space-7 | 48px | Page margins |
| space-8 | 64px | Hero sections |

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| radius-sm | 4px | Chips, checkboxes |
| radius-md | 8px | Buttons, inputs, cards |
| radius-lg | 12px | Cards, dialogs |
| radius-xl | 16px | Sheets, overlays |
| radius-full | 9999px | Pills, avatar |

---

## Shadows (Elevation)

| Level | Light | Dark | Usage |
|-------|-------|------|-------|
| 0 | none | none | Flat |
| 1 | `0 1px 2px #0D000000` | `0 1px 3px #4D000000` | Cards |
| 2 | `0 3px 6px #15000000` | `0 4px 8px #60000000` | Raised |
| 3 | `0 10px 20px #1A000000` | `0 12px 24px #70000000` | Modals |
| 4 | `0 16px 32px #1F000000` | `0 20px 40px #80000000` | Overlays |

---

## Components

### Buttons

#### Filled (Primary Action)
```dart
FilledButton(
  style: FilledButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: Text('Convert'),
)
```
- Background: Primary
- Text: On Primary
- Hover: Primary Container
- Disabled: 38% opacity

#### Outlined (Secondary Action)
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    side: BorderSide(color: Primary, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
)
```
- Border: Primary
- Text: Primary
- Hover: Primary Container (10%)

#### Text (Tertiary Action)
```dart
TextButton(
  style: TextButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
)
```
- Text: Primary
- Hover: Primary Container (10%)

---

### Cards
```dart
Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: OutlineVariant, width: 1),
  ),
  color: Surface,
  surfaceTintColor: Colors.transparent,
)
```
- Light: Subtle border, minimal shadow
- Dark: Stronger border, subtle shadow

---

### Input Fields
```dart
TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: SurfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Primary, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

---

### Drop Zone
```dart
// Default state
Container(
  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
  decoration: BoxDecoration(
    color: SurfaceContainerHighest,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: OutlineVariant),
  ),
)

// Drag-over state
Container(
  decoration: BoxDecoration(
    color: PrimaryContainer.withOpacity(0.5),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Primary, width: 2),
    boxShadow: [BoxShadow(
      color: Primary.withOpacity(0.15),
      blurRadius: 16,
      spreadRadius: 2,
    )],
  ),
)
```

---

### Radial Menu

#### Geometry
- Container: 300×300px
- Center circle: 120px diameter
- Orbit radius: 120px
- Action items: 88px diameter
- Max actions: 8 (optimal), 12 (max)

#### Center Item
- File preview (circular crop) or category icon
- Tap to dismiss
- Hover: subtle scale (1.02x)

#### Action Items
- Circular buttons on orbit
- Icon (24px) + label (11px)
- Evenly distributed (360°/count)
- Start at -90° (top)
- Hover: scale 1.15x, primary color
- Connecting lines from center

#### Animation
- Entrance: scale 0→1, opacity 0→1 (200ms, easeOutBack)
- Hover: scale 1.15x (150ms)
- Lines: fade in/out with highlight

#### Accessible List Alternative
- Material card with rounded corners
- Max height: 500px, max width: 320px
- Header: file preview + name + action count
- List items: icon + name + description + category chip
- Full keyboard navigation

---

### Job Queue

#### Job Card
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator + name + status chip
        Row(...),
        // Progress bar
        LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        // Stats row
        Row(...),
        // Errors (if any)
        if (hasErrors) ...,
      ],
    ),
  ),
)
```

#### Status Colors
| Status | Color | Chip BG |
|--------|-------|---------|
| Pending | Grey | Grey 10% |
| Queued | Blue | Blue 10% |
| Running | Blue (animated) | Blue 10% |
| Completed | Green | Green 10% |
| Partial | Orange | Orange 10% |
| Failed | Red | Red 10% |
| Cancelled | Grey | Grey 10% |

---

### File Preview Cards
- 100×100px (120×120px with padding)
- Image: thumbnail crop
- Others: category icon + color
- Top-right: dismiss button (hover only)
- Bottom: name (1 line) + size

---

### Quick Action Cards
- 160×120px
- Icon (32px) + label + subtitle
- Hover: border primary, shadow
- Rounded 12px, border OutlineVariant

---

## Icons

### Category Icons
| Category | Icon | Color |
|----------|------|-------|
| Image | `Icons.image_outlined` | Blue `#2196F3` |
| Video | `Icons.video_file_outlined` | Purple `#9C27B0` |
| Audio | `Icons.audio_file_outlined` | Green `#4CAF50` |
| Document | `Icons.picture_as_pdf_outlined` | Red `#F44336` |
| Archive | `Icons.folder_zip_outlined` | Orange `#FF9800` |
| Unknown | `Icons.insert_drive_file_outlined` | Grey |

### Action Icons (Radial Menu)
| Action | Icon |
|--------|------|
| PNG | `Icons.image_outlined` |
| JPEG | `Icons.image_outlined` |
| WebP | `Icons.image_outlined` |
| Resize | `Icons.crop_outlined` |
| Crop | `Icons.crop_outlined` |
| Rotate | `Icons.rotate_right_outlined` |
| Flip | `Icons.flip_outlined` |
| Compress | `Icons.compress_outlined` |
| Extract | `Icons.extract_outlined` |
| Merge | `Icons.merge_outlined` |
| Settings | `Icons.settings_outlined` |
| History | `Icons.history_outlined` |

---

## Animations

### Timing
| Type | Duration | Curve |
|------|----------|-------|
| Micro (hover, press) | 100ms | easeOut |
| Standard (transitions) | 200ms | easeOutCubic |
| Emphasis (modals, menus) | 300ms | easeOutBack |
| Page transitions | 300ms | easeInOutCubic |

### Key Animations
1. **Radial menu entrance**: scale + fade (200ms, easeOutBack)
2. **Drop zone activation**: scale icon + color shift (200ms)
3. **Job card progress**: linear progress bar (continuous)
4. **Card hover**: elevation + border color (150ms)
5. **Page transitions**: shared axis (300ms)

---

## Responsive Breakpoints

| Breakpoint | Width | Layout |
|------------|-------|--------|
| Compact | < 600px | Stacked (single column) |
| Medium | 600-900px | Side panel below |
| Expanded | > 900px | Side-by-side (3:1 ratio) |

---

## Accessibility

### Contrast Ratios (WCAG 2.1 AA)
- Normal text: 4.5:1 minimum
- Large text (18px+): 3:1 minimum
- UI components: 3:1 minimum

### Focus Indicators
- 2px solid Primary outline
- Offset 2px from component
- Visible on all interactive elements

### Keyboard Navigation
- Tab order: logical (top-left → bottom-right)
- Enter/Space: activate
- Escape: dismiss/close
- Arrow keys: radial menu navigation

### Screen Readers
- Semantic labels on all controls
- Live regions for progress updates
- Descriptive alt text for images

---

## Dark Mode Considerations

- Avoid pure black (`#000000`) - use `#151413`
- Reduce saturation on colored surfaces
- Increase elevation shadows
- Ensure primary color works on dark (use `#FFB340`)
- Test with Windows high contrast mode