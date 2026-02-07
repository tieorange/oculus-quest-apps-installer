import 'package:equatable/equatable.dart';

/// Game entity representing a single game in the catalog.
class Game extends Equatable {
  const Game({
    required this.name,
    required this.releaseName,
    required this.packageName,
    required this.versionCode,
    required this.lastUpdated,
    required this.sizeMb,
  });

  final String name;
  final String releaseName;
  final String packageName;
  final String versionCode;
  final String lastUpdated;
  final String sizeMb;

  int get sizeInMb => int.tryParse(sizeMb) ?? 0;

  @override
  List<Object?> get props => [releaseName, packageName, versionCode];
}
