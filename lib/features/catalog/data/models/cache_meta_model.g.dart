// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_meta_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheMetaModelAdapter extends TypeAdapter<CacheMetaModel> {
  @override
  final int typeId = 1;

  @override
  CacheMetaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheMetaModel(
      lastUpdated: fields[0] as DateTime,
      gameCount: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CacheMetaModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lastUpdated)
      ..writeByte(1)
      ..write(obj.gameCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheMetaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
