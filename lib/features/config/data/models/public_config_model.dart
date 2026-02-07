import 'dart:convert';

import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Data model for public config JSON response.
class PublicConfigModel {
  const PublicConfigModel({required this.baseUri, required this.password});

  factory PublicConfigModel.fromJson(Map<String, dynamic> json) {
    return PublicConfigModel(
      baseUri: json['baseUri'] as String,
      password: json['password'] as String,
    );
  }

  final String baseUri;
  final String password; // base64-encoded

  /// Converts to domain entity with decoded password.
  PublicConfig toEntity() =>
      PublicConfig(baseUri: baseUri, password: utf8.decode(base64Decode(password)));

  /// Converts to JSON map.
  Map<String, dynamic> toJson() => {
        'baseUri': baseUri,
        'password': password,
      };
}
