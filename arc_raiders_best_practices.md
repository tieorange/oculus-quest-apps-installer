# Arc Raiders Library - Best Practices & Comparison

## Online vs Offline Mode Comparison

### Online Mode (MetaForge API)

#### Advantages
✅ **Real-time Data**: Always up-to-date with latest game changes
✅ **Complete Dataset**: Access to all items without bundling assets
✅ **Smaller App Size**: No need to include JSON files in package
✅ **Dynamic Updates**: Server-side updates without app updates
✅ **Reduced Maintenance**: Data changes handled server-side

#### Disadvantages
❌ **Network Dependency**: Requires active internet connection
❌ **API Rate Limits**: Potential throttling or quota limits
❌ **Latency**: Network requests introduce delay
❌ **Server Downtime**: Vulnerable to API outages
❌ **Data Costs**: Uses mobile data for users

#### Best Use Cases
- Live game companion apps
- Real-time item tracking
- Dynamic pricing/trading features
- Community-driven content
- Apps requiring latest updates

---

### Offline Mode (Bundled JSON)

#### Advantages
✅ **No Network Required**: Works without internet
✅ **Instant Access**: No loading delays
✅ **No API Costs**: No rate limiting or quotas
✅ **Reliability**: No server downtime issues
✅ **Privacy**: No external data requests

#### Disadvantages
❌ **Stale Data**: Data may be outdated
❌ **Larger App Size**: Assets bundled with app
❌ **Manual Updates**: Requires app update for data changes
❌ **Storage Space**: Consumes device storage
❌ **Maintenance Burden**: Must sync with game updates

#### Best Use Cases
- Reference apps
- Educational tools
- Offline wikis
- Data analysis tools
- Areas with poor connectivity

---

## Hybrid Approach (Recommended)

The library implements a **hybrid offline-first strategy** that combines the best of both:

### Strategy

```
1. Check Network Connectivity
   ↓
2. If Online → Fetch from API → Cache Locally → Display
   ↓
3. If Offline → Load from Cache → Display
   ↓
4. If No Cache → Load from Bundled Assets → Display
```

### Benefits

1. **Best User Experience**: Fast initial load from cache, updated data when online
2. **Reliability**: Always works, regardless of connectivity
3. **Freshness**: Data stays current when connection available
4. **Performance**: Instant response from cache
5. **Flexibility**: User can force refresh or use offline

---

## Implementation Best Practices

### 1. Cache Strategy

#### Time-Based Expiration

```dart
class CacheConfig {
  // Cache duration based on data volatility
  static const Duration itemsCacheDuration = Duration(hours: 24);
  static const Duration questsCacheDuration = Duration(hours: 12);
  static const Duration pricesCacheDuration = Duration(minutes: 30);

  // Cache size limits
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Background sync interval
  static const Duration backgroundSyncInterval = Duration(hours: 6);
}
```

#### Implement LRU Cache

```dart
class LRUCache<K, V> {
  final int maxSize;
  final LinkedHashMap<K, V> _cache = LinkedHashMap();

  LRUCache({required this.maxSize});

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    // Move to end (most recently used)
    final value = _cache.remove(key)!;
    _cache[key] = value;
    return value;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used (first item)
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = value;
  }

  void clear() => _cache.clear();
}
```

### 2. Network Retry Logic

```dart
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
  });

  Future<T> retry<T>(Future<T> Function() operation) async {
    var delay = initialDelay;

    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (attempt == maxRetries - 1) rethrow;

        await Future.delayed(delay);
        delay *= backoffMultiplier.toInt();
      }
    }

    throw Exception('Max retries exceeded');
  }
}

// Usage
final retry = RetryConfig();
final data = await retry.retry(() => api.fetchItems());
```

### 3. Background Sync

```dart
class BackgroundSync {
  final ItemsRepository repository;
  Timer? _syncTimer;

  BackgroundSync(this.repository);

  void startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      CacheConfig.backgroundSyncInterval,
      (_) async {
        await _performSync();
      },
    );
  }

  Future<void> _performSync() async {
    final result = await repository.refreshCache();
    result.fold(
      (failure) => print('Background sync failed: ${failure.message}'),
      (_) => print('Background sync completed'),
    );
  }

  void stop() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}
```

### 4. Error Handling Patterns

#### User-Friendly Error Messages

```dart
extension FailureMessage on Failure {
  String getUserMessage() {
    return when(
      server: (message, statusCode) {
        if (statusCode == 404) return 'Item not found';
        if (statusCode == 429) return 'Too many requests. Please wait.';
        if (statusCode == 503) return 'Service temporarily unavailable';
        return 'Server error occurred';
      },
      cache: (message) => 'Unable to load offline data',
      network: (message) => 'No internet connection',
      validation: (message) => message,
    );
  }
}

// Usage in UI
BlocBuilder<ItemsBloc, ItemsState>(
  builder: (context, state) {
    return state.maybeWhen(
      error: (message) {
        final failure = _parseFailure(message);
        return ErrorWidget(message: failure.getUserMessage());
      },
      orElse: () => Container(),
    );
  },
)
```

#### Graceful Degradation

```dart
class DataSourceSelector {
  final NetworkInfo networkInfo;
  final ItemsRemoteDataSource remote;
  final ItemsLocalDataSource local;

  Future<List<Item>> getItems() async {
    // Try online first
    if (await networkInfo.isConnected) {
      try {
        final items = await remote.getAllItems();
        await local.cacheItems(items); // Update cache
        return items;
      } catch (e) {
        // Fallback to offline
        print('Remote failed, using offline: $e');
      }
    }

    // Use offline as fallback
    try {
      return await local.getAllItems();
    } catch (e) {
      // Last resort: return empty or throw
      throw Exception('All data sources failed');
    }
  }
}
```

### 5. Performance Optimizations

#### Pagination

```dart
class PaginatedItemsRepository implements ItemsRepository {
  static const int pageSize = 50;
  final Map<int, List<Item>> _pageCache = {};

  Future<Either<Failure, List<Item>>> getItemsPage(int page) async {
    // Check in-memory cache
    if (_pageCache.containsKey(page)) {
      return right(_pageCache[page]!);
    }

    // Fetch page
    final result = await remoteDataSource.getAllItems(
      page: page,
      pageSize: pageSize,
    );

    return result.map((models) {
      final items = models.map((m) => m.toEntity()).toList();
      _pageCache[page] = items;
      return items;
    });
  }

  void clearCache() => _pageCache.clear();
}
```

#### Debounced Search

```dart
class DebouncedSearch {
  Timer? _debounceTimer;
  final Duration delay;

  DebouncedSearch({this.delay = const Duration(milliseconds: 500)});

  void call(String query, Function(String) onSearch) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () => onSearch(query));
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

// Usage in BLoC
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final _debouncer = DebouncedSearch();

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  void _onSearchRequested(ItemsSearchRequested event, Emitter emit) {
    _debouncer(event.query, (query) async {
      emit(const ItemsState.loading());
      final result = await searchItems(query);
      result.fold(
        (failure) => emit(ItemsState.error(failure.message)),
        (items) => emit(ItemsState.loaded(items: items)),
      );
    });
  }
}
```

#### Image Caching

```dart
// Use cached_network_image package
Widget buildItemImage(String? imageUrl) {
  if (imageUrl == null) {
    return const Icon(Icons.image_not_supported);
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    cacheManager: CacheManager(
      Config(
        'arcRaidersImages',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 200,
      ),
    ),
  );
}
```

### 6. Monitoring & Analytics

```dart
class AnalyticsService {
  void logEvent(String name, Map<String, dynamic> parameters) {
    // Implementation with Firebase Analytics, Mixpanel, etc.
  }

  void logDataSource(DataSourceType type) {
    logEvent('data_source_used', {'type': type.name});
  }

  void logCacheHit(bool hit) {
    logEvent('cache_access', {'hit': hit});
  }

  void logError(String error, StackTrace stackTrace) {
    logEvent('error', {
      'error': error,
      'stackTrace': stackTrace.toString(),
    });
  }
}

enum DataSourceType { remote, cache, assets }

// Usage in Repository
@override
Future<Either<Failure, List<Item>>> getAllItems() async {
  final isConnected = await networkInfo.isConnected;

  if (isConnected) {
    try {
      final items = await remoteDataSource.getAllItems();
      analytics.logDataSource(DataSourceType.remote);
      analytics.logCacheHit(false);
      return right(items);
    } catch (e) {
      analytics.logError('Remote fetch failed', StackTrace.current);
      // Fallback...
    }
  }

  // Use cache
  final cached = await localDataSource.getAllItems();
  analytics.logDataSource(DataSourceType.cache);
  analytics.logCacheHit(true);
  return right(cached);
}
```

### 7. Testing Strategies

#### Unit Test Example

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
    final tItems = [
      Item(
        id: '1',
        name: {'en': 'Test Item'},
        description: {'en': 'Test Description'},
        rarity: ItemRarity.common,
        type: 'material',
        value: 100,
        weightKg: 1.0,
        stackSize: 10,
      ),
    ];

    test('should return items from repository', () async {
      // arrange
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => right(tItems));

      // act
      final result = await useCase();

      // assert
      expect(result, right(tItems));
      verify(() => mockRepository.getAllItems()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => left(tFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, left(tFailure));
      verify(() => mockRepository.getAllItems()).called(1);
    });
  });
}
```

#### Integration Test Example

```dart
// integration_test/items_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Items Feature Integration', () {
    testWidgets('should load items and display them', (tester) async {
      await setupDependencyInjection();

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify loading state appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for items to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify items are displayed
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('should handle offline mode', (tester) async {
      // Simulate offline mode
      final mockNetworkInfo = MockNetworkInfo();
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);

      await setupDependencyInjection();
      getIt.unregister<NetworkInfo>();
      getIt.registerSingleton<NetworkInfo>(mockNetworkInfo);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify offline banner appears
      expect(find.text('Offline Mode'), findsOneWidget);

      // Verify items still load from cache
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
```

### 8. Documentation Best Practices

#### Inline Documentation

```dart
/// Repository for accessing Arc Raiders item data.
///
/// This repository implements an offline-first strategy:
/// 1. Attempts to fetch from remote API when online
/// 2. Falls back to local cache on failure
/// 3. Uses bundled assets as last resort
///
/// Example:
/// ```dart
/// final repository = getIt<ItemsRepository>();
/// final result = await repository.getAllItems(rarity: ItemRarity.legendary);
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (items) => print('Found ${items.length} items'),
/// );
/// ```
abstract class ItemsRepository {
  /// Retrieves all items with optional filtering.
  ///
  /// Parameters:
  /// - [rarity]: Filter by item rarity (optional)
  /// - [type]: Filter by item type (optional)
  /// - [search]: Search query for name/description (optional)
  ///
  /// Returns:
  /// - [Right<List<Item>>] on success
  /// - [Left<Failure>] on error
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    String? type,
    String? search,
  });
}
```

#### README Example

```markdown
# Arc Raiders Dart Library

A comprehensive Dart/Flutter library for accessing Arc Raiders game data with both online and offline support.

## Features

- 🌐 **Online Mode**: Real-time data from MetaForge API
- 📱 **Offline Mode**: Works without internet connection
- 💾 **Smart Caching**: Automatic cache management
- 🏗️ **Clean Architecture**: Maintainable and testable
- 🔄 **Auto-Sync**: Background data synchronization
- 🌍 **Multi-Language**: Built-in i18n support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  arc_raiders_dart: ^1.0.0
```

## Quick Start

```dart
import 'package:arc_raiders_dart/arc_raiders_dart.dart';

void main() async {
  // Initialize
  await setupDependencyInjection();

  // Get items
  final bloc = getIt<ItemsBloc>();
  bloc.add(const ItemsEvent.loadRequested());
}
```

## Usage Examples

See the [example](example/) directory for complete examples.
```

---

## Production Checklist

Before deploying to production:

- [ ] **Error Handling**: All error cases handled gracefully
- [ ] **Loading States**: Show appropriate loading indicators
- [ ] **Offline Support**: Test thoroughly in offline mode
- [ ] **Cache Management**: Implement cache expiration and cleanup
- [ ] **Network Retry**: Add retry logic for failed requests
- [ ] **Rate Limiting**: Respect API rate limits
- [ ] **Performance**: Profile and optimize critical paths
- [ ] **Testing**: Achieve >80% code coverage
- [ ] **Documentation**: Document public APIs
- [ ] **Logging**: Add appropriate logging for debugging
- [ ] **Analytics**: Track usage and errors
- [ ] **Security**: Validate and sanitize all inputs
- [ ] **Accessibility**: Ensure UI is accessible
- [ ] **Internationalization**: Support multiple languages
- [ ] **Version Management**: Handle API version changes

---

## Common Pitfalls to Avoid

### 1. Not Handling Offline Gracefully

❌ **Bad**:
```dart
final items = await api.fetchItems(); // Crashes offline
return items;
```

✅ **Good**:
```dart
if (await networkInfo.isConnected) {
  try {
    return await api.fetchItems();
  } catch (e) {
    return await cache.getItems();
  }
} else {
  return await cache.getItems();
}
```

### 2. Blocking UI with Synchronous Operations

❌ **Bad**:
```dart
final items = jsonDecode(largeJsonString); // Blocks UI
setState(() => this.items = items);
```

✅ **Good**:
```dart
final items = await compute(parseItems, largeJsonString);
setState(() => this.items = items);
```

### 3. Not Cleaning Up Resources

❌ **Bad**:
```dart
class MyBloc extends Bloc {
  final Timer timer = Timer.periodic(...);
  // No cleanup!
}
```

✅ **Good**:
```dart
class MyBloc extends Bloc {
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
```

### 4. Over-Fetching Data

❌ **Bad**:
```dart
// Fetch all 10,000 items on every search
final allItems = await repository.getAllItems();
final filtered = allItems.where((i) => i.name.contains(query));
```

✅ **Good**:
```dart
// Let backend handle filtering
final items = await repository.searchItems(query);
```

### 5. Not Using Type-Safe Error Handling

❌ **Bad**:
```dart
try {
  final items = await repository.getItems();
  return items;
} catch (e) {
  return []; // Silent failure!
}
```

✅ **Good**:
```dart
final result = await repository.getItems();
return result.fold(
  (failure) {
    logger.error('Failed to fetch items: ${failure.message}');
    return [];
  },
  (items) => items,
);
```

---

## Summary

This Arc Raiders library demonstrates best practices for building a production-ready Flutter package with:

1. **Offline-First Architecture**: Works seamlessly with or without internet
2. **Clean Architecture**: Maintainable, testable, scalable code
3. **Type-Safe Error Handling**: Using fpdart for functional error handling
4. **Smart Caching**: Automatic cache management with expiration
5. **Performance**: Optimized for speed and efficiency
6. **User Experience**: Graceful error handling and loading states
7. **Production Ready**: Comprehensive testing, logging, analytics

Follow these patterns and best practices to create robust, user-friendly applications!
