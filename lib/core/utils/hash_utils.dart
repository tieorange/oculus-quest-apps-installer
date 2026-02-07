import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility functions for hash computation.
class HashUtils {
  HashUtils._();

  /// Computes the game directory ID used in download URLs.
  /// CRITICAL: Includes trailing newline as required by protocol.
  static String computeGameId(String releaseName) {
    final bytes = utf8.encode('$releaseName\n');
    return md5.convert(bytes).toString();
  }
}
