/// Application-wide constants for Quest Game Manager.
class AppConstants {
  AppConstants._();

  static const String configUrl =
      'https://raw.githubusercontent.com/vrpyou/quest/main/vrp-public.json';
  static const String configFallbackUrl = 'https://vrpirates.wiki/downloads/vrp-public.json';
  static const String userAgent = 'rclone/v1.65.2';
  static const String metaArchiveName = 'meta.7z';
  static const String gameListFileName = 'VRP-GameList.txt';
  static const String thumbnailsPath = '.meta/thumbnails';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(minutes: 30);
  static const String obbBasePath = '/sdcard/Android/obb';
  static const double minSpaceMultiplier = 2.5;
}
