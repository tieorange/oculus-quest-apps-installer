import 'package:hive/hive.dart';

part 'cache_meta_model.g.dart';

/// Hive model for tracking cache metadata (timestamp, game count).
@HiveType(typeId: 1)
class CacheMetaModel extends HiveObject {
  CacheMetaModel({
    required this.lastUpdated,
    required this.gameCount,
  });

  @HiveField(0)
  final DateTime lastUpdated;

  @HiveField(1)
  final int gameCount;
}
