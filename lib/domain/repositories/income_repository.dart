import '../entities/income_entity.dart';

abstract class IncomeRepository {
  Future<List<IncomeEntity>> getIncomes();
  Future<void> addIncome(IncomeEntity income);
  Future<void> updateIncome(IncomeEntity income);
  Future<void> deleteIncome(String id);
}
