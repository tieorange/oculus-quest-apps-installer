# Technical Prompt: Build Arc Raiders Dart/Flutter Library

## Project Overview

Create a production-ready Dart/Flutter library named `arc_raiders_dart` that provides unified access to Arc Raiders game data through both **online** (MetaForge API) and **offline** (static JSON) modes. The library must implement Clean Architecture, use flutter_bloc for state management, and fpdart for functional error handling.

## Core Requirements

### 1. Architecture Pattern

Implement **Clean Architecture** with three distinct layers:

```
Presentation Layer → Domain Layer → Data Layer → External Sources
```

**Mandatory Principles:**
- Single Responsibility Principle (SRP)
- Open/Closed Principle (OCP)
- Liskov Substitution Principle (LSP)
- Interface Segregation Principle (ISP)
- Dependency Inversion Principle (DIP)

### 2. Data Sources

#### Online Source: MetaForge API
- **Base URL**: `https://metaforge.app/api/arc-raiders`
- **Endpoints**:
  - `GET /items` - Paginated items list (supports filters: rarity, type, search)
  - `GET /items/:id` - Single item details
  - `GET /quests` - Quest data with objectives and rewards
  - `GET /arcs` - ARC mission data
  - `GET /traders` - Trader inventory
  - `GET /game-map-data?map=<map-name>` - Map coordinates and POIs

**API Response Format:**
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 500,
    "totalPages": 10,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

#### Offline Source: Static JSON Files
- **Repository**: https://github.com/RaidTheory/arcraiders-data
- **Structure**:
  - `/items/*.json` - Individual item files (500+ items)
  - `/quests/*.json` - Quest files
  - `/maps.json` - Map data array
  - `/trades.json` - Trader pricing
  - `/skillNodes.json` - Skill tree data
  - `/projects.json` - Hideout projects

**Item JSON Schema:**
```json
{
  "id": "acoustic_guitar",
  "name": {
    "en": "Acoustic Guitar",
    "es": "Guitarra acústica",
    "... 18 more languages"
  },
  "description": {
    "en": "A playable acoustic guitar...",
    "... 18 more languages"
  },
  "type": "Quick Use",
  "rarity": "Legendary",
  "value": 7000,
  "weightKg": 1,
  "stackSize": 1,
  "recyclesInto": {
    "metal_parts": 4,
    "wires": 6
  },
  "salvagesInto": {
    "wires": 3
  },
  "imageFilename": "https://cdn.arctracker.io/items/acoustic_guitar.png",
  "updatedAt": "01/13/2026"
}
```

### 3. Technology Stack

**Required Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Functional Programming & Error Handling
  fpdart: ^1.1.0

  # Networking
  dio: ^5.4.0
  connectivity_plus: ^5.0.2

  # Local Storage
  shared_preferences: ^2.2.2

  # JSON Serialization
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # Dependency Injection
  get_it: ^7.6.4

  # UI Utilities
  cached_network_image: ^3.3.0

  # Logging
  logger: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1

  # Testing
  mocktail: ^1.0.1
  bloc_test: ^9.1.5
```

## Implementation Specifications

### Layer 1: Domain Layer (Business Logic)

#### 1.1 Entities

Create pure Dart entities with no external dependencies:

**`lib/features/items/domain/entities/item.dart`**
```dart
class Item extends Equatable {
  final String id;
  final Map<String, String> name;        // Multi-language support
  final Map<String, String> description; // Multi-language support
  final ItemRarity rarity;
  final String type;
  final int value;
  final double weightKg;
  final int stackSize;
  final Map<String, int>? recyclesInto;
  final Map<String, int>? salvagesInto;
  final String? imageUrl;
  final String? updatedAt;

  const Item({...});

  // Localization helper
  String getLocalizedName(String locale) {
    return name[locale] ?? name['en'] ?? id;
  }

  String getLocalizedDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  @override
  List<Object?> get props => [...];
}

enum ItemRarity {
  common('Common'),
  uncommon('Uncommon'),
  rare('Rare'),
  epic('Epic'),
  legendary('Legendary');

  final String displayName;
  const ItemRarity(this.displayName);

  static ItemRarity fromString(String value) {
    final normalized = value.toLowerCase();
    return ItemRarity.values.firstWhere(
      (rarity) => rarity.name.toLowerCase() == normalized,
      orElse: () => ItemRarity.common,
    );
  }
}
```

**Additional Entities Required:**
- `Quest` with objectives, rewards, trader info
- `Map` with POIs and coordinates
- `Trader` with inventory
- `ArcMission` with loot tables
- `SkillNode` with requirements and effects

#### 1.2 Repository Interfaces

**`lib/features/items/domain/repositories/items_repository.dart`**
```dart
abstract class ItemsRepository {
  /// Get all items with optional filtering
  /// Returns Right(List<Item>) on success
  /// Returns Left(Failure) on error
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  });

  Future<Either<Failure, Item>> getItemById(String id);
  Future<Either<Failure, List<Item>>> searchItems(String query);
  Future<Either<Failure, Unit>> refreshCache();
  Future<bool> isCached();
}
```

#### 1.3 Use Cases

**`lib/features/items/domain/usecases/get_all_items.dart`**
```dart
class GetAllItems {
  final ItemsRepository repository;

  const GetAllItems(this.repository);

  Future<Either<Failure, List<Item>>> call({
    ItemRarity? rarity,
    String? type,
    String? search,
  }) async {
    return await repository.getAllItems(
      rarity: rarity,
      type: type,
      search: search,
    );
  }
}
```

**Required Use Cases:**
- `GetAllItems`
- `GetItemById`
- `SearchItems`
- `GetAllQuests`
- `GetQuestById`
- `GetTraders`
- `GetMaps`
- `RefreshCache`

### Layer 2: Data Layer

#### 2.1 Models with JSON Serialization

**`lib/features/items/data/models/item_model.dart`**
```dart
@freezed
class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String id,
    required Map<String, String> name,
    required Map<String, String> description,
    required String rarity,
    required String type,
    required int value,
    required double weightKg,
    required int stackSize,
    Map<String, int>? recyclesInto,
    Map<String, int>? salvagesInto,
    String? imageFilename,
    String? updatedAt,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}

extension ItemModelX on ItemModel {
  Item toEntity() {
    return Item(
      id: id,
      name: name,
      description: description,
      rarity: ItemRarity.fromString(rarity),
      type: type,
      value: value,
      weightKg: weightKg,
      stackSize: stackSize,
      recyclesInto: recyclesInto,
      salvagesInto: salvagesInto,
      imageUrl: imageFilename,
      updatedAt: updatedAt,
    );
  }
}
```

#### 2.2 Remote Data Source (Online API)

**`lib/features/items/data/datasources/items_remote_datasource.dart`**

Requirements:
- Use Dio for HTTP requests
- Handle pagination automatically (fetch all pages)
- Implement retry logic for failed requests (3 retries with exponential backoff)
- Parse API responses and convert to models
- Throw `ServerException` on errors with status codes

```dart
class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient client;

  @override
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (rarity != null) queryParams['rarity'] = rarity.displayName;
      if (type != null) queryParams['type'] = type;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await client.get('/items', queryParameters: queryParams);

      // Parse paginated response
      final List<ItemModel> allItems = [];
      final data = response.data['data'] as List;
      allItems.addAll(data.map((json) => ItemModel.fromJson(json)));

      // Fetch remaining pages if hasNextPage is true
      final pagination = response.data['pagination'];
      if (pagination?['hasNextPage'] == true) {
        final nextPage = await getAllItems(
          rarity: rarity,
          type: type,
          search: search,
          page: page + 1,
          pageSize: pageSize,
        );
        allItems.addAll(nextPage);
      }

      return allItems;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch items',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
```

#### 2.3 Local Data Source (Offline JSON)

**`lib/features/items/data/datasources/items_local_datasource.dart`**

Requirements:
- Load JSON files from bundled assets
- Implement caching with SharedPreferences
- Cache expiration: 24 hours
- Fallback chain: Cache → Bundled Assets
- Client-side filtering (rarity, type, search)

**Asset Structure:**
```
assets/
└── data/
    ├── items/
    │   ├── manifest.json          # List of all item files
    │   ├── acoustic_guitar.json
    │   ├── adrenaline_shot.json
    │   └── ... (500+ files)
    ├── quests/
    │   ├── manifest.json
    │   └── *.json
    ├── maps.json
    ├── trades.json
    └── skillNodes.json
```

**manifest.json format:**
```json
[
  "acoustic_guitar.json",
  "adrenaline_shot.json",
  "advanced_arc_powercell.json",
  ...
]
```

```dart
class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  final AssetBundle assetBundle;
  final LocalStorage storage;

  static const String itemsAssetPath = 'packages/arc_raiders_dart/assets/data/items/';
  static const String cacheKey = 'cached_items';
  static const String cacheTimestampKey = 'cached_items_timestamp';
  static const Duration cacheDuration = Duration(hours: 24);

  @override
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  }) async {
    try {
      List<ItemModel> items;

      // Try cache first
      if (await isCached()) {
        final cachedData = await storage.get(cacheKey);
        if (cachedData != null) {
          final List<dynamic> jsonList = jsonDecode(cachedData);
          items = jsonList.map((json) => ItemModel.fromJson(json)).toList();
        } else {
          items = await _loadFromAssets();
        }
      } else {
        items = await _loadFromAssets();
      }

      // Apply client-side filters
      return _filterItems(items, rarity: rarity, type: type, search: search);
    } catch (e) {
      throw CacheException(message: 'Failed to load offline data: $e');
    }
  }

  Future<List<ItemModel>> _loadFromAssets() async {
    final items = <ItemModel>[];

    // Load manifest
    final manifestJson = await assetBundle.loadString(
      '${itemsAssetPath}manifest.json',
    );
    final manifest = jsonDecode(manifestJson) as List;

    // Load each item file
    for (final filename in manifest) {
      try {
        final itemJson = await assetBundle.loadString(
          '$itemsAssetPath$filename',
        );
        final itemData = jsonDecode(itemJson);
        items.add(ItemModel.fromJson(itemData));
      } catch (e) {
        // Skip invalid items
        continue;
      }
    }

    return items;
  }

  List<ItemModel> _filterItems(
    List<ItemModel> items, {
    ItemRarity? rarity,
    String? type,
    String? search,
  }) {
    var filtered = items;

    if (rarity != null) {
      filtered = filtered.where((item) {
        return ItemRarity.fromString(item.rarity) == rarity;
      }).toList();
    }

    if (type != null) {
      filtered = filtered.where((item) {
        return item.type.toLowerCase() == type.toLowerCase();
      }).toList();
    }

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      filtered = filtered.where((item) {
        final nameMatch = item.name.values.any(
          (name) => name.toLowerCase().contains(query),
        );
        final descMatch = item.description.values.any(
          (desc) => desc.toLowerCase().contains(query),
        );
        return nameMatch || descMatch;
      }).toList();
    }

    return filtered;
  }

  @override
  Future<bool> isCached() async {
    final timestamp = await storage.get(cacheTimestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp),
    );
    final now = DateTime.now();

    return now.difference(cachedTime) < cacheDuration;
  }
}
```

#### 2.4 Repository Implementation

**`lib/features/items/data/repositories/items_repository_impl.dart`**

**Offline-First Strategy:**
```
1. Check network connectivity
2. If online:
   - Try remote API
   - On success: cache data + return
   - On failure: fallback to local
3. If offline:
   - Load from local (cache or assets)
```

```dart
class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource remoteDataSource;
  final ItemsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ItemsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final models = await remoteDataSource.getAllItems(
          rarity: rarity,
          type: type,
          search: search,
        );

        // Cache for offline use
        await localDataSource.cacheItems(models);

        final entities = models.map((model) => model.toEntity()).toList();
        return right(entities);
      } on ServerException catch (e) {
        // Fallback to local on server error
        return _getFromLocal(rarity: rarity, type: type, search: search);
      }
    } else {
      return _getFromLocal(rarity: rarity, type: type, search: search);
    }
  }

  Future<Either<Failure, List<Item>>> _getFromLocal({
    ItemRarity? rarity,
    String? type,
    String? search,
  }) async {
    try {
      final models = await localDataSource.getAllItems(
        rarity: rarity,
        type: type,
        search: search,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return right(entities);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }
}
```

### Layer 3: Presentation Layer

#### 3.1 BLoC Implementation

**`lib/features/items/presentation/bloc/items_bloc.dart`**

Use freezed for events and states:

**Events:**
```dart
@freezed
class ItemsEvent with _$ItemsEvent {
  const factory ItemsEvent.loadRequested({
    ItemRarity? rarity,
    String? type,
  }) = ItemsLoadRequested;

  const factory ItemsEvent.filterChanged({
    ItemRarity? rarity,
    String? type,
  }) = ItemsFilterChanged;

  const factory ItemsEvent.searchRequested(String query) = ItemsSearchRequested;

  const factory ItemsEvent.detailRequested(String itemId) = ItemDetailRequested;

  const factory ItemsEvent.cacheRefreshRequested() = ItemsCacheRefreshRequested;
}
```

**States:**
```dart
@freezed
class ItemsState with _$ItemsState {
  const factory ItemsState.initial() = ItemsInitial;
  const factory ItemsState.loading() = ItemsLoading;
  const factory ItemsState.loaded({
    required List<Item> items,
    @Default(false) bool isOffline,
  }) = ItemsLoaded;
  const factory ItemsState.detail(Item item) = ItemsDetail;
  const factory ItemsState.error(String message) = ItemsError;
  const factory ItemsState.refreshing() = ItemsRefreshing;
}
```

**BLoC:**
```dart
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final GetAllItems getAllItems;
  final GetItemById getItemById;

  ItemsBloc({
    required this.getAllItems,
    required this.getItemById,
  }) : super(const ItemsState.initial()) {
    on<ItemsLoadRequested>(_onLoadRequested);
    on<ItemsFilterChanged>(_onFilterChanged);
    on<ItemsSearchRequested>(_onSearchRequested);
    on<ItemDetailRequested>(_onDetailRequested);
    on<ItemsCacheRefreshRequested>(_onCacheRefreshRequested);
  }

  Future<void> _onLoadRequested(
    ItemsLoadRequested event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsState.loading());

    final result = await getAllItems(
      rarity: event.rarity,
      type: event.type,
    );

    result.fold(
      (failure) => emit(ItemsState.error(failure.message)),
      (items) => emit(ItemsState.loaded(items: items)),
    );
  }

  // Implement other event handlers...
}
```

### Core Components

#### 4.1 Error Handling

**`lib/core/error/failures.dart`**
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
```

**`lib/core/error/exceptions.dart`**
```dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
```

#### 4.2 Network Info

**`lib/core/network/network_info.dart`**
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      return results.any((result) => result != ConnectivityResult.none);
    });
  }
}
```

#### 4.3 API Client

**`lib/core/network/api_client.dart`**
```dart
class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 30),
    Map<String, String>? headers,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: timeout,
            receiveTimeout: timeout,
            headers: headers ?? {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    // Add retry interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
```

#### 4.4 Dependency Injection

**`lib/core/di/injection.dart`**
```dart
final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => rootBundle);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: 'https://metaforge.app/api/arc-raiders',
      timeout: const Duration(seconds: 30),
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sharedPreferences),
  );

  // Features
  await _setupItemsFeature();
  await _setupQuestsFeature();
  await _setupMapsFeature();
  await _setupTradersFeature();
}

Future<void> _setupItemsFeature() async {
  // Data sources
  getIt.registerLazySingleton<ItemsRemoteDataSource>(
    () => ItemsRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ItemsLocalDataSource>(
    () => ItemsLocalDataSourceImpl(
      assetBundle: getIt(),
      storage: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<ItemsRepository>(
    () => ItemsRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllItems(getIt()));
  getIt.registerLazySingleton(() => GetItemById(getIt()));

  // BLoC
  getIt.registerFactory(
    () => ItemsBloc(
      getAllItems: getIt(),
      getItemById: getIt(),
    ),
  );
}
```

## Testing Requirements

### Unit Tests (70% coverage)

**Test all layers independently:**

```dart
// test/features/items/domain/usecases/get_all_items_test.dart
void main() {
  late GetAllItems useCase;
  late MockItemsRepository mockRepository;

  setUp(() {
    mockRepository = MockItemsRepository();
    useCase = GetAllItems(mockRepository);
  });

  group('GetAllItems', () {
    test('should return list of items from repository', () async {
      // Arrange
      final tItems = [
        Item(id: '1', name: {'en': 'Test'}, ...),
      ];
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => Right(tItems));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tItems));
      verify(() => mockRepository.getAllItems()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
```

**Required Test Coverage:**
- All use cases (100%)
- All repository methods (100%)
- All data sources (100%)
- All BLoC events/states (100%)
- All models (JSON serialization)

### Integration Tests (20% coverage)

```dart
void main() {
  group('Items Feature Integration', () {
    testWidgets('should fetch items from API and cache locally', (tester) async {
      await setupDependencyInjection();
      final repository = getIt<ItemsRepository>();

      final result = await repository.getAllItems();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (items) => expect(items, isNotEmpty),
      );
    });

    testWidgets('should handle offline mode', (tester) async {
      // Setup offline environment
      final mockNetworkInfo = MockNetworkInfo();
      when(() => mockNetworkInfo.isConnected).thenReturn(false);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Offline Mode'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
```

## Performance Requirements

### 1. Pagination Strategy
- Load items in batches of 50
- Implement infinite scroll for UI
- Cache loaded pages in memory

### 2. Search Debouncing
- Debounce search queries by 500ms
- Cancel in-flight requests on new search

### 3. Image Caching
- Use `cached_network_image` for all images
- Cache duration: 7 days
- Max cache size: 200 images

### 4. Background Sync
- Sync cache every 6 hours when app is active
- Respect battery optimization settings

## File Structure

```
arc_raiders_dart/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── network/
│   │   │   ├── network_info.dart
│   │   │   └── api_client.dart
│   │   ├── storage/
│   │   │   └── local_storage.dart
│   │   └── di/
│   │       └── injection.dart
│   │
│   ├── features/
│   │   ├── items/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── items_remote_datasource.dart
│   │   │   │   │   └── items_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── item_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── items_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── item.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── items_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_all_items.dart
│   │   │   │       └── get_item_by_id.dart
│   │   │   └── presentation/
│   │   │       └── bloc/
│   │   │           ├── items_bloc.dart
│   │   │           ├── items_event.dart
│   │   │           └── items_state.dart
│   │   │
│   │   ├── quests/
│   │   ├── maps/
│   │   ├── traders/
│   │   └── arcs/
│   │
│   └── arc_raiders.dart
│
├── assets/
│   └── data/
│       ├── items/
│       │   ├── manifest.json
│       │   └── *.json
│       ├── quests/
│       ├── maps.json
│       └── trades.json
│
├── test/
├── example/
├── pubspec.yaml
└── README.md
```

## Acceptance Criteria

### Functional Requirements
- ✅ Fetch items from MetaForge API with pagination
- ✅ Load items from offline JSON files
- ✅ Automatic fallback from online to offline
- ✅ Multi-language support (20+ languages)
- ✅ Search items by name/description
- ✅ Filter items by rarity and type
- ✅ Cache management with 24-hour TTL
- ✅ Network connectivity detection
- ✅ Offline mode indicator in UI

### Non-Functional Requirements
- ✅ Clean Architecture implementation
- ✅ SOLID principles adherence
- ✅ Type-safe error handling with fpdart
- ✅ Reactive state management with flutter_bloc
- ✅ 70%+ unit test coverage
- ✅ 20%+ integration test coverage
- ✅ Comprehensive documentation
- ✅ Performance optimized (debouncing, pagination, caching)

### Code Quality
- ✅ Follow Dart/Flutter style guide
- ✅ Use freezed for immutable classes
- ✅ Use equatable for value equality
- ✅ Proper error handling at all layers
- ✅ Meaningful variable/function names
- ✅ No code duplication
- ✅ Single responsibility per class/function

## Implementation Steps

1. **Setup Project** (1 hour)
   - Create Flutter package
   - Add dependencies
   - Setup folder structure

2. **Core Layer** (2 hours)
   - Implement error classes
   - Create NetworkInfo
   - Build ApiClient
   - Setup LocalStorage
   - Configure DI

3. **Items Feature - Domain** (2 hours)
   - Create Item entity
   - Define ItemsRepository interface
   - Implement use cases

4. **Items Feature - Data** (4 hours)
   - Create ItemModel with freezed
   - Implement RemoteDataSource
   - Implement LocalDataSource
   - Build RepositoryImpl
   - Setup asset loading

5. **Items Feature - Presentation** (2 hours)
   - Create BLoC with events/states
   - Implement event handlers

6. **Testing** (4 hours)
   - Write unit tests for all layers
   - Create integration tests
   - Test offline/online scenarios

7. **Repeat for Other Features** (8 hours)
   - Quests
   - Maps
   - Traders
   - ARCs

8. **Example App** (2 hours)
   - Create demo UI
   - Show all features
   - Demonstrate offline mode

9. **Documentation** (2 hours)
   - Write README
   - Generate API docs
   - Create usage examples

## References

### Data Sources
- **MetaForge API**: https://metaforge.app/arc-raiders/api
- **API Database**: https://metaforge.app/arc-raiders/database/items/page/1
- **TypeScript Wrapper**: https://github.com/justinjd00/arc-raiders-wrapper
- **Offline Data**: https://github.com/RaidTheory/arcraiders-data
- **Community API**: https://github.com/Mahcks/arcraiders-data-api

### Technical Documentation
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **flutter_bloc**: https://bloclibrary.dev/
- **fpdart**: https://pub.dev/packages/fpdart
- **freezed**: https://pub.dev/packages/freezed
- **get_it**: https://pub.dev/packages/get_it

### Arc Raiders Game
- **Official Site**: https://arcraiders.com/
- **MetaForge Tools**: https://metaforge.app/arc-raiders
- **Community Discord**: https://discord.gg/pAtQ4Aw8em (from arcraiders-data repo)

## Expected Deliverables

1. ✅ Complete Dart package with all features
2. ✅ Unit tests (70%+ coverage)
3. ✅ Integration tests (20%+ coverage)
4. ✅ Example Flutter app
5. ✅ README with usage instructions
6. ✅ API documentation (dartdoc)
7. ✅ pubspec.yaml ready for pub.dev

## Success Metrics

- **Code Quality**: Passes all linting rules
- **Test Coverage**: >70% overall
- **Performance**: Initial load < 2s
- **Offline Support**: Works without internet 100%
- **API Success Rate**: >95% when online
- **Cache Hit Rate**: >80% for repeat requests

---

**IMPORTANT NOTES:**

1. **Data Attribution**: All data from RaidTheory/arcraiders-data must be attributed in README and code comments
2. **License**: Use MIT license for the package
3. **Offline Assets**: Download JSON files from arcraiders-data repo and include in assets/
4. **Code Generation**: Run `flutter pub run build_runner build --delete-conflicting-outputs` after creating models
5. **API Limitations**: MetaForge API may have rate limits - implement proper error handling
6. **Cloudflare Protection**: API may return 403 errors due to bot protection - handle gracefully with fallback to offline
7. **Multi-Language**: Always use `getLocalizedName()` and `getLocalizedDescription()` in UI code
8. **Error Messages**: Provide user-friendly error messages, not technical stack traces

This prompt provides everything needed to build a production-ready Arc Raiders Dart/Flutter library with clean architecture, offline-first capabilities, and comprehensive testing.
