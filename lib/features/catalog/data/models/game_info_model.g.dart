// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameInfoModelAdapter extends TypeAdapter<GameInfoModel> {
  @override
  final int typeId = 0;

  @override
  GameInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameInfoModel(
      name: fields[0] as String,
      releaseName: fields[1] as String,
      packageName: fields[2] as String,
      versionCode: fields[3] as String,
      lastUpdated: fields[4] as String,
      sizeMb: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.releaseName)
      ..writeByte(2)
      ..write(obj.packageName)
      ..writeByte(3)
      ..write(obj.versionCode)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.sizeMb);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
