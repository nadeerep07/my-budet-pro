// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsModelAdapter extends TypeAdapter<SavingsModel> {
  @override
  final int typeId = 3;

  @override
  SavingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsModel(
      id: fields[0] as String,
      totalAdded: fields[1] as double,
      totalDebited: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalAdded)
      ..writeByte(2)
      ..write(obj.totalDebited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
