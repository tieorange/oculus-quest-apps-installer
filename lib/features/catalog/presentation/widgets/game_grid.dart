import 'package:flutter/material.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_card.dart';

/// Displays games as a scrollable list with optional batch selection.
class GameGrid extends StatelessWidget {
  const GameGrid({
    required this.games,
    this.isGridView = false,
    this.selectionMode = false,
    this.selectedPackages = const {},
    this.onSelectionToggle,
    super.key,
  });

  final List<Game> games;
  final bool isGridView;
  final bool selectionMode;
  final Set<String> selectedPackages;
  final void Function(Game)? onSelectionToggle;

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) => _buildItem(games[index]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildItem(games[index]),
        );
      },
    );
  }

  Widget _buildItem(Game game) {
    if (selectionMode) {
      final isSelected = selectedPackages.contains(game.packageName);
      return Stack(
        children: [
          GestureDetector(
            onTap: () => onSelectionToggle?.call(game),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: const Color(0xFF00D9FF), width: 2)
                    : null,
              ),
              child: IgnorePointer(child: GameCard(game: game)),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00D9FF) : Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      );
    }

    return GameCard(game: game);
  }
}
