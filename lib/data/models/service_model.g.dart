// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceModelAdapter extends TypeAdapter<ServiceModel> {
  @override
  final int typeId = 10;

  @override
  ServiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceModel(
      id: fields[0] as String,
      title: fields[1] as String,
      date: fields[2] as DateTime,
      mileageAtService: fields[3] as int,
      cost: fields[4] as double,
      notes: fields[5] as String,
      nextServiceDate: fields[6] as DateTime?,
      nextServiceMileage: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.mileageAtService)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.nextServiceDate)
      ..writeByte(7)
      ..write(obj.nextServiceMileage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
