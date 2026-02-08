import 'package:flutter_test/flutter_test.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';

void main() {
  group('GameInfoModel.fromCsvLine', () {
    test('parses valid CSV line correctly', () {
      const line = 'Beat Saber;Beat Saber v1.35.0 +2OBBs;com.beatgames.beatsaber;1350;2024-01-15;2048';
      final model = GameInfoModel.fromCsvLine(line);

      expect(model.name, 'Beat Saber');
      expect(model.releaseName, 'Beat Saber v1.35.0 +2OBBs');
      expect(model.packageName, 'com.beatgames.beatsaber');
      expect(model.versionCode, '1350');
      expect(model.lastUpdated, '2024-01-15');
      expect(model.sizeMb, '2048');
    });

    test('trims whitespace from fields', () {
      const line = ' Beat Saber ; Beat Saber v1.35.0 ; com.beatgames.beatsaber ; 1350 ; 2024-01-15 ; 2048 ';
      final model = GameInfoModel.fromCsvLine(line);

      expect(model.name, 'Beat Saber');
      expect(model.packageName, 'com.beatgames.beatsaber');
    });

    test('throws FormatException for too few fields', () {
      const line = 'Beat Saber;only;three;fields;here';
      expect(() => GameInfoModel.fromCsvLine(line), throwsFormatException);
    });

    test('handles lines with more than 6 fields', () {
      const line = 'Name;Release;Pkg;100;2024-01-01;512;extra;fields';
      final model = GameInfoModel.fromCsvLine(line);
      expect(model.name, 'Name');
      expect(model.sizeMb, '512');
    });

    test('toEntity creates correct Game entity', () {
      const line = 'Test Game;Test Game v1.0;com.test.game;100;2024-06-01;256';
      final model = GameInfoModel.fromCsvLine(line);
      final entity = model.toEntity();

      expect(entity.name, 'Test Game');
      expect(entity.releaseName, 'Test Game v1.0');
      expect(entity.packageName, 'com.test.game');
      expect(entity.sizeInMb, 256);
    });
  });
}
