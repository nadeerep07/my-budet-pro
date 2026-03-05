import '../entities/diet_entity.dart';

abstract class DietRepository {
  Future<DietProfileEntity?> getDietProfile();
  Future<void> saveDietProfile(DietProfileEntity profile);

  Future<List<MealEntryEntity>> getMealEntries(DateTime date);
  Future<void> addMealEntry(MealEntryEntity entry);
  Future<void> deleteMealEntry(String id);
}
