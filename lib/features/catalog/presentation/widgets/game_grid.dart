import 'package:flutter/material.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_card.dart';

/// List view displaying game cards.
class GameGrid extends StatelessWidget {
  const GameGrid({required this.games, super.key});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GameCard(game: games[index]),
        );
      },
    );
  }
}
