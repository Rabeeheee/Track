// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyProgressAdapter extends TypeAdapter<WeeklyProgress> {
  @override
  final int typeId = 2;

  @override
  WeeklyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyProgress(
      fields[2] as int,
      day: fields[0] as String,
      points: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.weeklyPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
