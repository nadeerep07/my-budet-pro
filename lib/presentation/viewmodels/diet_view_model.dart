import 'package:flutter/foundation.dart';
import '../../domain/entities/diet_entity.dart';
import '../../domain/repositories/diet_repository.dart';

class DietViewModel extends ChangeNotifier {
  final DietRepository _repository;

  DietProfileEntity? _profile;
  List<MealEntryEntity> _todayMeals = [];
  bool _isLoading = false;

  DietViewModel(this._repository);

  DietProfileEntity? get profile => _profile;
  List<MealEntryEntity> get todayMeals => _todayMeals;
  bool get isLoading => _isLoading;

  int get totalConsumedCalories {
    return _todayMeals.fold(0, (sum, meal) => sum + meal.calories);
  }

  int get remainingCalories {
    if (_profile == null) return 0;
    return _profile!.dailyCalorieTarget - totalConsumedCalories;
  }

  Future<void> loadDietData() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _repository.getDietProfile();
    _todayMeals = await _repository.getMealEntries(DateTime.now());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    // Mifflin-St Jeor formula
    double bmr;
    if (gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double activityMultiplier;
    switch (activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.2;
        break;
      case 'Lightly Active':
        activityMultiplier = 1.375;
        break;
      case 'Moderately Active':
        activityMultiplier = 1.55;
        break;
      case 'Very Active':
        activityMultiplier = 1.725;
        break;
      case 'Extra Active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }

    double tdee = bmr * activityMultiplier;
    int targetCalories;

    switch (goal) {
      case 'Lose Weight':
        targetCalories = (tdee - 500).round();
        break;
      case 'Gain Weight':
        targetCalories = (tdee + 500).round();
        break;
      case 'Maintain':
      default:
        targetCalories = tdee.round();
    }

    final newProfile = DietProfileEntity(
      weightKg: weight,
      heightCm: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
      dailyCalorieTarget: targetCalories,
    );

    await _repository.saveDietProfile(newProfile);
    _profile = newProfile;
    notifyListeners();
  }

  Future<void> addMeal(MealEntryEntity meal) async {
    await _repository.addMealEntry(meal);
    _todayMeals.insert(0, meal);
    notifyListeners();
  }

  Future<void> deleteMeal(String id) async {
    await _repository.deleteMealEntry(id);
    _todayMeals.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
