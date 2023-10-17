// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyHabitAdapter extends TypeAdapter<DailyHabit> {
  @override
  final int typeId = 10;

  @override
  DailyHabit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyHabit(
      habiName: fields[0] as String,
      isCompleted: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyHabit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.habiName)
      ..writeByte(1)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyHabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
