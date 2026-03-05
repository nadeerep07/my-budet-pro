import 'package:equatable/equatable.dart';

class DietProfileEntity extends Equatable {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;
  final String activityLevel;
  final String goal;
  final int dailyCalorieTarget; // Will be calculated

  const DietProfileEntity({
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.dailyCalorieTarget,
  });

  @override
  List<Object?> get props => [
    weightKg,
    heightCm,
    age,
    gender,
    activityLevel,
    goal,
    dailyCalorieTarget,
  ];
}

class MealEntryEntity extends Equatable {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime date;
  final String mealType; // Breakfast, Lunch, Dinner, Snack

  const MealEntryEntity({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
    required this.mealType,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    calories,
    protein,
    carbs,
    fat,
    date,
    mealType,
  ];
}
