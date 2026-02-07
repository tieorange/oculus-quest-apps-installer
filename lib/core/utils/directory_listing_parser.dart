/// Utility functions for parsing server responses.
class DirectoryListingParser {
  DirectoryListingParser._();

  /// Parses HTML directory listing from server.
  static List<(String filename, int sizeBytes)> parse(String html) {
    final regex = RegExp(r'^(?:\.\.\/)?([0-9a-f]+\.7z\.\d+)\s+.*\s+(\d+)$', multiLine: true);
    return regex.allMatches(html).map((match) {
      return (match.group(1)!, int.parse(match.group(2)!));
    }).toList();
  }
}
