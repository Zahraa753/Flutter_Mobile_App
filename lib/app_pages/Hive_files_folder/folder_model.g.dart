// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderModelAdapter extends TypeAdapter<FolderModel> {
  @override
  final int typeId = 1;

  @override
  FolderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderModel(
      label: fields[0] as String,
      color: fields[1] as int,
      createAt: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FolderModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
