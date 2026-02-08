import 'package:flutter_test/flutter_test.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';

void main() {
  group('FileUtils.formatBytes', () {
    test('formats bytes', () {
      expect(FileUtils.formatBytes(512), '512 B');
    });

    test('formats kilobytes', () {
      expect(FileUtils.formatBytes(1536), '1.5 KB');
    });

    test('formats megabytes', () {
      expect(FileUtils.formatBytes(1048576), '1.0 MB');
      expect(FileUtils.formatBytes(1572864), '1.5 MB');
    });

    test('formats gigabytes', () {
      expect(FileUtils.formatBytes(1073741824), '1.00 GB');
      expect(FileUtils.formatBytes(2684354560), '2.50 GB');
    });
  });

  group('FileUtils.formatSpeed', () {
    test('formats bytes per second', () {
      expect(FileUtils.formatSpeed(500), '500 B/s');
    });

    test('formats KB/s', () {
      expect(FileUtils.formatSpeed(1536), '1.5 KB/s');
    });

    test('formats MB/s', () {
      expect(FileUtils.formatSpeed(5242880), '5.0 MB/s');
    });
  });

  group('FileUtils.formatEta', () {
    test('formats seconds', () {
      expect(FileUtils.formatEta(5000, 1000), '5s');
    });

    test('formats minutes and seconds', () {
      expect(FileUtils.formatEta(120000, 1000), '2m 0s');
    });

    test('formats hours and minutes', () {
      expect(FileUtils.formatEta(7200000, 1000), '2h 0m');
    });

    test('returns --:-- when speed is zero', () {
      expect(FileUtils.formatEta(1000, 0), '--:--');
    });
  });

  group('FileUtils.formatMb', () {
    test('formats megabytes', () {
      expect(FileUtils.formatMb(500), '500 MB');
    });

    test('formats gigabytes', () {
      expect(FileUtils.formatMb(2048), '2.0 GB');
    });
  });
}
