import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';

/// Remote data source for fetching app configuration.
@lazySingleton
class ConfigRemoteDatasource {
  ConfigRemoteDatasource(this._dio);
  final Dio _dio;

  /// Fetches public config from primary URL with fallback.
  Future<PublicConfigModel> fetchConfig() async {
    try {
      AppLogger.info('Fetching config from: ${AppConstants.configUrl}', tag: 'ConfigDS');
      final response = await _dio.get<Map<String, dynamic>>(AppConstants.configUrl);
      final config = PublicConfigModel.fromJson(response.data!);
      AppLogger.info('Config fetched successfully. Base URI: ${config.baseUri}', tag: 'ConfigDS');
      return config;
    } on DioException catch (e) {
      AppLogger.warning('Primary config fetch failed: ${e.message}', tag: 'ConfigDS');
      // Try fallback URL
      try {
        AppLogger.info(
          'Fetching fallback config: ${AppConstants.configFallbackUrl}',
          tag: 'ConfigDS',
        );
        final response = await _dio.get<Map<String, dynamic>>(AppConstants.configFallbackUrl);
        final config = PublicConfigModel.fromJson(response.data!);
        AppLogger.info('Fallback config fetched. Base URI: ${config.baseUri}', tag: 'ConfigDS');
        return config;
      } on DioException catch (e) {
        AppLogger.error(
          'All config fetches failed',
          tag: 'ConfigDS',
          error: e,
        );
        throw NetworkException(message: e.message ?? 'Failed to fetch config');
      }
    }
  }
}
