/// Application-wide constants for Quest Game Manager.
class AppConstants {
  AppConstants._();

  static const String configUrl =
      'https://raw.githubusercontent.com/vrpyou/quest/main/vrp-public.json';
  static const String configFallbackUrl = 'https://vrpirates.wiki/downloads/vrp-public.json';
  static const String userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  static const String metaArchiveName = 'meta.7z';
  static const String gameListFileName = 'VRP-GameList.txt';
  static const String thumbnailsPath = '.meta/thumbnails';
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
}
