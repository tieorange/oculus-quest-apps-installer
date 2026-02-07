import 'package:flutter/material.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_card.dart';

/// Grid view displaying game cards.
class GameGrid extends StatelessWidget {
  const GameGrid({required this.games, super.key});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return GameCard(game: games[index]);
      },
    );
  }
}
