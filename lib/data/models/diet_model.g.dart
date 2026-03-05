// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietProfileModelAdapter extends TypeAdapter<DietProfileModel> {
  @override
  final int typeId = 11;

  @override
  DietProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietProfileModel(
      weightKg: fields[0] as double,
      heightCm: fields[1] as double,
      age: fields[2] as int,
      gender: fields[3] as String,
      activityLevel: fields[4] as String,
      goal: fields[5] as String,
      dailyCalorieTarget: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DietProfileModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weightKg)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.activityLevel)
      ..writeByte(5)
      ..write(obj.goal)
      ..writeByte(6)
      ..write(obj.dailyCalorieTarget);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealEntryModelAdapter extends TypeAdapter<MealEntryModel> {
  @override
  final int typeId = 12;

  @override
  MealEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealEntryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: fields[2] as int,
      protein: fields[3] as double,
      carbs: fields[4] as double,
      fat: fields[5] as double,
      date: fields[6] as DateTime,
      mealType: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealEntryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.mealType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
