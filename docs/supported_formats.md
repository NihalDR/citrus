# Supported Formats Reference

## Image Formats

| Format | Extension | Input | Output | Transparency | Animation | Notes |
|--------|-----------|-------|--------|--------------|-----------|-------|
| PNG | `.png` | ✅ | ✅ | ✅ | ❌ | Lossless, best for graphics |
| JPEG | `.jpg`, `.jpeg` | ✅ | ✅ | ❌ | ❌ | Lossy, best for photos |
| WebP | `.webp` | ✅ | ✅ | ✅ | ✅ | Modern, good compression |
| BMP | `.bmp` | ✅ | ❌ | ❌ | ❌ | Uncompressed, legacy |
| GIF | `.gif` | ✅ | ❌ | ✅ | ✅ | Limited colors, legacy |
| TIFF | `.tiff`, `.tif` | ✅ | ❌ | ✅ | ❌ | Professional, large files |
| ICO | `.ico` | ✅ | ❌ | ✅ | ❌ | Windows icons |
| HEIC | `.heic` | ⚠️ | ❌ | ✅ | ❌ | Requires system codec |
| HEIF | `.heif` | ⚠️ | ❌ | ✅ | ❌ | Requires system codec |

### Image Operations

| Operation | PNG | JPEG | WebP | Notes |
|-----------|-----|------|------|-------|
| Convert | ✅ | ✅ | ✅ | Between all three |
| Resize | ✅ | ✅ | ✅ | Dimensions or % |
| Crop | ✅ | ✅ | ✅ | Custom region |
| Rotate 90° | ✅ | ✅ | ✅ | Clockwise |
| Rotate 180° | ✅ | ✅ | ✅ | |
| Rotate 270° | ✅ | ✅ | ✅ | Counter-clockwise |
| Flip Horizontal | ✅ | ✅ | ✅ | Mirror |
| Flip Vertical | ✅ | ✅ | ✅ | |
| Quality Control | ✅ (0-9) | ✅ (1-100) | ✅ (1-100) | Format-specific |
| Transparency | ✅ | ❌ (flattened) | ✅ | Preserve option |

### Resize Modes
- **Dimensions**: Exact width/height with optional aspect preservation
- **Percentage**: Scale by 1-500%
- **Width Only**: Set width, auto-calculate height
- **Height Only**: Set height, auto-calculate width

### Resampling Filters
- **Nearest**: Fastest, pixelated
- **Linear**: Bilinear, good balance
- **Cubic**: Bicubic, high quality
- **Lanczos**: Highest quality (default)

## Video Formats (Planned)

| Format | Extension | Input | Output | Notes |
|--------|-----------|-------|--------|-------|
| MP4 | `.mp4` | ⏳ | ⏳ | H.264/H.265 |
| MOV | `.mov` | ⏳ | ⏳ | QuickTime |
| MKV | `.mkv` | ⏳ | ⏳ | Matroska |
| AVI | `.avi` | ⏳ | ⏳ | Legacy |
| WebM | `.webm` | ⏳ | ⏳ | VP8/VP9/AV1 |
| FLV | `.flv` | ⏳ | ❌ | Flash Video |

### Planned Video Operations
- Format conversion (transcoding)
- Compression (CRF, bitrate)
- Resolution scaling
- Frame rate adjustment
- Trim (start/end)
- Audio removal
- Thumbnail extraction
- Audio extraction
- Concatenation

## Audio Formats (Planned)

| Format | Extension | Input | Output | Notes |
|--------|-----------|-------|--------|-------|
| MP3 | `.mp3` | ⏳ | ⏳ | LAME encoder |
| WAV | `.wav` | ⏳ | ⏳ | Uncompressed PCM |
| AAC | `.aac`, `.m4a` | ⏳ | ⏳ | FDK-AAC |
| FLAC | `.flac` | ⏳ | ⏳ | Lossless |
| OGG | `.ogg` | ⏳ | ⏳ | Vorbis |
| Opus | `.opus` | ⏳ | ⏳ | Low latency |
| AIFF | `.aiff` | ⏳ | ❌ | Apple uncompressed |

### Planned Audio Operations
- Format conversion
- Bitrate/sample rate adjustment
- Trim
- Volume normalization
- Channel configuration (mono/stereo)

## Document Formats (Planned)

| Format | Extension | Input | Output | Notes |
|--------|-----------|-------|--------|-------|
| PDF | `.pdf` | ⏳ | ⏳ | Primary focus |
| TXT | `.txt` | ⏳ | ❌ | Plain text |
| MD | `.md` | ⏳ | ❌ | Markdown |

### Planned PDF Operations
- Merge multiple PDFs
- Split by page range
- Extract pages
- Reorder pages
- Rotate pages
- Images → PDF
- PDF compression
- Text extraction

## Archive Formats (Planned)

| Format | Extension | Create | Extract | Notes |
|--------|-----------|--------|---------|-------|
| ZIP | `.zip` | ⏳ | ⏳ | Deflate |
| TAR | `.tar` | ⏳ | ⏳ | Uncompressed |
| GZIP | `.gz` | ⏳ | ⏳ | Single file |
| RAR | `.rar` | ❌ | ⏳ | Requires unrar |
| 7-Zip | `.7z` | ⏳ | ⏳ | LZMA |

## Format Detection

Files are identified by:
1. Extension (primary)
2. MIME type (via `mime` package)
3. Magic bytes (for ambiguous cases)

### Category Mapping

```
Image:    png, jpg, jpeg, webp, bmp, gif, tiff, tif, ico, heic, heif
Video:    mp4, mov, mkv, avi, webm, flv, mpg, mpeg, wmv
Audio:    mp3, wav, aac, m4a, flac, ogg, opus, aiff
Document: pdf, txt, md
Archive:  zip, tar, gz, rar, 7z
Unknown:  Everything else
```

## Quality Presets (Planned)

### Image
- **High**: PNG/100% JPEG/WebP lossless
- **Balanced**: 85% JPEG / 80% WebP / PNG level 6
- **Small**: 70% JPEG / 60% WebP / PNG level 9

### Video
- **High**: H.265 CRF 18, original resolution
- **Balanced**: H.264 CRF 23, 1080p max
- **Small**: H.264 CRF 28, 720p max

### Audio
- **High**: FLAC / 320kbps MP3
- **Balanced**: 192kbps MP3 / 128kbps AAC
- **Small**: 128kbps MP3 / 96kbps Opus

## Limitations

### Current (Phase 1)
- HEIC/HEIF requires Windows HEVC codec (paid)
- No EXIF/metadata preservation in conversions
- Large images (>100MP) may cause OOM
- No ICC color profile handling

### General
- FFmpeg codec support depends on build
- System codecs not accessible from sandbox
- Network paths (UNC) not fully tested
- Very long paths (>260 chars) need `\\?\` prefix

## Verification

Test files for validation:
- `test/assets/` - Sample files for each format
- Automated tests verify decode/encode roundtrip
- Visual regression for resize/crop operations