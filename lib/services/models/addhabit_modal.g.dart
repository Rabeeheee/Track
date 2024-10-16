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
      goalDays: fields[3] as dynamic,
      frequency: fields[4] as dynamic,
      name: fields[0] as String?,
      isCompleted: fields[6] as bool,
      id: fields[7] as String?,
      partOfDay: fields[5] as String?,
      quote: fields[1] as String?,
      selectedAvatarPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddhabitModal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quote)
      ..writeByte(2)
      ..write(obj.selectedAvatarPath)
      ..writeByte(3)
      ..write(obj.goalDays)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.partOfDay)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
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
