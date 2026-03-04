import '../../domain/entities/mileage_entry_entity.dart';
import '../../domain/repositories/mileage_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/mileage_entry_model.dart';

class MileageRepositoryImpl implements MileageRepository {
  final LocalDataSource localDataSource;

  MileageRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MileageEntryEntity>> getMileageEntries() async {
    final models = await localDataSource.getMileageEntries();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addMileageEntry(MileageEntryEntity entry) async {
    final model = MileageEntryModel.fromEntity(entry);
    await localDataSource.addMileageEntry(model);
  }

  @override
  Future<void> updateMileageEntry(MileageEntryEntity entry) async {
    final model = MileageEntryModel.fromEntity(entry);
    await localDataSource.updateMileageEntry(model);
  }

  @override
  Future<void> deleteMileageEntry(String id) async {
    await localDataSource.deleteMileageEntry(id);
  }
}
