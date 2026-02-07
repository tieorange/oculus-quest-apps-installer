import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';

/// Remote data source for fetching app configuration.
@lazySingleton
class ConfigRemoteDatasource {
  ConfigRemoteDatasource(this._dio);
  final Dio _dio;

  /// Fetches public config from primary URL with fallback.
  Future<PublicConfigModel> fetchConfig() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(AppConstants.configUrl);
      return PublicConfigModel.fromJson(response.data!);
    } on DioException {
      // Try fallback URL
      try {
        final response = await _dio.get<Map<String, dynamic>>(AppConstants.configFallbackUrl);
        return PublicConfigModel.fromJson(response.data!);
      } on DioException catch (e) {
        throw NetworkException(message: e.message ?? 'Failed to fetch config');
      }
    }
  }
}
