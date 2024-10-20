// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addhabit_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddhabitModalAdapter extends TypeAdapter<AddhabitModal> {
  @override
  final int typeId = 1;

  @override
  AddhabitModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddhabitModal(
      goalDays: fields[4] as String?,
      frequency: fields[5] as String?,
      name: fields[0] as String?,
      isCompleted: fields[7] as bool,
      id: fields[8] as int?,
      partOfDay: fields[6] as String?,
      quote: fields[1] as String?,
      description: fields[2] as String?,
      selectedAvatarPath: fields[3] as String?, 
    );
  }

  @override
  void write(BinaryWriter writer, AddhabitModal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quote)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.selectedAvatarPath)
      ..writeByte(4)
      ..write(obj.goalDays)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.partOfDay)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddhabitModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
