import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final LocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.addExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    final models = await localDataSource.getExpenses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(String categoryId) async {
    final all = await getExpenses();
    return all.where((e) => e.categoryId == categoryId).toList();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByMonth(DateTime month) async {
    final all = await getExpenses();
    return all.where((e) => 
      e.date.year == month.year && e.date.month == month.month
    ).toList();
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.updateExpense(model);
  }
}
