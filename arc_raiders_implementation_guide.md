# Arc Raiders Library - Implementation Guide

## Quick Start Implementation

### Step 1: Project Setup

```bash
# Create new Flutter package
flutter create --template=package arc_raiders_dart
cd arc_raiders_dart

# Add dependencies
flutter pub add flutter_bloc equatable fpdart dio connectivity_plus shared_preferences freezed_annotation json_annotation get_it cached_network_image logger

# Add dev dependencies
flutter pub add --dev build_runner freezed json_serializable mocktail bloc_test
```

### Step 2: Core Setup

#### 2.1 Create Failure Classes

```dart
// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
  });

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

#### 2.2 Create Exception Classes

```dart
// lib/core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (${statusCode ?? "unknown"})';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}
```

#### 2.3 Network Info

```dart
// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';

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

#### 2.4 API Client

```dart
// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (log) => debugPrint(log.toString()),
        ),
      );
    }
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

#### 2.5 Local Storage

```dart
// lib/core/storage/local_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> remove(String key);
  Future<void> clear();
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences sharedPreferences;

  LocalStorageImpl(this.sharedPreferences);

  @override
  Future<String?> get(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> set(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
```

### Step 3: Domain Layer

#### 3.1 Item Entity

```dart
// lib/features/items/domain/entities/item.dart
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final ItemRarity rarity;
  final String type;
  final int value;
  final double weightKg;
  final int stackSize;
  final Map<String, int>? recyclesInto;
  final Map<String, int>? salvagesInto;
  final String? imageUrl;
  final String? updatedAt;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.type,
    required this.value,
    required this.weightKg,
    required this.stackSize,
    this.recyclesInto,
    this.salvagesInto,
    this.imageUrl,
    this.updatedAt,
  });

  /// Get localized name with fallback
  String getLocalizedName(String locale) {
    return name[locale] ?? name['en'] ?? id;
  }

  /// Get localized description with fallback
  String getLocalizedDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rarity,
        type,
        value,
        weightKg,
        stackSize,
        recyclesInto,
        salvagesInto,
        imageUrl,
        updatedAt,
      ];
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

#### 3.2 Repository Interface

```dart
// lib/features/items/domain/repositories/items_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';

abstract class ItemsRepository {
  /// Get all items with optional filtering
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  });

  /// Get a specific item by ID
  Future<Either<Failure, Item>> getItemById(String id);

  /// Search items by query
  Future<Either<Failure, List<Item>>> searchItems(String query);

  /// Refresh cache from remote
  Future<Either<Failure, Unit>> refreshCache();

  /// Check if data is cached
  Future<bool> isCached();
}
```

#### 3.3 Use Case

```dart
// lib/features/items/domain/usecases/get_all_items.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/items_repository.dart';

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

```dart
// lib/features/items/domain/usecases/get_item_by_id.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/items_repository.dart';

class GetItemById {
  final ItemsRepository repository;

  const GetItemById(this.repository);

  Future<Either<Failure, Item>> call(String id) async {
    return await repository.getItemById(id);
  }
}
```

### Step 4: Data Layer

#### 4.1 Item Model

```dart
// lib/features/items/data/models/item_model.dart
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

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4.2 Remote Data Source

```dart
// lib/features/items/data/datasources/items_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/item_model.dart';
import '../../domain/entities/item.dart';

abstract class ItemsRemoteDataSource {
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
    int page = 1,
    int pageSize = 50,
  });

  Future<ItemModel> getItemById(String id);
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient client;

  ItemsRemoteDataSourceImpl(this.client);

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

      if (rarity != null) {
        queryParams['rarity'] = rarity.displayName;
      }
      if (type != null) {
        queryParams['type'] = type;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await client.get(
        '/items',
        queryParameters: queryParams,
      );

      // Handle paginated response
      final List<ItemModel> allItems = [];
      final data = response.data['data'] as List;

      allItems.addAll(
        data.map((json) => ItemModel.fromJson(json)).toList(),
      );

      // Check if there are more pages
      final pagination = response.data['pagination'];
      if (pagination != null && pagination['hasNextPage'] == true) {
        // Fetch remaining pages recursively
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
    } catch (e) {
      throw ServerException(
        message: 'Unknown error: $e',
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

#### 4.3 Local Data Source

```dart
// lib/features/items/data/datasources/items_local_datasource.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/item_model.dart';
import '../../domain/entities/item.dart';

abstract class ItemsLocalDataSource {
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  });

  Future<ItemModel> getItemById(String id);

  Future<void> cacheItems(List<ItemModel> items);

  Future<bool> isCached();
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  final AssetBundle assetBundle;
  final LocalStorage storage;

  static const String itemsAssetPath = 'packages/arc_raiders_dart/assets/data/items/';
  static const String cacheKey = 'cached_items';
  static const String cacheTimestampKey = 'cached_items_timestamp';
  static const Duration cacheDuration = Duration(hours: 24);

  ItemsLocalDataSourceImpl({
    required this.assetBundle,
    required this.storage,
  });

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

      // Apply filters
      return _filterItems(items, rarity: rarity, type: type, search: search);
    } catch (e) {
      throw CacheException(message: 'Failed to load offline data: $e');
    }
  }

  Future<List<ItemModel>> _loadFromAssets() async {
    final items = <ItemModel>[];

    // Load a list of all item files
    // You would need to create a manifest.json with all item file names
    try {
      final manifestJson = await assetBundle.loadString(
        '${itemsAssetPath}manifest.json',
      );
      final manifest = jsonDecode(manifestJson) as List;

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
    } catch (e) {
      throw CacheException(message: 'Failed to load manifest: $e');
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
    await storage.set(
      cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
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

#### 4.4 Repository Implementation

```dart
// lib/features/items/data/repositories/items_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/items_repository.dart';
import '../datasources/items_local_datasource.dart';
import '../datasources/items_remote_datasource.dart';

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

  @override
  Future<Either<Failure, Item>> getItemById(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final model = await remoteDataSource.getItemById(id);
        return right(model.toEntity());
      } on ServerException {
        return _getItemFromLocal(id);
      }
    } else {
      return _getItemFromLocal(id);
    }
  }

  Future<Either<Failure, Item>> _getItemFromLocal(String id) async {
    try {
      final model = await localDataSource.getItemById(id);
      return right(model.toEntity());
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> searchItems(String query) async {
    return getAllItems(search: query);
  }

  @override
  Future<Either<Failure, Unit>> refreshCache() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return left(const NetworkFailure(message: 'No internet connection'));
    }

    try {
      final models = await remoteDataSource.getAllItems();
      await localDataSource.cacheItems(models);
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  Future<bool> isCached() async {
    return await localDataSource.isCached();
  }
}
```

### Step 5: Presentation Layer

#### 5.1 BLoC Events

```dart
// lib/features/items/presentation/bloc/items_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';

part 'items_event.freezed.dart';

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

#### 5.2 BLoC States

```dart
// lib/features/items/presentation/bloc/items_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';

part 'items_state.freezed.dart';

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

#### 5.3 BLoC Implementation

```dart
// lib/features/items/presentation/bloc/items_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_items.dart';
import '../../domain/usecases/get_item_by_id.dart';
import 'items_event.dart';
import 'items_state.dart';

part 'items_bloc.freezed.dart';

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
      (items) => emit(ItemsState.loaded(items: items)),
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

    final result = await getAllItems(search: event.query);

    result.fold(
      (failure) => emit(ItemsState.error(failure.message)),
      (items) => emit(ItemsState.loaded(items: items)),
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
    emit(const ItemsState.refreshing());
    add(const ItemsLoadRequested());
  }
}
```

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 6: Dependency Injection

```dart
// lib/core/di/injection.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../../features/items/data/datasources/items_local_datasource.dart';
import '../../features/items/data/datasources/items_remote_datasource.dart';
import '../../features/items/data/repositories/items_repository_impl.dart';
import '../../features/items/domain/repositories/items_repository.dart';
import '../../features/items/domain/usecases/get_all_items.dart';
import '../../features/items/domain/usecases/get_item_by_id.dart';
import '../../features/items/presentation/bloc/items_bloc.dart';

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

### Step 7: Usage Example

```dart
// example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arc_raiders_dart/core/di/injection.dart';
import 'package:arc_raiders_dart/features/items/presentation/bloc/items_bloc.dart';

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
      title: 'Arc Raiders Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => getIt<ItemsBloc>()
          ..add(const ItemsEvent.loadRequested()),
        child: const ItemsScreen(),
      ),
    );
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arc Raiders Items'),
      ),
      body: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Press refresh to load items'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (items, isOffline) => Column(
              children: [
                if (isOffline)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.orange,
                    child: const Text(
                      'Offline Mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.getLocalizedName('en')),
                        subtitle: Text(
                          '${item.rarity.displayName} • ${item.type}',
                        ),
                        trailing: Text('\$${item.value}'),
                      );
                    },
                  ),
                ),
              ],
            ),
            error: (message) => Center(
              child: Text('Error: $message'),
            ),
            detail: (item) => Center(
              child: Text('Detail: ${item.getLocalizedName('en')}'),
            ),
            refreshing: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ItemsBloc>().add(
                const ItemsEvent.cacheRefreshRequested(),
              );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## Next Steps

1. **Add More Features**: Implement quests, weapons, armor, ARCs following the same pattern
2. **Add Tests**: Write unit, integration, and widget tests
3. **Optimize Performance**: Add pagination, lazy loading
4. **Add Error Recovery**: Implement retry logic, exponential backoff
5. **Add Analytics**: Track usage, errors, performance metrics
6. **Documentation**: Generate API documentation with dartdoc
7. **Publish**: Publish to pub.dev for community use

This implementation provides a solid foundation for a production-ready Arc Raiders Dart library with both offline and online capabilities!
