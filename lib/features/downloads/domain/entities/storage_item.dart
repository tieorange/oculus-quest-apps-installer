import 'package:equatable/equatable.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

/// Type of storage item (installer cache or installed OBB data).
enum StorageItemType { installer, obb }

/// Represents a storage item that can be deleted.
class StorageItem extends Equatable {
  const StorageItem({
    required this.id,
    required this.label,
    required this.sizeBytes,
    required this.path,
    required this.type,
    this.game,
  });

  /// Unique identifier based on path.
  final String id;

  /// Display label (game name or folder name).
  final String label;

  /// Size in bytes.
  final int sizeBytes;

  /// Absolute path to delete.
  final String path;

  /// Type of storage item.
  final StorageItemType type;

  /// Linked game entity (for UI display like thumbnails).
  final Game? game;

  @override
  List<Object?> get props => [id, path, type];
}
