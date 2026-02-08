# 🎮 Quest Game Manager — Improvement Plan

> A comprehensive roadmap for transforming the app from beta (~70% complete) into a polished, production-ready Quest experience.

---

## 📋 Table of Contents

1. [🔴 Critical: Complete Unfinished Core Features](#-critical-complete-unfinished-core-features)
2. [🛠️ Codebase Refactoring & Technical Debt](#️-codebase-refactoring--technical-debt)
3. [⬇️ Download & Install Process Improvements](#️-download--install-process-improvements)
4. [🎨 UI/UX Improvements](#-uiux-improvements)
5. [✨ New Features for Users](#-new-features-for-users)
6. [🧪 Testing & Quality](#-testing--quality)
7. [🚀 DevOps & CI/CD](#-devops--cicd)
8. [📱 Quest-Specific Optimizations](#-quest-specific-optimizations)
9. [🔒 Security & Reliability](#-security--reliability)
10. [📊 Priority Matrix](#-priority-matrix)

---

## 🔴 Critical: Complete Unfinished Core Features

These are partially implemented features that must be finished before the app is usable.

### 1. 📦 APK Installation Pipeline
**Status:** Platform channel defined but no actual installation logic
**What's missing:**
- [ ] Implement `PackageInstallerChannel.kt` with full `PackageInstaller` API integration (session creation, APK streaming, commit with `PendingIntent`)
- [ ] Handle `STATUS_PENDING_USER_ACTION` — launch the Android confirmation Intent so users see the install dialog
- [ ] Create Dart-side platform channel wrapper in `installer_repository_impl.dart`
- [ ] Handle install result callbacks (success/failure/cancelled)
- [ ] Handle signature mismatch: detect, prompt user to uninstall old version, retry
- [ ] Add `InstallResultReceiver.kt` BroadcastReceiver for async install results

### 2. 📂 OBB File Copying
**Status:** Not implemented at all
**What's missing:**
- [ ] After extraction, scan for `{package_name}/` subfolder containing `.obb` files
- [ ] Create `/sdcard/Android/obb/{package_name}/` directory
- [ ] Copy all OBB files to that directory
- [ ] Handle `MANAGE_EXTERNAL_STORAGE` permission flow on Quest 3 (Android 12L)
- [ ] Delete existing OBB directory before copying (avoid stale files)

### 3. ⏸️ Real Pause/Resume Downloads
**Status:** UI shows pause button but it doesn't actually pause
**What's missing:**
- [ ] Implement `CancelToken`-based pause (cancel current dio request, save progress)
- [ ] Track bytes downloaded per-part for accurate resume
- [ ] On resume, use HTTP `Range: bytes={offset}-` header to continue from where paused
- [ ] Save `.tmp` files during download, rename to final on completion
- [ ] Handle server not supporting Range requests gracefully (restart download)

### 4. 💾 Download Queue Persistence
**Status:** Methods exist but return dummy values
**What's missing:**
- [ ] Persist download queue to Hive box on every state change
- [ ] On app launch, restore queue from Hive and resume queued/paused downloads
- [ ] Serialize `DownloadTask` with status, progress, bytes downloaded, file paths
- [ ] Handle edge case: app killed mid-download — detect partial files on restart

### 5. 🧹 Cache Clearing
**Status:** Settings button exists but logic is stubbed
**What's missing:**
- [ ] Implement actual cache directory scanning and deletion
- [ ] Show cache size before clearing (scan `getApplicationCacheDirectory()`)
- [ ] Delete extracted game files after successful installation
- [ ] Delete `.7z` archive parts after successful extraction
- [ ] Provide selective cache clearing (per-game vs. all)

---

## 🛠️ Codebase Refactoring & Technical Debt

### 6. 🧵 Extraction Memory Management
**Problem:** Large 2GB+ game archives loaded during extraction can crash on low-memory devices
**Solution:**
- [ ] Move 7z extraction to an Android `IntentService` or `WorkManager` job
- [ ] Add extraction progress reporting via platform channel `EventChannel`
- [ ] Implement streaming extraction in Kotlin (already using `SevenZFile` iterator — add progress callbacks)
- [ ] Consider using the bundled `7za` ARM64 binary via `Process.run()` as spec intended (streams better than in-memory Java extraction)

### 7. 🔄 Remove Dead Code
- [ ] Remove `RcloneService` (`lib/core/services/rclone_service.dart`) — completely unused, app uses plain HTTP
- [ ] Remove rclone-related platform channel code from `MainActivity.kt`
- [ ] Clean up unused imports and dead code paths flagged by analyzer

### 8. 🏷️ User-Agent Consistency
**Problem:** Different User-Agents used in different requests
- Config fetch: Chrome UA
- Downloads: `rclone/v1.66.0`
- Spec says: `rclone/v1.65.2`

**Fix:**
- [ ] Centralize User-Agent in `AppConstants` as single source of truth
- [ ] Use consistent `rclone/v1.65.2` everywhere (matching spec and what the server expects)
- [ ] Apply via Dio interceptor so it's automatic on all requests

### 9. 📐 Architecture Refinements
- [ ] Create a proper `InstallerBloc` with stages: `Extracting → Installing → CopyingObb → Cleaning → Success/Failed`
- [ ] Create `FullInstallPipeline` use case that orchestrates the entire post-download flow
- [ ] Add `GameDetailBloc`/`Cubit` for the detail sheet (currently stateless)
- [ ] Move the "blind download" logic into a proper `DownloadGame` use case (currently mixed into datasource)

### 10. 🔀 Improve Error Messages
- [ ] Replace generic `"Network error: ..."` with user-friendly messages
- [ ] Add specific messages for common failures:
  - "No internet connection — check your WiFi"
  - "Server is busy — try again in a few minutes"
  - "Not enough storage — need {X} GB free, you have {Y} GB"
  - "Download was interrupted — tap Retry to continue"
- [ ] Add error codes for debugging (shown in expandable detail)

---

## ⬇️ Download & Install Process Improvements

### 11. 🔌 Foreground Service for Background Downloads
**Problem:** Downloads die when app is backgrounded or Quest goes to sleep
**Solution:**
- [ ] Create Android `ForegroundService` with persistent notification showing download progress
- [ ] Acquire `WAKE_LOCK` during active downloads
- [ ] Show notification with: game name, progress %, speed, cancel button
- [ ] Release wake lock and stop service when queue is empty
- [ ] Handle Quest sleep/wake cycle gracefully

### 12. 📊 Storage Space Validation Before Download
- [ ] Check available space BEFORE adding to download queue
- [ ] Require: `game_size_mb * 2.5` free space (archive + extracted + safety margin)
- [ ] Show clear warning dialog: "This game needs {X} GB. You have {Y} GB free. Continue?"
- [ ] Suggest clearing cache if space is tight
- [ ] Block download if insufficient space (don't let user start and fail mid-way)

### 13. ⚡ Smart Download Strategy
- [ ] Add HTTP `Range` header support for resumable downloads (currently missing)
- [ ] Save partial downloads as `.tmp` files (don't lose progress on interruption)
- [ ] Add auto-retry with exponential backoff on transient failures (3 retries, 2s/4s/8s)
- [ ] Add download speed throttling option in Settings (useful for shared WiFi)
- [ ] Add concurrent part downloads (download 2 parts simultaneously for faster throughput on fast connections)

### 14. 🔄 One-Tap "Download & Install" Flow
**Currently:** Download and install are separate manual steps
**Improvement:**
- [ ] After download completes, automatically start extraction
- [ ] After extraction, automatically trigger APK installation
- [ ] After APK install, automatically copy OBB files
- [ ] After OBB copy, automatically clean up temp files
- [ ] Show unified pipeline progress: `Downloading (45%) → Extracting → Installing → Done ✅`
- [ ] Allow user to toggle "auto-install after download" in Settings

### 15. 📈 Enhanced Progress Display
- [ ] Show which part is being downloaded: "Part 2 of 5"
- [ ] Show overall pipeline stage: `📥 Downloading → 📦 Extracting → 📲 Installing → ✅ Done`
- [ ] Add estimated time remaining for extraction phase (track extraction speed)
- [ ] Show cumulative progress across all parts (not just current part)
- [ ] Add download history log (completed downloads with timestamps)

---

## 🎨 UI/UX Improvements

### 16. 🖼️ Game Detail Page (Full Screen)
**Currently:** Game details shown in a bottom sheet (cramped in VR)
**Improvement:**
- [ ] Create a full dedicated `GameDetailPage` (navigate, don't use bottom sheet)
- [ ] Large hero thumbnail/banner image at top
- [ ] Game info: name, package name, version, size, last updated
- [ ] Large "Download & Install" CTA button (56dp+ height, full width)
- [ ] Show current status: Not Downloaded / Downloading (with progress) / Downloaded / Installed
- [ ] Show version comparison if game is already installed (update available?)
- [ ] Back button to return to catalog

### 17. 🔍 Enhanced Search & Filtering
**Currently:** Search only checks game name (case-insensitive contains)
**Improvement:**
- [ ] Search by package name (useful for developers)
- [ ] Add debounced search (300ms delay) to avoid UI jank while typing
- [ ] Add genre/category tags if available in metadata
- [ ] Add filter chips: "All", "Not Installed", "Installed", "Updates Available"
- [ ] Remember last search query and filters across tab switches
- [ ] Add "Recently Downloaded" quick filter
- [ ] Show result count: "Showing 42 of 350 games"

### 18. 📊 Game Grid/List View Toggle
**Currently:** Only horizontal list view
**Improvement:**
- [ ] Add grid view option (2-3 columns of game cards with thumbnails)
- [ ] Add list view option (compact rows with more info visible)
- [ ] Remember user's preferred view in Settings
- [ ] Grid cards: thumbnail + name + size + install badge
- [ ] List rows: thumbnail (small) + name + package + size + version + status

### 19. 🗂️ Sort Options Enhancement
**Currently:** Basic sort by name, date, size
**Improvement:**
- [ ] Add sort by: Name (A-Z / Z-A), Date (Newest / Oldest), Size (Largest / Smallest)
- [ ] Add sort by: Install Status (installed first or not-installed first)
- [ ] Visual indicator showing active sort direction (↑/↓ arrows)
- [ ] Persist sort preference across sessions

### 20. 📱 Better Storage Indicator
**Currently:** Basic text showing free space in AppBar
**Improvement:**
- [ ] Visual progress bar showing used vs. free storage
- [ ] Color coding: Green (>50% free) → Yellow (20-50%) → Red (<20%)
- [ ] Tap to show breakdown: System / Games / App Cache / Free
- [ ] Warning banner when storage is critically low (<2 GB)

### 21. 🎯 Onboarding & First Launch Experience
- [ ] Permission request flow on first launch:
  1. Explain why storage permission is needed
  2. Request `MANAGE_EXTERNAL_STORAGE`
  3. Request `REQUEST_INSTALL_PACKAGES`
  4. Show "Setup Complete" confirmation
- [ ] Brief tutorial overlay: "Browse games → Tap to download → Games install automatically"
- [ ] Loading screen with progress while fetching initial catalog

### 22. 📱 Navigation Improvements
- [ ] Add badge on Downloads tab showing active download count
- [ ] Add badge on Downloads tab showing number of completed (ready to install) downloads
- [ ] Add pull-to-refresh on catalog page (currently uses RefreshIndicator but could be more prominent)
- [ ] Add "scroll to top" FAB when user scrolls down in long game list
- [ ] Add haptic feedback on button presses (Quest controllers support haptics)

### 23. 🌓 Theme & Visual Polish
- [ ] Add subtle animations: page transitions, card hover effects, progress animations
- [ ] Add shimmer loading placeholders while game thumbnails load
- [ ] Improve empty states: Downloads tab when empty, search with no results
- [ ] Add app splash screen with logo
- [ ] Design and add custom app icon (currently default Flutter icon)
- [ ] Add subtle glow/shadow effects on interactive elements (improves depth perception in VR)

---

## ✨ New Features for Users

### 24. 📦 Installed Games Manager
- [ ] New "My Games" tab or section showing all sideloaded games on device
- [ ] Query installed packages via platform channel (`PackageManager.getInstalledPackages()`)
- [ ] Show: game name, package name, installed version, size on disk
- [ ] Compare installed version with catalog version → show "Update Available" badge
- [ ] "Uninstall" button per game (via `Intent.ACTION_DELETE`)
- [ ] "Update" button that downloads new version and installs over existing

### 25. 🔔 Update Notifications
- [ ] On catalog refresh, compare installed game versions with catalog
- [ ] Badge on "My Games" tab showing number of available updates
- [ ] "Update All" button to queue all outdated games for download
- [ ] Optional: show notification when new updates are available

### 26. ⭐ Favorites & Wishlist
- [ ] "Star" button on game cards to mark favorites
- [ ] "Favorites" filter in catalog view
- [ ] Persist favorites to Hive
- [ ] "Download Later" wishlist for games user wants but doesn't have space for now

### 27. 📊 Download Statistics
- [ ] Track total data downloaded (lifetime)
- [ ] Track number of games installed
- [ ] Show download speed history (average, peak)
- [ ] Show per-session stats: "This session: 3 games, 4.2 GB downloaded"

### 28. 🔄 Auto-Update Catalog
- [ ] Periodic background catalog refresh (configurable: daily/weekly/manual)
- [ ] Show "X new games since last check" banner
- [ ] Highlight new games in catalog with "NEW" badge
- [ ] Show last refresh timestamp in catalog header

### 29. 🌐 Multiple Mirror Support
- [ ] Allow users to add custom mirror URLs in Settings
- [ ] Auto-detect mirror health (ping test, speed test)
- [ ] Automatic mirror failover if primary is slow or down
- [ ] Show current mirror status: "Connected to Mirror 1 (45 MB/s)"

### 30. 📝 Game Notes & Descriptions
- [ ] Parse `.meta/notes/{package_name}.txt` from extracted metadata (these exist but aren't used)
- [ ] Show game descriptions on detail page
- [ ] Show compatibility notes, known issues
- [ ] Show required OBB info and total install footprint

### 31. 🔎 Quick Launch Installed Games
- [ ] "Launch" button on installed games
- [ ] Use `Intent` to start the game's main activity
- [ ] Recently played games section (track launch timestamps)

### 32. 📋 Batch Operations
- [ ] Multi-select games in catalog for batch download
- [ ] Multi-select in "My Games" for batch uninstall
- [ ] "Select All Updates" for batch update
- [ ] Queue management: reorder, prioritize, bulk cancel

---

## 🧪 Testing & Quality

### 33. 🧪 Unit Tests
**Currently:** Zero test coverage (only a placeholder test file exists)
**Priority tests to write:**
- [ ] `HashUtils.computeGameId()` — verify MD5 with trailing newline matches expected output
- [ ] `GameInfoModel.fromCsvLine()` — test parsing, edge cases, malformed lines
- [ ] `PublicConfigModel.toEntity()` — verify base64 password decoding
- [ ] `CatalogBloc` — test all events: Load, Search, Filter, Sort with `bloc_test`
- [ ] `DownloadsBloc` — test queue management, state transitions
- [ ] `SearchGames` use case — test filtering logic
- [ ] `FileUtils` — test storage space calculations, size formatting
- [ ] Repository implementations — test `Either<Failure, T>` wrapping with `mocktail`

### 34. 🧩 Widget Tests
- [ ] `GameCard` — renders name, size, thumbnail, install badge correctly
- [ ] `DownloadItem` — shows progress bar, speed, ETA, action buttons
- [ ] `StorageIndicator` — displays correct values and color coding
- [ ] `SearchBarWidget` — emits search events on input
- [ ] `SortFilterBar` — emits correct sort/filter events

### 35. 🔗 Integration Tests
- [ ] Full catalog load flow: config fetch → metadata download → parse → display
- [ ] Download flow: queue → download → progress updates → completion
- [ ] Settings persistence: change setting → restart app → setting preserved
- [ ] Error handling: network failure → error state → retry → success

---

## 🚀 DevOps & CI/CD

### 36. ⚙️ GitHub Actions Pipeline
- [ ] **Lint check:** `flutter analyze` on every PR
- [ ] **Test runner:** `flutter test` on every PR
- [ ] **Build check:** `flutter build apk --release --target-platform android-arm64` on every PR
- [ ] **Code generation:** `dart run build_runner build` before tests
- [ ] **Artifact upload:** publish APK artifact on tag/release

### 37. 📦 Release Management
- [ ] Semantic versioning (vX.Y.Z)
- [ ] GitHub Releases with APK attached
- [ ] Changelog generation from commits
- [ ] In-app update checker: compare current version with latest GitHub release

---

## 📱 Quest-Specific Optimizations

### 38. 🥽 VR-Optimized Interactions
- [ ] Larger hover states on interactive elements (pointer is less precise than touch)
- [ ] Add tooltip popups on hover (Quest pointer supports hover events)
- [ ] Optimize scroll physics for Quest controller thumbstick scrolling
- [ ] Add keyboard navigation support (Quest bluetooth keyboard users)

### 39. 🔋 Battery & Performance
- [ ] Minimize unnecessary widget rebuilds (use `const` widgets, `Selector` for BLoC)
- [ ] Lazy-load game thumbnails (only load visible cards)
- [ ] Limit catalog to display 50 items at a time with pagination/infinite scroll
- [ ] Profile and optimize frame rate (Quest targets 72/90 Hz — 2D panel should be smooth)

### 40. 📐 Adaptive Panel Size
- [ ] Support different Quest panel sizes (user can resize the panel)
- [ ] Use `LayoutBuilder` and responsive breakpoints
- [ ] Test at minimum panel size (384 x 500dp) — ensure nothing breaks
- [ ] Test at maximum panel size — ensure content fills space

---

## 🔒 Security & Reliability

### 41. 🔐 Config Security
- [ ] Don't hardcode fallback server config in `AppConstants` — fetch dynamically only
- [ ] Validate `baseUri` format before using (prevent injection)
- [ ] Validate SSL certificate for config endpoints
- [ ] Clear sensitive config from memory when not needed

### 42. 🛡️ Crash Resilience
- [ ] Add global error handler (`FlutterError.onError` + `PlatformDispatcher.onError`)
- [ ] Log crashes to local file for debugging
- [ ] Show user-friendly "Something went wrong" screen instead of crash
- [ ] Auto-recover from common failure states (network timeout → retry)

### 43. 📡 Network Resilience
- [ ] Detect network connectivity changes (WiFi disconnect/reconnect)
- [ ] Auto-pause downloads on WiFi disconnect
- [ ] Auto-resume downloads when WiFi reconnects
- [ ] Show offline banner when no connectivity
- [ ] Timeout handling with clear user feedback

---

## 📊 Priority Matrix

| Priority | Item | Impact | Effort |
|----------|------|--------|--------|
| 🔴 P0 | APK Installation Pipeline (#1) | **Critical** — app is useless without it | High |
| 🔴 P0 | OBB File Copying (#2) | **Critical** — many games need OBB | Medium |
| 🔴 P0 | One-Tap Download & Install Flow (#14) | **Critical** — core user experience | High |
| 🟠 P1 | Foreground Service (#11) | **High** — downloads die when backgrounded | Medium |
| 🟠 P1 | Storage Validation (#12) | **High** — prevents wasted downloads | Low |
| 🟠 P1 | Pause/Resume Downloads (#3) | **High** — essential for multi-GB files | Medium |
| 🟠 P1 | Queue Persistence (#4) | **High** — losing queue on app kill is bad UX | Medium |
| 🟠 P1 | Cache Clearing (#5) | **High** — storage fills up fast | Low |
| 🟡 P2 | User-Agent Fix (#8) | **Medium** — could cause server rejections | Low |
| 🟡 P2 | Game Detail Page (#16) | **Medium** — better UX for game info | Medium |
| 🟡 P2 | Enhanced Search (#17) | **Medium** — improves discoverability | Low |
| 🟡 P2 | Installed Games Manager (#24) | **Medium** — users need to manage installs | Medium |
| 🟡 P2 | Error Messages (#10) | **Medium** — reduces user confusion | Low |
| 🟡 P2 | Unit Tests (#33) | **Medium** — prevents regressions | Medium |
| 🟢 P3 | Memory Management (#6) | **Medium** — prevents rare crashes | Medium |
| 🟢 P3 | Remove Dead Code (#7) | **Low** — cleanliness | Low |
| 🟢 P3 | Grid/List Toggle (#18) | **Low** — nice to have | Low |
| 🟢 P3 | Favorites (#26) | **Low** — nice to have | Low |
| 🟢 P3 | Update Notifications (#25) | **Low** — nice to have | Medium |
| 🟢 P3 | CI/CD Pipeline (#36) | **Low** — nice for dev workflow | Medium |
| 🟢 P3 | Multiple Mirrors (#29) | **Low** — resilience improvement | Medium |
| 🟢 P3 | Batch Operations (#32) | **Low** — power user feature | Medium |
| 🔵 P4 | Download Statistics (#27) | **Low** — vanity feature | Low |
| 🔵 P4 | Quick Launch (#31) | **Low** — convenience | Low |
| 🔵 P4 | Adaptive Panel Size (#40) | **Low** — edge case | Low |

---

## 🗺️ Suggested Implementation Phases

### 🔴 Phase 1: Make It Work (P0)
> Goal: The app can actually download, extract, install, and play a game end-to-end.

1. APK Installation Pipeline (#1)
2. OBB File Copying (#2)
3. One-Tap Download & Install Flow (#14)
4. Storage Validation (#12)
5. User-Agent Fix (#8)

### 🟠 Phase 2: Make It Reliable (P1)
> Goal: Downloads don't die, progress isn't lost, errors are clear.

6. Foreground Service (#11)
7. Pause/Resume Downloads (#3)
8. Queue Persistence (#4)
9. Cache Clearing (#5)
10. Error Messages (#10)
11. Smart Download Strategy (#13)

### 🟡 Phase 3: Make It Polished (P2)
> Goal: Great UX that makes users want to use the app.

12. Game Detail Page (#16)
13. Enhanced Search & Filtering (#17)
14. Installed Games Manager (#24)
15. Enhanced Progress Display (#15)
16. Navigation Improvements (#22)
17. Theme & Visual Polish (#23)
18. Onboarding (#21)

### 🟢 Phase 4: Make It Delightful (P3+)
> Goal: Power features and ecosystem maturity.

19. Unit & Widget Tests (#33, #34)
20. CI/CD Pipeline (#36)
21. Update Notifications (#25)
22. Favorites & Wishlist (#26)
23. Multiple Mirror Support (#29)
24. Game Notes & Descriptions (#30)
25. Batch Operations (#32)
26. Download Statistics (#27)
27. Quick Launch (#31)

---

## 💡 Quick Wins (Can Be Done in <1 Hour Each)

| # | Quick Win | Impact |
|---|-----------|--------|
| 1 | Fix User-Agent to consistent `rclone/v1.65.2` | Prevents server rejections |
| 2 | Remove unused `RcloneService` and dead code | Cleaner codebase |
| 3 | Add storage check before download starts | Prevents failed downloads |
| 4 | Improve error messages with specific user-friendly text | Less user confusion |
| 5 | Add download count badge on Downloads tab | Better navigation awareness |
| 6 | Add "result count" to search ("Showing X of Y games") | Better search feedback |
| 7 | Add cache size display in Settings | Users know what's using space |
| 8 | Implement actual cache clearing logic | Free up storage |
| 9 | Add shimmer loading placeholders | More polished feel |
| 10 | Persist sort/filter preferences | Better UX continuity |

---

*Generated: 2026-02-08 | Quest Game Manager v1.0.0-beta*
