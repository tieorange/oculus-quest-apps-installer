import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

/// Use case for searching games locally.
@injectable
class SearchGames {
  List<Game> call(List<Game> games, String query) {
    if (query.isEmpty) return games;
    final lowerQuery = query.toLowerCase();
    return games
        .where(
          (game) =>
              game.name.toLowerCase().contains(lowerQuery) ||
              game.packageName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
