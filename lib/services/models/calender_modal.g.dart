// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calender_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 3;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      likeToDo: fields[0] as String,
      Descrition: fields[1] as String,
      date: fields[3] as DateTime,
      priority: fields[2] as String,
      isCompleted: fields[4] as bool,
      isSelected: fields[6] as bool,
      id: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.likeToDo)
      ..writeByte(1)
      ..write(obj.Descrition)
      ..writeByte(2)
      ..write(obj.priority)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
