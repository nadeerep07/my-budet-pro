import '../../domain/entities/savings_entity.dart';
import '../../domain/repositories/savings_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/savings_model.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final LocalDataSource localDataSource;

  SavingsRepositoryImpl(this.localDataSource);

  @override
  Future<SavingsEntity?> getSavings() async {
    final model = await localDataSource.getSavings();
    return model?.toEntity();
  }

  @override
  Future<void> updateSavings(SavingsEntity savings) async {
    final model = SavingsModel.fromEntity(savings);
    await localDataSource.updateSavings(model);
  }
}
