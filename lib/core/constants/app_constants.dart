/// Application-wide constants for Quest Game Manager.
class AppConstants {
  AppConstants._();

  static const String configUrl =
      'https://raw.githubusercontent.com/vrpyou/quest/main/vrp-public.json';
  static const String configFallbackUrl =
      'https://vrpirates.wiki/downloads/vrp-public.json';
  static const String userAgent = 'rclone/v1.65.2';
  static const String metaArchiveName = 'meta.7z';
  static const String gameListFileName = 'VRP-GameList.txt';
  static const String thumbnailsPath = '.meta/thumbnails';
  static const String notesPath = '.meta/notes';
  static const String defaultConfigJson = '''
{
  "baseUri": "https://there-is-a.vrpmonkey.help/",
  "password": "Z0w1OVZmZ1B4b0hS"
}
''';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(minutes: 30);
  static const String obbBasePath = '/sdcard/Android/obb';
  static const double minSpaceMultiplier = 2.5;
  static const int maxDownloadRetries = 3;
  static const String appVersion = '1.1.0';
  static const String appBuild = '2';

  // Platform channel names
  static const String archiveChannel =
      'com.questgamemanager.quest_game_manager/archive';
  static const String installerChannel =
      'com.questgamemanager.quest_game_manager/installer';

  // Hive box names
  static const String gamesBoxName = 'games_cache';
  static const String downloadQueueBoxName = 'download_queue';
  static const String favoritesBoxName = 'favorites';
  static const String settingsBoxName = 'settings';
  static const String downloadStatsBoxName = 'download_stats';
}
