import '../../domain/entities/emi_tracker_entity.dart';
import '../../domain/repositories/emi_tracker_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/emi_tracker_model.dart';

class EmiTrackerRepositoryImpl implements EmiTrackerRepository {
  final LocalDataSource localDataSource;

  EmiTrackerRepositoryImpl(this.localDataSource);

  @override
  Future<List<EmiTrackerEntity>> getEmis() async {
    final models = await localDataSource.getEmis();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addEmi(EmiTrackerEntity emi) async {
    final model = EmiTrackerModel.fromEntity(emi);
    await localDataSource.addEmi(model);
  }

  @override
  Future<void> updateEmi(EmiTrackerEntity emi) async {
    final model = EmiTrackerModel.fromEntity(emi);
    await localDataSource.updateEmi(model);
  }

  @override
  Future<void> deleteEmi(String id) async {
    await localDataSource.deleteEmi(id);
  }
}
