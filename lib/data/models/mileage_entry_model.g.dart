// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mileage_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MileageEntryModelAdapter extends TypeAdapter<MileageEntryModel> {
  @override
  final int typeId = 5;

  @override
  MileageEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MileageEntryModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      odometerReading: fields[2] as double,
      petrolLitres: fields[3] as double,
      pricePerLitre: fields[4] as double,
      totalCost: fields[5] as double,
      distanceTravelled: fields[6] as double?,
      mileage: fields[7] as double?,
      paymentMethodId: fields[8] as String,
      notes: fields[9] as String,
      linkedExpenseId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MileageEntryModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.odometerReading)
      ..writeByte(3)
      ..write(obj.petrolLitres)
      ..writeByte(4)
      ..write(obj.pricePerLitre)
      ..writeByte(5)
      ..write(obj.totalCost)
      ..writeByte(6)
      ..write(obj.distanceTravelled)
      ..writeByte(7)
      ..write(obj.mileage)
      ..writeByte(8)
      ..write(obj.paymentMethodId)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.linkedExpenseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MileageEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
