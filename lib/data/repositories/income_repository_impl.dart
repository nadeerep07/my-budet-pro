import '../../domain/entities/income_entity.dart';
import '../../domain/repositories/income_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/income_model.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final LocalDataSource _localDataSource;

  IncomeRepositoryImpl(this._localDataSource);

  @override
  Future<List<IncomeEntity>> getIncomes() async {
    final models = await _localDataSource.getIncomes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addIncome(IncomeEntity income) async {
    final model = IncomeModel.fromEntity(income);
    await _localDataSource.addIncome(model);
  }

  @override
  Future<void> updateIncome(IncomeEntity income) async {
    final model = IncomeModel.fromEntity(income);
    await _localDataSource.updateIncome(model);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _localDataSource.deleteIncome(id);
  }
}
