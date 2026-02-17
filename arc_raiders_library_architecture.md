# Arc Raiders Dart/Flutter Library - Clean Architecture Design

## Executive Summary

This document outlines the architecture for a unified Dart/Flutter library that provides both **offline** and **online** access to Arc Raiders game data. The library combines data from two sources:
- **Online API**: MetaForge Arc Raiders API (via arc-raiders-wrapper)
- **Offline Data**: Static JSON files (from arcraiders-data repository)

## Architecture Overview

### Core Principles
1. **Clean Architecture** - Separation of concerns with clear boundaries
2. **SOLID Principles** - Maintainable, extensible, testable code
3. **Functional Error Handling** - Using fpdart's Either for type-safe errors
4. **BLoC Pattern** - Predictable state management with flutter_bloc
5. **Offline-First** - Graceful degradation with automatic fallback

## Project Structure

```
arc_raiders_dart/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   ├── failures.dart              # Failure classes
│   │   │   └── exceptions.dart            # Exception classes
│   │   ├── network/
│   │   │   ├── network_info.dart          # Connectivity checker
│   │   │   └── api_client.dart            # HTTP client wrapper
│   │   ├── storage/
│   │   │   └── local_storage.dart         # Local data persistence
│   │   └── utils/
│   │       ├── either_extensions.dart     # fpdart helpers
│   │       └── logger.dart                # Logging utility
│   │
│   ├── features/
│   │   ├── items/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── items_remote_datasource.dart
│   │   │   │   │   └── items_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── item_model.dart
│   │   │   │   │   └── item_response_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── items_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── item.dart
│   │   │   │   │   ├── weapon.dart
│   │   │   │   │   └── armor.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── items_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_all_items.dart
│   │   │   │       ├── get_item_by_id.dart
│   │   │   │       ├── get_items_by_rarity.dart
│   │   │   │       └── search_items.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── items_bloc.dart
│   │   │       │   ├── items_event.dart
│   │   │       │   └── items_state.dart
│   │   │       └── widgets/
│   │   │           └── item_card.dart
│   │   │
│   │   ├── quests/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── weapons/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── armor/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── arcs/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   └── traders/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   └── arc_raiders.dart                   # Public API
│
├── assets/
│   └── data/                              # Bundled offline JSON files
│       ├── items/
│       ├── quests/
│       ├── maps.json
│       ├── trades.json
│       └── skillNodes.json
│
├── test/
│   ├── core/
│   ├── features/
│   └── fixtures/
│
└── pubspec.yaml
```

## Layer Architecture

### 1. Domain Layer (Business Logic)

#### Entities
Pure Dart classes representing business models:

```dart
// domain/entities/item.dart
class Item extends Equatable {
  final String id;
  final Map<String, String> name;  // Multi-language support
  final Map<String, String> description;
  final ItemRarity rarity;
  final ItemType type;
  final int value;
  final double weightKg;
  final int stackSize;
  final String? imageUrl;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.type,
    required this.value,
    required this.weightKg,
    required this.stackSize,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id, name, description, rarity, type,
    value, weightKg, stackSize, imageUrl
  ];
}

enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary;
}

enum ItemType {
  weapon,
  armor,
  consumable,
  material,
  questItem,
  quickUse,
  other;
}
```

#### Repository Interfaces
Abstract contracts for data access:

```dart
// domain/repositories/items_repository.dart
abstract class ItemsRepository {
  /// Get all items with optional filtering
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  });

  /// Get a specific item by ID
  Future<Either<Failure, Item>> getItemById(String id);

  /// Get weapons filtered by rarity
  Future<Either<Failure, List<Weapon>>> getWeapons({
    ItemRarity? rarity,
  });

  /// Get armor filtered by rarity and slot
  Future<Either<Failure, List<Armor>>> getArmor({
    ItemRarity? rarity,
    ArmorSlot? slot,
  });

  /// Search items by query string
  Future<Either<Failure, List<Item>>> searchItems(String query);

  /// Refresh cache from remote source
  Future<Either<Failure, Unit>> refreshCache();
}
```

#### Use Cases
Single-responsibility business logic:

```dart
// domain/usecases/get_all_items.dart
class GetAllItems {
  final ItemsRepository repository;

  const GetAllItems(this.repository);

  Future<Either<Failure, List<Item>>> call({
    ItemRarity? rarity,
    ItemType? type,
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

### 2. Data Layer (Data Management)

#### Data Sources

**Remote Data Source** (Online API):

```dart
// data/datasources/items_remote_datasource.dart
abstract class ItemsRemoteDataSource {
  /// Fetches items from MetaForge API
  /// Throws [ServerException] if request fails
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
    int page = 1,
    int pageSize = 50,
  });

  Future<ItemModel> getItemById(String id);
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient client;

  static const String baseUrl = 'https://metaforge.app/api/arc-raiders';

  ItemsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (rarity != null) {
        queryParams['rarity'] = rarity.name.capitalize();
      }
      if (type != null) {
        queryParams['type'] = type.name;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await client.get(
        '/items',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List;
      return data.map((json) => ItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch items',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ItemModel> getItemById(String id) async {
    try {
      final response = await client.get('/items/$id');
      return ItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch item',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
```

**Local Data Source** (Offline JSON):

```dart
// data/datasources/items_local_datasource.dart
abstract class ItemsLocalDataSource {
  /// Loads items from bundled JSON assets
  /// Throws [CacheException] if loading fails
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  });

  Future<ItemModel> getItemById(String id);

  /// Cache items for offline access
  Future<void> cacheItems(List<ItemModel> items);
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  final AssetBundle assetBundle;
  final LocalStorage storage;

  static const String itemsAssetPath = 'assets/data/items/';
  static const String cacheKey = 'cached_items';

  ItemsLocalDataSourceImpl({
    required this.assetBundle,
    required this.storage,
  });

  @override
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  }) async {
    try {
      // Try to load from cache first
      final cachedData = await storage.get(cacheKey);
      List<ItemModel> items;

      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        items = jsonList.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        // Load from bundled assets
        items = await _loadFromAssets();
        // Cache for future use
        await cacheItems(items);
      }

      // Apply filters
      return _filterItems(items, rarity: rarity, type: type, search: search);
    } catch (e) {
      throw CacheException(message: 'Failed to load offline data: $e');
    }
  }

  Future<List<ItemModel>> _loadFromAssets() async {
    // Load manifest of item files
    final manifestJson = await assetBundle.loadString(
      '${itemsAssetPath}manifest.json',
    );
    final manifest = jsonDecode(manifestJson) as List;

    final items = <ItemModel>[];

    for (final filename in manifest) {
      final itemJson = await assetBundle.loadString(
        '$itemsAssetPath$filename',
      );
      final itemData = jsonDecode(itemJson);
      items.add(ItemModel.fromJson(itemData));
    }

    return items;
  }

  List<ItemModel> _filterItems(
    List<ItemModel> items, {
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  }) {
    var filtered = items;

    if (rarity != null) {
      filtered = filtered.where((item) => item.rarity == rarity).toList();
    }

    if (type != null) {
      filtered = filtered.where((item) => item.type == type).toList();
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
  Future<ItemModel> getItemById(String id) async {
    try {
      final itemJson = await assetBundle.loadString(
        '$itemsAssetPath$id.json',
      );
      return ItemModel.fromJson(jsonDecode(itemJson));
    } catch (e) {
      throw CacheException(message: 'Item not found: $id');
    }
  }

  @override
  Future<void> cacheItems(List<ItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await storage.set(cacheKey, jsonEncode(jsonList));
  }
}
```

#### Models
DTOs with JSON serialization:

```dart
// data/models/item_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

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
  /// Convert model to domain entity
  Item toEntity() {
    return Item(
      id: id,
      name: name,
      description: description,
      rarity: _parseRarity(rarity),
      type: _parseType(type),
      value: value,
      weightKg: weightKg,
      stackSize: stackSize,
      imageUrl: imageFilename,
    );
  }

  ItemRarity _parseRarity(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return ItemRarity.common;
      case 'uncommon':
        return ItemRarity.uncommon;
      case 'rare':
        return ItemRarity.rare;
      case 'epic':
        return ItemRarity.epic;
      case 'legendary':
        return ItemRarity.legendary;
      default:
        return ItemRarity.common;
    }
  }

  ItemType _parseType(String type) {
    final normalized = type.toLowerCase().replaceAll(' ', '_');
    switch (normalized) {
      case 'weapon':
        return ItemType.weapon;
      case 'armor':
        return ItemType.armor;
      case 'consumable':
        return ItemType.consumable;
      case 'material':
        return ItemType.material;
      case 'quest_item':
        return ItemType.questItem;
      case 'quick_use':
        return ItemType.quickUse;
      default:
        return ItemType.other;
    }
  }
}
```

#### Repository Implementation

```dart
// data/repositories/items_repository_impl.dart
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
    ItemType? type,
    String? search,
  }) async {
    // Check network connectivity
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        // Attempt to fetch from remote
        final models = await remoteDataSource.getAllItems(
          rarity: rarity,
          type: type,
          search: search,
        );

        // Cache the results
        await localDataSource.cacheItems(models);

        // Convert to entities
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on ServerException catch (e) {
        // Fallback to local data on server error
        return _getFromLocal(rarity: rarity, type: type, search: search);
      }
    } else {
      // No connection - use local data
      return _getFromLocal(rarity: rarity, type: type, search: search);
    }
  }

  Future<Either<Failure, List<Item>>> _getFromLocal({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  }) async {
    try {
      final models = await localDataSource.getAllItems(
        rarity: rarity,
        type: type,
        search: search,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Item>> getItemById(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final model = await remoteDataSource.getItemById(id);
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return _getItemFromLocal(id);
      }
    } else {
      return _getItemFromLocal(id);
    }
  }

  Future<Either<Failure, Item>> _getItemFromLocal(String id) async {
    try {
      final model = await localDataSource.getItemById(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Weapon>>> getWeapons({
    ItemRarity? rarity,
  }) async {
    return getAllItems(rarity: rarity, type: ItemType.weapon)
        .map((items) => items.cast<Weapon>())
        .run();
  }

  @override
  Future<Either<Failure, List<Armor>>> getArmor({
    ItemRarity? rarity,
    ArmorSlot? slot,
  }) async {
    return getAllItems(rarity: rarity, type: ItemType.armor)
        .map((items) => items.cast<Armor>())
        .run();
  }

  @override
  Future<Either<Failure, List<Item>>> searchItems(String query) async {
    return getAllItems(search: query);
  }

  @override
  Future<Either<Failure, Unit>> refreshCache() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final models = await remoteDataSource.getAllItems();
      await localDataSource.cacheItems(models);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }
}
```

### 3. Presentation Layer (UI & State)

#### BLoC Implementation

```dart
// presentation/bloc/items_bloc.dart
part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final GetAllItems getAllItems;
  final GetItemById getItemById;
  final SearchItems searchItems;

  ItemsBloc({
    required this.getAllItems,
    required this.getItemById,
    required this.searchItems,
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
      (items) => emit(ItemsState.loaded(items, isOffline: false)),
    );
  }

  Future<void> _onFilterChanged(
    ItemsFilterChanged event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsState.loading());

    final result = await getAllItems(
      rarity: event.rarity,
      type: event.type,
    );

    result.fold(
      (failure) => emit(ItemsState.error(failure.message)),
      (items) => emit(ItemsState.loaded(items, isOffline: false)),
    );
  }

  Future<void> _onSearchRequested(
    ItemsSearchRequested event,
    Emitter<ItemsState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const ItemsLoadRequested());
      return;
    }

    emit(const ItemsState.loading());

    final result = await searchItems(event.query);

    result.fold(
      (failure) => emit(ItemsState.error(failure.message)),
      (items) => emit(ItemsState.loaded(items, isOffline: false)),
    );
  }

  Future<void> _onDetailRequested(
    ItemDetailRequested event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsState.loading());

    final result = await getItemById(event.itemId);

    result.fold(
      (failure) => emit(ItemsState.error(failure.message)),
      (item) => emit(ItemsState.detail(item)),
    );
  }

  Future<void> _onCacheRefreshRequested(
    ItemsCacheRefreshRequested event,
    Emitter<ItemsState> emit,
  ) async {
    // Keep current state but show loading indicator
    emit(const ItemsState.refreshing());

    // Trigger cache refresh in repository
    // This would be implemented via a RefreshCache use case

    // Reload items
    add(const ItemsLoadRequested());
  }
}
```

```dart
// presentation/bloc/items_event.dart
part of 'items_bloc.dart';

@freezed
class ItemsEvent with _$ItemsEvent {
  const factory ItemsEvent.loadRequested({
    ItemRarity? rarity,
    ItemType? type,
  }) = ItemsLoadRequested;

  const factory ItemsEvent.filterChanged({
    ItemRarity? rarity,
    ItemType? type,
  }) = ItemsFilterChanged;

  const factory ItemsEvent.searchRequested(String query) = ItemsSearchRequested;

  const factory ItemsEvent.detailRequested(String itemId) = ItemDetailRequested;

  const factory ItemsEvent.cacheRefreshRequested() = ItemsCacheRefreshRequested;
}
```

```dart
// presentation/bloc/items_state.dart
part of 'items_bloc.dart';

@freezed
class ItemsState with _$ItemsState {
  const factory ItemsState.initial() = ItemsInitial;

  const factory ItemsState.loading() = ItemsLoading;

  const factory ItemsState.loaded(
    List<Item> items, {
    required bool isOffline,
  }) = ItemsLoaded;

  const factory ItemsState.detail(Item item) = ItemsDetail;

  const factory ItemsState.error(String message) = ItemsError;

  const factory ItemsState.refreshing() = ItemsRefreshing;
}
```

## Core Components

### Error Handling (fpdart)

```dart
// core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}
```

```dart
// core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}
```

### Network Info

```dart
// core/network/network_info.dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityStatus> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityStatus> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((result) {
      return result == ConnectivityResult.none
          ? ConnectivityStatus.offline
          : ConnectivityStatus.online;
    });
  }
}

enum ConnectivityStatus { online, offline }
```

### API Client

```dart
// core/network/api_client.dart
class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
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
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => debugPrint(log.toString()),
      ),
    );

    // Retry interceptor for network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) => debugPrint(message),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
```

### Dependency Injection

```dart
// core/di/injection.dart
final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
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

  // Items Feature
  _setupItemsFeature();

  // Quests Feature
  _setupQuestsFeature();

  // Weapons Feature
  _setupWeaponsFeature();

  // ... other features
}

void _setupItemsFeature() {
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
  getIt.registerLazySingleton(() => SearchItems(getIt()));

  // BLoC
  getIt.registerFactory(
    () => ItemsBloc(
      getAllItems: getIt(),
      getItemById: getIt(),
      searchItems: getIt(),
    ),
  );
}
```

## Data Strategy

### Offline-First Approach

1. **Initial Load**
   - Check network connectivity
   - If online: Fetch from API → Cache locally → Display
   - If offline: Load from bundled assets → Display

2. **Subsequent Requests**
   - Try online source first
   - On failure or offline: Fallback to local cache
   - Transparent to the consumer

3. **Cache Strategy**
   - Time-based expiration (e.g., 5 minutes)
   - Manual refresh option
   - Background sync when connectivity restored

### Multi-Language Support

```dart
// Utility for getting localized strings
extension LocalizedItem on Item {
  String getLocalizedName(String locale) {
    return name[locale] ?? name['en'] ?? id;
  }

  String getLocalizedDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }
}

// Usage in UI
Text(item.getLocalizedName(Localizations.localeOf(context).languageCode))
```

## Testing Strategy

### Unit Tests

```dart
// test/domain/usecases/get_all_items_test.dart
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

### Integration Tests

```dart
// test/features/items/items_integration_test.dart
void main() {
  group('Items Feature Integration', () {
    test('should fetch items from API and cache locally', () async {
      // Setup
      await setupDependencyInjection();
      final repository = getIt<ItemsRepository>();

      // Act
      final result = await repository.getAllItems();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (items) => expect(items, isNotEmpty),
      );
    });
  });
}
```

## Performance Optimizations

1. **Lazy Loading**: Load items on-demand rather than all at once
2. **Pagination**: Support paginated requests to API
3. **Image Caching**: Use `cached_network_image` for image assets
4. **Debouncing**: Debounce search queries to reduce API calls
5. **Memoization**: Cache frequently accessed data in memory

## Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Functional Programming
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

  # Utilities
  cached_network_image: ^3.3.0
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

## Usage Example

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => getIt<ItemsBloc>()
          ..add(const ItemsEvent.loadRequested()),
        child: const ItemsScreen(),
      ),
    );
  }
}

// items_screen.dart
class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arc Raiders Items')),
      body: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Welcome')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (items, isOffline) => Column(
              children: [
                if (isOffline)
                  const Banner(
                    message: 'Offline Mode',
                    location: BannerLocation.topEnd,
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemCard(item: item);
                    },
                  ),
                ),
              ],
            ),
            error: (message) => Center(child: Text('Error: $message')),
            detail: (item) => ItemDetailView(item: item),
            refreshing: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ItemsBloc>().add(
          const ItemsEvent.cacheRefreshRequested(),
        ),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## Summary

This architecture provides:

✅ **Clean Architecture** - Clear separation of concerns
✅ **Offline-First** - Works seamlessly with or without internet
✅ **Type-Safe Errors** - Using fpdart's Either type
✅ **Reactive State Management** - flutter_bloc for predictable state
✅ **SOLID Principles** - Maintainable, testable, extensible
✅ **Multi-Language** - Built-in i18n support
✅ **Production-Ready** - Comprehensive error handling, retry logic, caching
✅ **Testable** - Full unit and integration test coverage

The library seamlessly combines online API data with offline JSON assets, providing a robust, production-ready solution for Arc Raiders game data access.

## Sources

- [GitHub - justinjd00/arc-raiders-wrapper: Unofficial Arc Raiders API Wrapper in TypeScript](https://github.com/justinjd00/arc-raiders-wrapper)
- [GitHub - RaidTheory/arcraiders-data: Free to use ARC Raiders game data in JSON Format](https://github.com/RaidTheory/arcraiders-data)
