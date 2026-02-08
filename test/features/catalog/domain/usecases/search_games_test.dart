import 'package:flutter_test/flutter_test.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/domain/usecases/search_games.dart';

void main() {
  late SearchGames searchGames;

  setUp(() {
    searchGames = SearchGames();
  });

  final testGames = [
    const Game(name: 'Beat Saber', releaseName: 'Beat Saber v1.35.0', packageName: 'com.beatgames.beatsaber', versionCode: '1350', lastUpdated: '2024-01-15', sizeMb: '2048'),
    const Game(name: 'Superhot VR', releaseName: 'Superhot VR v1.0', packageName: 'com.superhot.vr', versionCode: '100', lastUpdated: '2024-02-01', sizeMb: '1024'),
    const Game(name: 'Pistol Whip', releaseName: 'Pistol Whip v1.2', packageName: 'com.cloudheadgames.pistolwhip', versionCode: '120', lastUpdated: '2024-03-01', sizeMb: '512'),
  ];

  test('returns all games when query is empty', () {
    final result = searchGames(testGames, '');
    expect(result.length, 3);
  });

  test('searches by game name (case-insensitive)', () {
    final result = searchGames(testGames, 'beat');
    expect(result.length, 1);
    expect(result.first.name, 'Beat Saber');
  });

  test('searches by package name', () {
    final result = searchGames(testGames, 'cloudhead');
    expect(result.length, 1);
    expect(result.first.name, 'Pistol Whip');
  });

  test('searches by release name', () {
    final result = searchGames(testGames, 'v1.35');
    expect(result.length, 1);
    expect(result.first.name, 'Beat Saber');
  });

  test('returns empty for no matches', () {
    final result = searchGames(testGames, 'nonexistent');
    expect(result, isEmpty);
  });

  test('partial match works', () {
    final result = searchGames(testGames, 'super');
    expect(result.length, 1);
    expect(result.first.name, 'Superhot VR');
  });
}
