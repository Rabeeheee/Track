// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hive_modals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      username: fields[0] as String,
      profileImagePath: fields[1] as String,
      completed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.profileImagePath)
      ..writeByte(2)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AvatarModelAdapter extends TypeAdapter<AvatarModel> {
  @override
  final int typeId = 1;

  @override
  AvatarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvatarModel(
      avatarPath: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AvatarModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.avatarPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
