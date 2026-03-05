import '../../domain/entities/diet_entity.dart';
import '../../domain/repositories/diet_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/diet_model.dart';
import 'package:intl/intl.dart';

class DietRepositoryImpl implements DietRepository {
  final LocalDataSource localDataSource;

  DietRepositoryImpl(this.localDataSource);

  @override
  Future<DietProfileEntity?> getDietProfile() async {
    final model = await localDataSource.getDietProfile();
    return model?.toEntity();
  }

  @override
  Future<void> saveDietProfile(DietProfileEntity profile) async {
    final model = DietProfileModel.fromEntity(profile);
    await localDataSource.saveDietProfile(model);
  }

  @override
  Future<List<MealEntryEntity>> getMealEntries(DateTime date) async {
    final models = await localDataSource.getMealEntries();
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return models
        .where((m) => DateFormat('yyyy-MM-dd').format(m.date) == dateStr)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> addMealEntry(MealEntryEntity entry) async {
    final model = MealEntryModel.fromEntity(entry);
    await localDataSource.addMealEntry(model);
  }

  @override
  Future<void> deleteMealEntry(String id) async {
    await localDataSource.deleteMealEntry(id);
  }
}
