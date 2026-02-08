import 'package:flutter_test/flutter_test.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';

void main() {
  group('HashUtils', () {
    test('computeGameId returns correct MD5 with trailing newline', () {
      // Known test vector: MD5 of "test\n"
      final result = HashUtils.computeGameId('test');
      // md5("test\n") = d8e8fca2dc0f896fd7cb4cb0031ba249
      expect(result, equals('d8e8fca2dc0f896fd7cb4cb0031ba249'));
    });

    test('computeGameId returns 32-character hex string', () {
      final result = HashUtils.computeGameId('Beat Saber v1.35.0 +2OBBs');
      expect(result.length, equals(32));
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(result), isTrue);
    });

    test('computeGameId is deterministic', () {
      const input = 'Some Game v2.0';
      final result1 = HashUtils.computeGameId(input);
      final result2 = HashUtils.computeGameId(input);
      expect(result1, equals(result2));
    });

    test('computeGameId different inputs produce different hashes', () {
      final hash1 = HashUtils.computeGameId('Game A');
      final hash2 = HashUtils.computeGameId('Game B');
      expect(hash1, isNot(equals(hash2)));
    });
  });
}
