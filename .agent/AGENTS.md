# AI Agents Guide for Quest Game Manager

> **Purpose**: This document provides comprehensive guidance for AI agents working with the Quest Game Manager codebase. It covers architecture, conventions, workflows, and common tasks.

---

## Project Overview

**Quest Game Manager** is a Flutter application designed to run natively on Meta Quest VR headsets (Quest 2, Quest Pro, Quest 3, Quest 3S). It enables users to browse, download, and install Quest games directly on-device.

### Key Technologies
| Technology | Purpose |
|------------|---------|
| Flutter 3.5+ | Cross-platform UI framework |
| flutter_bloc | State management (BLoC/Cubit pattern) |
| get_it + injectable | Dependency injection |
| fpdart | Functional programming, `Either<Failure, T>` error handling |
| freezed | Immutable data classes and sealed unions |
| Hive | Local key-value storage |
| Dio | HTTP client |

---

## Architecture: Clean Architecture

This project follows **Clean Architecture** with a feature-first organization. Each feature is self-contained with three layers:

```
lib/
├── core/                    # Shared utilities across features
│   ├── constants/           # App-wide constants
│   ├── di/                  # Dependency injection modules
│   ├── error/               # Failure types, exceptions
│   ├── theme/               # Material theme configuration
│   ├── usecases/            # Base UseCase class
│   └── utils/               # Utility functions (hashing, file ops)
│
├── features/                # Feature modules
│   ├── catalog/             # Game browsing feature
│   ├── config/              # Remote configuration
│   ├── downloads/           # Download queue management
│   ├── installer/           # APK installation (platform channels)
│   └── settings/            # User preferences
│
├── app.dart                 # Root widget, navigation shell
├── injection.dart           # DI entry point
├── injection.config.dart    # Generated DI config
└── main.dart                # App entry point
```

### Feature Structure (Each Feature)

```
features/<feature_name>/
├── data/                    # Data layer (external world)
│   ├── datasources/         # Remote/local data sources
│   ├── models/              # DTOs, Hive models
│   └── repositories/        # Repository implementations
│
├── domain/                  # Business logic (pure Dart)
│   ├── entities/            # Core business objects
│   ├── repositories/        # Repository interfaces (abstract)
│   └── usecases/            # Application-specific business rules
│
└── presentation/            # UI layer
    ├── bloc/                # BLoC/Cubit + Events + States
    ├── pages/               # Screen widgets
    └── widgets/             # Reusable UI components
```

---

## Core Patterns & Conventions

### 1. Error Handling with `Either<Failure, T>`

All operations that can fail return `Either<Failure, T>` from fpdart:

```dart
// In repository
Future<Either<Failure, List<Game>>> getGameCatalog(PublicConfig config);

// In BLoC
final result = await _getGameCatalog(config);
result.fold(
  (failure) => emit(CatalogState.error(failure)),
  (games) => emit(CatalogState.loaded(games: games)),
);
```

**Failure Types** (defined in `lib/core/error/failures.dart`):
- `NetworkFailure` - Connection issues
- `ServerFailure` - HTTP errors
- `StorageFailure` - Local storage errors
- `ExtractionFailure` - Archive extraction errors
- `InstallationFailure` - APK install errors
- `PermissionFailure` - Missing permissions
- `InsufficientSpaceFailure` - Not enough storage
- `CancelledFailure` - User cancelled
- `UnknownFailure` - Catch-all

### 2. Dependency Injection with Injectable

Use `@injectable`, `@singleton`, or `@lazySingleton` decorators:

```dart
@injectable
class GetGameCatalog {
  GetGameCatalog(this._repository);  // Auto-injected
  final CatalogRepository _repository;
}

@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository { ... }
```

After adding new injectables, regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. State Management with BLoC

**Events and States use freezed sealed classes**:

```dart
// Events (catalog_event.dart)
@freezed
sealed class CatalogEvent with _$CatalogEvent {
  const factory CatalogEvent.load() = CatalogLoad;
  const factory CatalogEvent.search(String query) = CatalogSearch;
}

// States (catalog_state.dart)
@freezed
sealed class CatalogState with _$CatalogState {
  const factory CatalogState.initial() = CatalogInitial;
  const factory CatalogState.loading() = CatalogLoading;
  const factory CatalogState.loaded({required List<Game> games}) = CatalogLoaded;
  const factory CatalogState.error(Failure failure) = CatalogError;
}
```

### 4. Repository Pattern

- **Domain layer**: Abstract repository interfaces
- **Data layer**: Concrete implementations

```dart
// domain/repositories/catalog_repository.dart
abstract class CatalogRepository {
  Future<Either<Failure, List<Game>>> getGameCatalog(PublicConfig config);
}

// data/repositories/catalog_repository_impl.dart
@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository { ... }
```

---

## Android Configuration (Quest-Specific)

### Build Configuration (`android/app/build.gradle.kts`)

```kotlin
android {
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        minSdk = 29          // Quest 2 minimum
        targetSdk = 34       // Google Play requirement
        
        ndk {
            abiFilters += listOf("arm64-v8a")  // Quest is ARM64 only
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false  // Must be false if minify is false
        }
    }
}
```

### AndroidManifest.xml Key Elements

```xml
<!-- Quest device targeting -->
<meta-data android:name="com.oculus.supportedDevices"
           android:value="quest2|questpro|quest3|quest3s" />

<!-- VR panel size -->
<meta-data android:name="com.oculus.display_width" android:value="1024" />
<meta-data android:name="com.oculus.display_height" android:value="640" />

<!-- Required permissions -->
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

---

## Common Development Tasks

### 1. Adding a New Feature

```bash
# Create feature structure
mkdir -p lib/features/<name>/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

Then create:
1. **Entity** in `domain/entities/`
2. **Repository interface** in `domain/repositories/`
3. **UseCases** in `domain/usecases/`
4. **Models** in `data/models/`
5. **DataSources** in `data/datasources/`
6. **Repository implementation** in `data/repositories/`
7. **BLoC/Events/State** in `presentation/bloc/`
8. **Page widget** in `presentation/pages/`

### 2. Code Generation

After modifying freezed classes, Hive models, or injectable annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Running Analysis

```bash
flutter analyze
```

**Lint rules** from `very_good_analysis` are strict. Key rules:
- `prefer_const_constructors` - Use const where possible
- `sort_constructors_first` - Constructors before fields
- `always_put_required_named_parameters_first`
- `sort_pub_dependencies` - Alphabetize pubspec dependencies

### 4. Building for Quest

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### 5. Running Tests

```bash
flutter test
```

---

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Entity | `<name>.dart` | `game.dart` |
| Model | `<name>_model.dart` | `game_info_model.dart` |
| Repository Interface | `<name>_repository.dart` | `catalog_repository.dart` |
| Repository Impl | `<name>_repository_impl.dart` | `catalog_repository_impl.dart` |
| DataSource | `<name>_datasource.dart` | `catalog_remote_datasource.dart` |
| BLoC | `<name>_bloc.dart` | `catalog_bloc.dart` |
| Event | `<name>_event.dart` | `catalog_event.dart` |
| State | `<name>_state.dart` | `catalog_state.dart` |
| Cubit | `<name>_cubit.dart` | `settings_cubit.dart` |
| Page | `<name>_page.dart` | `catalog_page.dart` |
| Widget | `<name>.dart` or descriptive | `game_card.dart` |

---

## Import Conventions

**Always use package imports** for files in `lib/`:

```dart
// ✅ Correct
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

// ❌ Wrong
import '../domain/entities/game.dart';
```

**Import order** (enforced by linter):
1. Dart SDK imports (`dart:`)
2. Flutter imports (`package:flutter/`)
3. Third-party packages
4. Project imports (`package:quest_game_manager/`)

---

## Troubleshooting

### Build Failures

| Error | Solution |
|-------|----------|
| `shrinkResources requires minifyEnabled` | Set `isMinifyEnabled = false` AND `isShrinkResources = false` |
| `ExpiredTargetSdkVersion` | Update `targetSdk` to 34+ |
| `NDK version mismatch` | Update `ndkVersion` in build.gradle.kts |
| Injectable not found | Run `dart run build_runner build --delete-conflicting-outputs` |

### Lint Errors

| Error | Solution |
|-------|----------|
| `sort_constructors_first` | Move constructors/factories before fields |
| `prefer_const_constructors` | Add `const` keyword where applicable |
| `unnecessary_const` | Remove redundant `const` inside const context |
| `avoid_slow_async_io` | Add `// ignore_for_file: avoid_slow_async_io` if necessary |

### Code Generation Issues

```bash
# Clean and regenerate
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, Hive init, DI config |
| `lib/app.dart` | Root widget, MultiBlocProvider, navigation |
| `lib/injection.dart` | GetIt/Injectable setup |
| `lib/core/error/failures.dart` | All Failure types |
| `lib/core/usecases/usecase.dart` | Base UseCase class |
| `lib/core/theme/app_theme.dart` | Material dark theme |
| `android/app/build.gradle.kts` | Android build config |
| `android/app/src/main/AndroidManifest.xml` | Permissions, Quest metadata |
| `pubspec.yaml` | Dependencies (keep sorted!) |
| `analysis_options.yaml` | Lint configuration |

---

## Incomplete Features (TODO)

The following features are partially implemented and require completion:

1. **Installer Feature** (`lib/features/installer/`)
   - Kotlin platform channels for APK installation
   - `PackageInstallerChannel.kt` and `InstallResultReceiver.kt`
   - Full install pipeline with progress tracking

2. **Download Engine**
   - Resume support with HTTP Range headers
   - 7za ARM64 binary for archive extraction
   - Foreground service for background downloads
   - Storage space validation

3. **App Polish**
   - Installed game detection via package manager query
   - Cache clearing in Settings
   - Custom app icon

---

## Quick Command Reference

```bash
# Get dependencies
flutter pub get

# Generate code (freezed, injectable, hive)
dart run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Clean project
flutter clean
```
