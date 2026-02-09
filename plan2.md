# 🎮 Quest Game Manager — Improvement Plan v2

> **A creative, research-backed roadmap** covering codebase refactoring, UI/UX overhaul, download pipeline reinvention, and bold new features — informed by competitor analysis (Rookie On Quest, SideQuest, QRookie), VR design research, and a deep audit of every source file.

---

## 📋 Table of Contents

1. [🏗️ Codebase & Architecture Refactoring](#1--codebase--architecture-refactoring)
2. [⬇️ Download & Install Pipeline Reinvention](#2--download--install-pipeline-reinvention)
3. [🎨 UI/UX Overhaul for VR Excellence](#3--uiux-overhaul-for-vr-excellence)
4. [✨ New Features & Competitive Differentiators](#4--new-features--competitive-differentiators)
5. [🧪 Testing & Quality Fortress](#5--testing--quality-fortress)
6. [🚀 DevOps, CI/CD & Release Pipeline](#6--devops-cicd--release-pipeline)
7. [🔒 Security & Resilience Hardening](#7--security--resilience-hardening)
8. [🥽 Quest-Specific VR Optimizations](#8--quest-specific-vr-optimizations)
9. [⚡ Performance Deep-Dive](#9--performance-deep-dive)
10. [📊 Priority Matrix & Implementation Phases](#10--priority-matrix--implementation-phases)

---

## 1. 🏗️ Codebase & Architecture Refactoring

### 1.1 🔥 Fix Silent Error Swallowing (Critical)
**Problem found in audit:** Multiple files use `catch (_) {}` or empty catch blocks, silently hiding failures from users and developers.

**Files affected:**
- `game_detail_page.dart` — `_loadNotes()` has empty catch
- `installer_bloc.dart:194` — `catch (_) {}` ignores install errors
- `settings_cubit.dart:94` — cache clearing errors swallowed
- `onboarding_page.dart:60-72` — permission checks fail silently
- `connectivity_service.dart:36-55` — broad catch-all hides network issues

**Action items:**
- [ ] Replace every `catch (_) {}` with typed catches + `AppLogger.error()` calls
- [ ] Surface user-visible errors with snackbars or error banners
- [ ] Create a `UserFacingError` mixin that maps `Failure` types to human-readable messages
- [ ] Add a global error boundary (`FlutterError.onError` + `PlatformDispatcher.onError`)

### 1.2 🧹 Remove Dead Code & Unused Dependencies
**Found in audit:**
- [ ] `_getDownloadBaseDir()` in `download_remote_datasource.dart:441-448` — defined but never called (logic duplicated in `_startDownload()`)
- [ ] `copyObbFiles()` in `installer_datasource.dart:113-162` — redundant with download pipeline
- [ ] `formatMb()` in `file_utils.dart:43-46` — never used, duplicate of `formatBytes()`
- [ ] Unused imports in `game_card.dart` (`path_provider`), `game_detail_page.dart` (`flutter/services.dart`), `settings_page.dart` (indirect `injection.dart`)
- [ ] `_onInstall` event handler in `installer_bloc.dart:70-172` — never triggered from UI
- [ ] Pause/resume logic in `downloads_bloc.dart:98-125` — marks status but doesn't actually pause

### 1.3 🏷️ User-Agent Consistency Fix
**Problem:** Different User-Agents in different requests — config fetch uses Chrome UA, downloads use `rclone/v1.66.0`, but spec says `rclone/v1.65.2`.

- [ ] Centralize User-Agent in `AppConstants` as single source of truth
- [ ] Set to `rclone/v1.65.2` (matching server expectations per protocol spec)
- [ ] Apply via a Dio `Interceptor` so it's automatic on ALL requests — no more per-call headers

### 1.4 🔀 Fix Architecture Violations Found in Audit
| Violation | Location | Fix |
|-----------|----------|-----|
| Direct disk space call in BLoC | `catalog_bloc.dart:78-82` | Move to repository/use case |
| Direct `getIt<>()` in presentation | `settings_page.dart:281` | Inject via constructor |
| `AppConstants` accessed directly in page | `game_detail_page.dart:66` | Pass via constructor or theme |
| Selection state managed in UI widget | `catalog_page.dart:26-55` | Move to CatalogBloc |
| Delete logic in dialog widget | `storage_management_dialog.dart:28-77` | Extract to SettingsCubit |
| Permission logic mixed with UI state | `onboarding_page.dart:33-47` | Create OnboardingCubit |

### 1.5 📐 Adopt Feature-First Module Boundaries
**Current:** Clean Architecture layers are good but some cross-cutting concerns bleed across features.

**2026 best practice:** Feature-first with clear module boundaries.

- [ ] Each feature should be a self-contained module with its own DI registrations
- [ ] Create a `shared/` module for truly cross-cutting widgets (storage indicator, error displays)
- [ ] Add barrel files (`exports.dart`) per feature to control public API surface
- [ ] Consider the domain layer optional per-feature — only use it where there's genuine business logic (not for simple CRUD)

### 1.6 🔄 Standardize State Management
**Problem:** Inconsistent use of BLoC vs Cubit without clear criteria.

**Rule to adopt:**
| Complexity | Pattern | Example |
|-----------|---------|---------|
| Simple settings toggle | Cubit | SettingsCubit, FavoritesCubit |
| Complex event flows | BLoC | CatalogBloc, DownloadsBloc |
| Multi-stage pipeline | BLoC with stream | InstallerBloc |

- [ ] Document the decision criteria in `AGENTS.md`
- [ ] Ensure all BLoC states use `freezed` sealed classes consistently
- [ ] Add `Selector` widgets where only partial state changes need to trigger rebuilds

### 1.7 🏗️ Create Proper Install Pipeline Use Case
**Currently:** Install logic is scattered between `InstallerBloc`, `InstallerDatasource`, and `DownloadsBloc`.

- [ ] Create `FullInstallPipeline` use case orchestrating: `Extract → FindAPKs → InstallAPK → CopyOBB → Cleanup → Done`
- [ ] Each stage emits progress to a `Stream<InstallStage>`
- [ ] InstallerBloc only subscribes to this stream — no business logic in the BLoC itself

---

## 2. ⬇️ Download & Install Pipeline Reinvention

### 2.1 🔴 Complete APK Installation (P0 — App is useless without it)
**Status:** Platform channel defined but no actual installation logic wired up.

- [ ] Wire up `PackageInstallerChannel.kt` fully — session creation, APK streaming, commit with `PendingIntent`
- [ ] Handle `STATUS_PENDING_USER_ACTION` — launch Android confirmation Intent
- [ ] Create Dart-side wrapper in `installer_repository_impl.dart`
- [ ] Handle install callbacks: success / failure / cancelled / signature mismatch
- [ ] On signature mismatch: prompt user to uninstall old version, then retry
- [ ] Add `InstallResultReceiver.kt` BroadcastReceiver for async results

### 2.2 🔴 Complete OBB File Copying (P0 — Many games need it)
- [ ] After extraction, scan for `{package_name}/` subfolder with OBB files
- [ ] Create `/sdcard/Android/obb/{package_name}/` directory
- [ ] Copy all OBB files with progress tracking
- [ ] Handle `MANAGE_EXTERNAL_STORAGE` permission flow (Android 12L on Quest 3)
- [ ] Delete existing OBB directory before copying (avoid stale files, matching QRookie behavior)

### 2.3 🔴 One-Tap "Download & Install" Flow (P0 — Core UX)
**Competitors:** Rookie On Quest does this. We must too.

- [ ] After download completes → auto-start extraction
- [ ] After extraction → auto-trigger APK installation
- [ ] After APK install → auto-copy OBB files
- [ ] After OBB copy → auto-cleanup temp files
- [ ] Show unified pipeline: `📥 Downloading (45%) → 📦 Extracting → 📲 Installing → ✅ Done`
- [ ] Toggle in Settings: "Auto-install after download" (default: ON)

### 2.4 ⏸️ Real Pause/Resume Downloads
**Status:** UI shows pause button but it's completely fake.

- [ ] Implement `CancelToken`-based pause (cancel current Dio request, save byte offset)
- [ ] Track bytes downloaded per-part for accurate resume
- [ ] On resume, use HTTP `Range: bytes={offset}-` header
- [ ] Save downloads as `.tmp` files, rename to final on completion
- [ ] Gracefully handle servers that don't support Range (restart from beginning with user warning)

### 2.5 💾 Persistent Download Queue
**Status:** Methods exist but return dummy values.

- [ ] Persist queue to Hive on every state change
- [ ] On app launch, restore queue and resume queued/paused downloads
- [ ] Serialize `DownloadTask` with: status, progress, bytes downloaded, file paths, timestamp
- [ ] Handle edge case: app killed mid-download — detect partial `.tmp` files on restart

### 2.6 🔌 Foreground Service for Background Downloads
**Problem:** Downloads die when app is backgrounded or Quest goes to sleep. **Rookie On Quest solves this — we must too.**

- [ ] Create Android `ForegroundService` with persistent notification
- [ ] Notification shows: game name, progress %, speed, cancel button
- [ ] Acquire `WAKE_LOCK` during active downloads
- [ ] Release wake lock and stop service when queue is empty
- [ ] Handle Quest sleep/wake cycle gracefully (resume on wake)
- [ ] Request `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission

### 2.7 📊 Storage Space Validation Before Download
- [ ] Check available space BEFORE adding to queue
- [ ] Require: `game_size_mb * 2.5` free (archive + extracted + safety margin)
- [ ] Show dialog: "This game needs X GB. You have Y GB free. Continue?"
- [ ] Suggest cache clearing if space is tight
- [ ] Block download if insufficient space — don't waste bandwidth

### 2.8 ⚡ Smart Download Strategy
- [ ] Auto-retry with exponential backoff (3 retries: 2s → 4s → 8s)
- [ ] Download speed throttling option in Settings (for shared WiFi)
- [ ] Duplicate prevention — can't queue the same game twice (currently possible!)
- [ ] Hash verification of downloaded parts (MD5 checksum if server provides it)
- [ ] Concurrent part downloads option (2 parts simultaneously for fast connections)

### 2.9 📈 Enhanced Progress Display
**Currently:** Progress only shows current part, not overall pipeline.

- [ ] Show which part is downloading: "Part 2 of 5"
- [ ] Show cumulative progress across ALL parts (not just current)
- [ ] Show pipeline stage with visual indicator: `📥 → 📦 → 📲 → ✅`
- [ ] Estimated time remaining for extraction phase
- [ ] Download history log with timestamps

---

## 3. 🎨 UI/UX Overhaul for VR Excellence

### 3.1 🖼️ Full Game Detail Page (Not Bottom Sheet)
**Problem:** Game details in a bottom sheet are cramped in VR — hard to read, hard to interact with.

**Research says:** VR apps need large, spacious layouts. Progressive disclosure is key.

- [ ] Replace bottom sheet with full dedicated `GameDetailPage` (navigation push)
- [ ] Large hero banner/thumbnail at top (at least 200dp tall)
- [ ] Game info: name, package name, version, size, last updated
- [ ] Large CTA button: "Download & Install" (56dp+ height, full width, high contrast)
- [ ] Status indicator: Not Downloaded / Downloading (with progress) / Downloaded / Installed / Update Available
- [ ] Version comparison if already installed
- [ ] Game notes/description from `.meta/notes/{package_name}.txt` (these exist but are unused!)
- [ ] Back button + breadcrumb

### 3.2 🔍 Search & Filtering Overhaul
**Currently:** Search only checks game name with no debounce.

- [ ] Add 300ms debounce to avoid UI jank while typing
- [ ] Search by package name too (useful for power users)
- [ ] Filter chips: "All" | "Not Installed" | "Installed" | "Updates Available" | "Favorites"
- [ ] Remember last search + filters across tab switches
- [ ] Show result count: "Showing 42 of 2,400 games"
- [ ] "Recently Added" quick filter (new games since last catalog refresh)

### 3.3 📊 Grid/List View Toggle
**Currently:** Only one view mode.

- [ ] Grid view: 2-3 columns of cards with thumbnails (visual browsing)
- [ ] List view: compact rows with more info per row (power users)
- [ ] Persist preferred view in Settings
- [ ] Grid cards: thumbnail + name + size + status badge
- [ ] List rows: small thumbnail + name + package + size + version + status

### 3.4 🗂️ Enhanced Sorting
- [ ] Sort by: Name (A-Z / Z-A), Date (Newest / Oldest), Size (Largest / Smallest)
- [ ] Sort by: Install Status (installed first or not-installed first)
- [ ] Visual indicator showing active sort direction (↑/↓ arrows)
- [ ] Persist sort preference across sessions

### 3.5 📱 Storage Indicator Upgrade
**Currently:** Basic text in AppBar.

- [ ] Visual progress bar: used vs. free storage
- [ ] Color coding: 🟢 >50% free → 🟡 20-50% → 🔴 <20%
- [ ] Tap to expand: System / Games / App Cache / Free breakdown
- [ ] Warning banner when critically low (<2 GB)

### 3.6 🎯 Onboarding & First Launch
**VR research says:** First impressions in VR are critical — disorientation kills engagement.

- [ ] Step-by-step permission flow:
  1. Explain why storage permission is needed (with icon/illustration)
  2. Request `MANAGE_EXTERNAL_STORAGE`
  3. Request `REQUEST_INSTALL_PACKAGES`
  4. "Setup Complete ✅" confirmation with quick tutorial
- [ ] Brief tutorial overlay: "Browse games → Tap to download → Games install automatically"
- [ ] Animated loading screen while fetching initial catalog (not just a spinner)

### 3.7 🏷️ Navigation & Wayfinding Improvements
- [ ] Badge on Downloads tab: active download count + completed count
- [ ] Pull-to-refresh with visual feedback (not just `RefreshIndicator`)
- [ ] "Scroll to top" FAB when user scrolls past 2 screens
- [ ] Haptic feedback on button presses (Quest controllers support this!)
- [ ] Sound effects: download complete chime, install success sound, error alert

### 3.8 🌓 Visual Polish & Animations
**VR research says:** Glow effects and subtle motion cues improve depth perception and interactivity in VR panels.

- [ ] Shimmer loading placeholders while thumbnails load (instead of blank placeholder)
- [ ] Subtle page transition animations (slide, fade)
- [ ] Hover glow effects on interactive cards/buttons (Quest pointer supports hover!)
- [ ] Improved empty states: custom illustrations for empty downloads, no search results
- [ ] App splash screen with logo
- [ ] Custom app icon (currently default Flutter icon)
- [ ] Consistent use of theme colors (audit found hardcoded `Color(0xFF2A2A40)` in `game_card.dart`)

### 3.9 🎨 Fix UI Layout Issues Found in Audit
| Issue | Location | Fix |
|-------|----------|-----|
| Fixed height 400 on ScrollView — overflows small screens | `storage_management_dialog.dart:104` | Use `ConstrainedBox` with `maxHeight` |
| Info cards row has no wrap logic — breaks on narrow panels | `game_detail_page.dart:80-88` | Use `Wrap` widget |
| Dropdown styling doesn't match theme | `sort_filter_bar.dart` | Apply theme accent colors |
| Extraction progress calculation hidden in UI | `download_item.dart:130` | Extract to helper/model |
| No success/failure toast after deletion | `storage_management_dialog.dart` | Add snackbar feedback |
| Hardcoded text sizes instead of theme | Multiple files | Use `Theme.of(context).textTheme` |
| No semantic labels for accessibility | Multiple interactive elements | Add `Semantics` widgets |

---

## 4. ✨ New Features & Competitive Differentiators

### 4.1 📦 "My Games" — Installed Games Manager
**Competitors:** Rookie On Quest has this. SideQuest has this. We need it.

- [ ] New tab or section showing all sideloaded games on device
- [ ] Query installed packages via platform channel (`PackageManager.getInstalledPackages()`)
- [ ] Show: game name, package name, installed version, size on disk
- [ ] Compare installed vs. catalog version → "Update Available" badge
- [ ] "Uninstall" button per game (via `Intent.ACTION_DELETE`)
- [ ] "Update" button → downloads new version and installs over existing
- [ ] "Launch" button → start game's main activity via Intent

### 4.2 🔔 Smart Update System
- [ ] On catalog refresh, diff installed versions vs. catalog
- [ ] Badge on "My Games" showing update count
- [ ] "Update All" button to queue all outdated games
- [ ] Show "X new games since last check" banner on catalog page
- [ ] Highlight new games with "NEW" badge (< 7 days)
- [ ] Last refresh timestamp in catalog header

### 4.3 ⭐ Favorites & Wishlist
**Rookie On Quest has favorites. We should go further.**

- [ ] Heart/star toggle on game cards
- [ ] "Favorites" filter in catalog
- [ ] "Download Later" wishlist for games user wants but doesn't have space for
- [ ] Persist to Hive (already partially implemented via `FavoritesCubit`)
- [ ] Sort favorites to top option

### 4.4 📋 Batch Operations
**Power user feature — no competitor does this well.**

- [ ] Multi-select mode in catalog (long-press to enter, checkboxes appear)
- [ ] Batch download: select multiple → "Download All"
- [ ] Batch uninstall in "My Games"
- [ ] "Select All Updates" for batch update
- [ ] Queue reordering: drag-and-drop priority (Rookie on Windows has this)

### 4.5 🌐 Multiple Mirror Support & Health Monitoring
- [ ] Allow custom mirror URLs in Settings
- [ ] Auto-detect mirror health: ping test, response time display
- [ ] Automatic failover if primary mirror is slow/down
- [ ] Show status: "Connected to Mirror 1 (45 MB/s)" in status bar
- [ ] Mirror speed test on demand

### 4.6 📝 Game Notes & Descriptions
**These files exist in the metadata but are completely unused!**

- [ ] Parse `.meta/notes/{package_name}.txt` from extracted metadata
- [ ] Show on game detail page as description/compatibility notes
- [ ] Show required OBB info and total install footprint
- [ ] Show known issues or special instructions

### 4.7 📊 Download Statistics Dashboard
**Fun feature — users love stats.**

- [ ] Total data downloaded (lifetime)
- [ ] Number of games installed (lifetime)
- [ ] Average and peak download speed
- [ ] Per-session stats: "This session: 3 games, 4.2 GB"
- [ ] Storage saved by cache clearing

### 4.8 🔄 Auto-Update Catalog
- [ ] Periodic background refresh (configurable: daily / weekly / manual)
- [ ] Show notification when new games are available
- [ ] Delta sync: only update changed entries (don't re-download entire meta.7z if unchanged)

### 4.9 🎮 Quick Launch Hub
- [ ] Recently played games section (track launch timestamps)
- [ ] "Continue" button for games you were installing
- [ ] Quick actions: Launch / Update / Uninstall from a single card

### 4.10 🔍 Advanced Search (Differentiator!)
**No competitor does advanced search well.**

- [ ] Filter by size range (e.g., "under 1 GB", "1-5 GB", "5+ GB")
- [ ] Filter by date range (e.g., "added this week", "added this month")
- [ ] Fuzzy search (typo-tolerant)
- [ ] Search history with recent queries
- [ ] Save custom filter presets

---

## 5. 🧪 Testing & Quality Fortress

### 5.1 🚨 Current State: Critical Gap
**Audit result:** Only 5 test files for 79+ source files (~6% coverage). Zero BLoC tests, zero repository tests, zero widget tests.

### 5.2 Unit Tests (Priority)
- [ ] `HashUtils.computeGameId()` — verify MD5 with trailing newline
- [ ] `GameInfoModel.fromCsvLine()` — normal lines, edge cases, malformed input
- [ ] `PublicConfigModel.toEntity()` — base64 password decoding
- [ ] `CatalogBloc` — all events: Load, Search, Filter, Sort (with `bloc_test`)
- [ ] `DownloadsBloc` — queue management, state transitions, pause/resume
- [ ] `InstallerBloc` — pipeline stages, error handling
- [ ] `SettingsCubit` — config save/load, cache clearing
- [ ] `FavoritesCubit` — toggle, persistence
- [ ] `SearchGames` use case — filtering logic
- [ ] `FileUtils` — storage calculations, size formatting
- [ ] All repository implementations — `Either<Failure, T>` wrapping with `mocktail`

### 5.3 Widget Tests
- [ ] `GameCard` — renders correctly, handles tap, shows badges
- [ ] `DownloadItem` — progress bar, speed, ETA, action buttons
- [ ] `SearchBarWidget` — debounce, emits events
- [ ] `SortFilterBar` — emits correct sort/filter events
- [ ] `StorageIndicator` — correct values and color coding

### 5.4 Integration Tests
- [ ] Full catalog flow: config fetch → metadata download → parse → display
- [ ] Download flow: queue → download → progress → completion
- [ ] Settings persistence: change → restart → preserved
- [ ] Error scenarios: network timeout → error state → retry → success

### 5.5 Test Infrastructure
- [ ] Set up test coverage reporting (`flutter test --coverage`)
- [ ] Add coverage gate: minimum 60% for new code
- [ ] Create test fixtures for common data (mock games, configs)
- [ ] Create test helpers for BLoC testing boilerplate

---

## 6. 🚀 DevOps, CI/CD & Release Pipeline

### 6.1 GitHub Actions Pipeline
- [ ] **On every PR:**
  - `flutter analyze` (lint check)
  - `flutter test` (unit + widget tests)
  - `dart run build_runner build` (code generation)
  - `flutter build apk --release --target-platform android-arm64` (build check)
- [ ] **On tag/release:**
  - Build release APK
  - Upload as GitHub Release artifact
  - Auto-generate changelog from commits

### 6.2 Release Management
- [ ] Semantic versioning (vX.Y.Z) with git tags
- [ ] GitHub Releases with APK download link
- [ ] In-app update checker: compare current version with latest GitHub release
- [ ] "New version available" banner with download link

### 6.3 Code Quality Gates
- [ ] Pre-commit hook: `flutter analyze` + `flutter test`
- [ ] PR template with checklist: tests added, no warnings, manual testing done
- [ ] Automated dependency update checks (Dependabot or Renovate)

---

## 7. 🔒 Security & Resilience Hardening

### 7.1 🔐 Credential Security
**Audit found:** Password decoded from base64 stored in memory unencrypted, config file in app docs without encryption, default config with credentials in source code.

- [ ] Don't hardcode fallback server config in `AppConstants` — fetch dynamically only
- [ ] Validate `baseUri` format before using (prevent injection)
- [ ] Clear sensitive config from memory when not actively needed
- [ ] Use `flutter_secure_storage` for credential persistence

### 7.2 🛡️ Crash Resilience
- [ ] Global error handler: `FlutterError.onError` + `PlatformDispatcher.onError`
- [ ] Log crashes to local file (rotated, max 5 MB)
- [ ] User-friendly "Something went wrong" screen with retry button
- [ ] Auto-recovery from common failures (network timeout → retry)

### 7.3 📡 Network Resilience
- [ ] Detect connectivity changes (WiFi disconnect/reconnect)
- [ ] Auto-pause downloads on WiFi disconnect
- [ ] Auto-resume when WiFi reconnects
- [ ] Offline banner when no connectivity
- [ ] Timeout handling with clear user feedback

### 7.4 🔒 Platform Channel Safety
**Audit found:** `MultiReadOnlySeekableByteChannel` not properly closed on exception in `MainActivity.kt`, `pendingResult` may already be cleared during install in `PackageInstallerChannel.kt`.

- [ ] Add proper try-finally blocks around all native resource handles
- [ ] Guard against null `pendingResult` in install callbacks
- [ ] Add timeout for install callbacks (don't hang forever if result never arrives)

---

## 8. 🥽 Quest-Specific VR Optimizations

### 8.1 🎯 VR Input Optimization
**Research says:** Quest pointer is like a mouse but less precise. Design accordingly.

- [ ] Minimum touch targets: 56dp (current Material default of 48dp is too small for VR)
- [ ] Hover states on all interactive elements (Quest pointer supports hover!)
- [ ] Tooltip popups on hover for icons without labels
- [ ] Controller haptic feedback via platform channel on button press
- [ ] Optimize scroll physics for Quest controller thumbstick

### 8.2 🔋 Battery & Performance
- [ ] Minimize widget rebuilds with `const` widgets and `Selector` BlocBuilder
- [ ] Lazy-load game thumbnails (only load visible cards)
- [ ] `ListView.builder` for the catalog (not `ListView` with children — critical for 2400+ games!)
- [ ] Limit initial render to 50 items, infinite scroll pagination for the rest
- [ ] Profile on actual Quest hardware in release mode (debug mode is 5-10x slower)

### 8.3 📐 Adaptive Panel Size
**Quest users can resize the 2D panel.** The app must adapt.

- [ ] Use `LayoutBuilder` and responsive breakpoints
- [ ] Test at minimum panel size (384 x 500dp) — ensure nothing breaks
- [ ] Test at maximum panel size — ensure content fills space
- [ ] Responsive grid: 2 columns at narrow, 3-4 at wide

### 8.4 🎵 Audio & Haptic Feedback
**VR research says:** Multi-sensory feedback improves the experience significantly.

- [ ] Download complete: subtle chime sound
- [ ] Install success: satisfying confirmation sound
- [ ] Error: alert sound
- [ ] Button press: controller haptic pulse
- [ ] Toggle in Settings to disable audio/haptics

---

## 9. ⚡ Performance Deep-Dive

### 9.1 Widget Rebuild Audit
**Found in audit:**
| Issue | Location | Impact |
|-------|----------|--------|
| `BlocBuilder` rebuilds entire catalog UI on every state change | `catalog_page.dart:76-95` | High — jank during search |
| Download card rebuilds on every progress tick | `download_item.dart` | Medium — 60 updates/sec |
| Dialog rebuilds on every selection | `storage_management_dialog.dart:81-90` | Low |

**Fixes:**
- [ ] Use `BlocSelector` to only rebuild what changed
- [ ] Throttle download progress UI updates to max 4/second (250ms)
- [ ] Extract sub-widgets with `const` constructors for static parts

### 9.2 Memory Optimization
- [ ] `catalog_remote_datasource.dart:84` — `readAsLines()` loads entire file. Use streaming for huge catalogs
- [ ] `download_remote_datasource.dart:104-105` — `downloadedFiles` list grows without bounds. Clear after use
- [ ] Image caching: limit thumbnail cache to 100 MB, evict LRU
- [ ] Move 7z extraction to Android `WorkManager` job (avoids main process memory pressure)

### 9.3 Startup Performance
- [ ] Measure cold start time on Quest hardware
- [ ] Shader warmup on first launch (prevent animation jank)
- [ ] Lazy-initialize DI modules (don't create everything at startup)
- [ ] Load catalog from Hive cache first (instant UI), then refresh from network in background

### 9.4 Resource Leak Fixes
**Found in audit:**
- [ ] `connectivity_service.dart:26` — Timer not properly integrated with app lifecycle
- [ ] `search_bar_widget.dart:18` — `_debounce` timer may not cancel on widget dispose
- [ ] Stream subscriptions in BLoCs — ensure `cancel()` in `close()` for all

---

## 10. 📊 Priority Matrix & Implementation Phases

### Priority Matrix

| Priority | Item | Impact | Effort | Category |
|----------|------|--------|--------|----------|
| 🔴 P0 | APK Installation Pipeline (2.1) | **Critical** | High | Core |
| 🔴 P0 | OBB File Copying (2.2) | **Critical** | Medium | Core |
| 🔴 P0 | One-Tap Download & Install (2.3) | **Critical** | High | Core |
| 🔴 P0 | Fix Silent Error Swallowing (1.1) | **Critical** | Low | Quality |
| 🟠 P1 | Foreground Service (2.6) | **High** | Medium | Reliability |
| 🟠 P1 | Pause/Resume Downloads (2.4) | **High** | Medium | Core |
| 🟠 P1 | Queue Persistence (2.5) | **High** | Medium | Reliability |
| 🟠 P1 | Storage Validation (2.7) | **High** | Low | UX |
| 🟠 P1 | User-Agent Fix (1.3) | **High** | Low | Bug |
| 🟠 P1 | Game Detail Page (3.1) | **High** | Medium | UX |
| 🟡 P2 | Full Search & Filtering (3.2) | **Medium** | Low | UX |
| 🟡 P2 | Installed Games Manager (4.1) | **Medium** | Medium | Feature |
| 🟡 P2 | Smart Update System (4.2) | **Medium** | Medium | Feature |
| 🟡 P2 | Architecture Violations Fix (1.4) | **Medium** | Medium | Quality |
| 🟡 P2 | Error Messages (1.1 cont.) | **Medium** | Low | UX |
| 🟡 P2 | Unit Tests (5.2) | **Medium** | Medium | Quality |
| 🟡 P2 | Enhanced Progress Display (2.9) | **Medium** | Low | UX |
| 🟢 P3 | Grid/List Toggle (3.3) | **Low** | Low | UX |
| 🟢 P3 | Favorites & Wishlist (4.3) | **Low** | Low | Feature |
| 🟢 P3 | Batch Operations (4.4) | **Low** | Medium | Feature |
| 🟢 P3 | Game Notes (4.6) | **Low** | Low | Feature |
| 🟢 P3 | CI/CD Pipeline (6.1) | **Low** | Medium | DevOps |
| 🟢 P3 | Visual Polish (3.8) | **Low** | Medium | UX |
| 🟢 P3 | VR Optimizations (8.1-8.4) | **Low** | Medium | Platform |
| 🔵 P4 | Download Statistics (4.7) | **Low** | Low | Feature |
| 🔵 P4 | Quick Launch Hub (4.9) | **Low** | Low | Feature |
| 🔵 P4 | Multiple Mirrors (4.5) | **Low** | Medium | Feature |
| 🔵 P4 | Advanced Search (4.10) | **Low** | Medium | Feature |
| 🔵 P4 | Auto-Update Catalog (4.8) | **Low** | Low | Feature |

---

### 🔴 Phase 1: "Make It Work" (Weeks 1-3)
> **Goal:** The app can download, extract, install, and play a game end-to-end.

| # | Task | Est. |
|---|------|------|
| 1 | Fix silent error swallowing across all files | 2h |
| 2 | Fix User-Agent to consistent `rclone/v1.65.2` via Dio interceptor | 30m |
| 3 | Complete APK Installation Pipeline (Kotlin + Dart) | 2d |
| 4 | Complete OBB File Copying with permission flow | 1d |
| 5 | Build One-Tap "Download & Install" pipeline | 2d |
| 6 | Add storage validation before download | 2h |
| 7 | Remove dead code and unused imports | 1h |

**Milestone:** User taps "Download & Install" → game appears in Quest library. 🎉

---

### 🟠 Phase 2: "Make It Reliable" (Weeks 4-6)
> **Goal:** Downloads survive app kill, Quest sleep, and network interruptions.

| # | Task | Est. |
|---|------|------|
| 8 | Implement real pause/resume with HTTP Range | 1d |
| 9 | Persistent download queue with Hive | 1d |
| 10 | Android Foreground Service for background downloads | 2d |
| 11 | Network resilience: auto-pause/resume on WiFi changes | 4h |
| 12 | Smart retry with exponential backoff | 2h |
| 13 | Duplicate download prevention | 1h |
| 14 | Improve error messages with user-friendly text | 4h |

**Milestone:** User can start a 5 GB download, put Quest to sleep, wake up, and find it completed. 💪

---

### 🟡 Phase 3: "Make It Polished" (Weeks 7-10)
> **Goal:** A delightful UX that makes users recommend the app.

| # | Task | Est. |
|---|------|------|
| 15 | Full Game Detail Page (replace bottom sheet) | 1d |
| 16 | Search & filtering overhaul with debounce and chips | 4h |
| 17 | Grid/List view toggle | 4h |
| 18 | Installed Games Manager with update detection | 2d |
| 19 | Enhanced progress display (pipeline stages) | 4h |
| 20 | Navigation badges and improvements | 2h |
| 21 | Onboarding & first launch experience | 1d |
| 22 | Visual polish: shimmer, animations, empty states | 1d |
| 23 | Custom app icon | 1h |
| 24 | Storage indicator upgrade | 2h |
| 25 | Fix all UI layout issues from audit | 4h |

**Milestone:** App looks and feels professional — users love using it. ✨

---

### 🟢 Phase 4: "Make It Delightful" (Weeks 11-14)
> **Goal:** Power features, testing fortress, and CI/CD maturity.

| # | Task | Est. |
|---|------|------|
| 26 | Unit tests for all BLoCs, Cubits, use cases | 3d |
| 27 | Widget tests for key components | 1d |
| 28 | CI/CD pipeline with GitHub Actions | 4h |
| 29 | Favorites & Wishlist | 4h |
| 30 | Smart Update System ("Update All") | 1d |
| 31 | Batch operations (multi-select download/uninstall) | 1d |
| 32 | Game notes from metadata | 2h |
| 33 | VR input optimization (haptics, hover, tooltips) | 1d |
| 34 | Audio feedback (chimes, alerts) | 4h |
| 35 | Performance audit on Quest hardware | 1d |
| 36 | Fix architecture violations from audit | 1d |

**Milestone:** Production-ready app with test coverage, CI/CD, and power features. 🚀

---

### 🔵 Phase 5: "Make It Extraordinary" (Ongoing)
> **Goal:** Differentiate from every competitor.

| # | Task | Est. |
|---|------|------|
| 37 | Download Statistics Dashboard | 4h |
| 38 | Quick Launch Hub with recents | 4h |
| 39 | Multiple mirror support with health monitoring | 2d |
| 40 | Advanced search (size filters, date ranges, fuzzy) | 1d |
| 41 | Auto-update catalog on schedule | 4h |
| 42 | Adaptive panel sizing for Quest resize | 1d |
| 43 | In-app update checker (GitHub Releases) | 4h |
| 44 | Release management with changelogs | 2h |

**Milestone:** The best Quest sideloader app in the ecosystem. 👑

---

## 💡 Quick Wins (Each < 1 Hour)

| # | Quick Win | Impact | Effort |
|---|-----------|--------|--------|
| 1 | Fix User-Agent to `rclone/v1.65.2` via interceptor | Prevents server rejections | 30m |
| 2 | Remove dead code + unused imports | Cleaner codebase | 30m |
| 3 | Add storage check before download starts | Prevents wasted bandwidth | 45m |
| 4 | Add download count badge on Downloads tab | Better navigation | 20m |
| 5 | Show "X of Y games" result count in search | Better search feedback | 15m |
| 6 | Display cache size in Settings | Users know what's using space | 30m |
| 7 | Persist sort/filter preferences | Better UX continuity | 30m |
| 8 | Fix hardcoded colors → use theme | Visual consistency | 30m |
| 9 | Add shimmer loading for thumbnails | More polished feel | 45m |
| 10 | Add duplicate download prevention | Prevent user confusion | 20m |

---

## 🆚 Competitive Comparison

| Feature | Our App (Current) | Our App (After Plan) | Rookie On Quest | SideQuest | QRookie |
|---------|:-:|:-:|:-:|:-:|:-:|
| Standalone on Quest | ✅ | ✅ | ✅ | ❌ (PC needed) | ❌ (PC needed) |
| One-tap install | ❌ | ✅ | ✅ | ❌ | ❌ |
| Background downloads | ❌ | ✅ | ✅ | N/A | ❌ |
| Persistent queue | ❌ | ✅ | ✅ | N/A | ✅ |
| Pause/Resume | ❌ (fake) | ✅ | ❓ | N/A | ✅ |
| Space validation | ❌ | ✅ | ✅ | N/A | ❌ |
| Installed games manager | ❌ | ✅ | ❓ | ✅ | ✅ |
| Update detection | ❌ | ✅ | ❓ | ✅ | ✅ |
| Favorites | ❌ | ✅ | ✅ | ✅ | ❌ |
| Grid + List views | ❌ | ✅ | ❓ | ✅ | ❌ |
| Batch operations | ❌ | ✅ | ❌ | ❌ | ❌ |
| Advanced search | ❌ | ✅ | ❌ | ❌ | ❌ |
| VR-optimized UI | 🟡 Partial | ✅ | ✅ | ❌ | ❌ |
| Haptic/Audio feedback | ❌ | ✅ | ❓ | ❌ | ❌ |
| Multiple mirrors | ❌ | ✅ | ❌ | N/A | ❌ |
| Cross-platform potential | ✅ (Flutter) | ✅ (Flutter) | ❌ (Kotlin only) | ❌ | ✅ (Qt) |
| Open source | ✅ | ✅ | ✅ | ❌ | ✅ |

---

*Generated: 2026-02-09 | Based on: deep codebase audit (79 Dart files, 2 Kotlin files), AGENTS.md review, competitor analysis (Rookie On Quest, SideQuest, QRookie), VR UI/UX research, Flutter 2026 best practices, and web research.*
