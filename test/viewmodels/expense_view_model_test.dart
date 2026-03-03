import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget_pro/domain/entities/expense_entity.dart';
import 'package:my_budget_pro/domain/repositories/expense_repository.dart';
import 'package:my_budget_pro/presentation/viewmodels/expense_view_model.dart';

class MockExpenseRepository implements ExpenseRepository {
  final List<ExpenseEntity> _expenses = [];

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    _expenses.add(expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    return _expenses;
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(String categoryId) async {
    return _expenses.where((e) => e.categoryId == categoryId).toList();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByMonth(DateTime month) async {
    return _expenses.where((e) => e.date.year == month.year && e.date.month == month.month).toList();
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
  }
}

void main() {
  group('ExpenseViewModel Tests', () {
    late ExpenseViewModel viewModel;
    late MockExpenseRepository repository;

    setUp(() {
      repository = MockExpenseRepository();
      viewModel = ExpenseViewModel(repository);
    });

    test('Add expense and calculate total spent in month', () async {
      final now = DateTime.now();
      
      final expense1 = ExpenseEntity(
        id: '1',
        categoryId: 'cat1',
        amount: 500,
        description: 'Test 1',
        date: now,
        accountId: 'acc1',
      );
      
      final expense2 = ExpenseEntity(
        id: '2',
        categoryId: 'cat2',
        amount: 1500,
        description: 'Test 2',
        date: now,
        accountId: 'acc2',
      );

      await viewModel.addExpense(expense1);
      await viewModel.addExpense(expense2);

      final total = viewModel.getTotalSpentInMonth(now);
      expect(total, 2000.0);
    });

    test('Calculate total spent for a specific category in month', () async {
      final now = DateTime.now();
      
      final expense1 = ExpenseEntity(
        id: '1',
        categoryId: 'cat1',
        amount: 500,
        description: 'Test 1',
        date: now,
        accountId: 'acc1',
      );
      
      final expense2 = ExpenseEntity(
        id: '2',
        categoryId: 'cat1',
        amount: 300,
        description: 'Test 2',
        date: now,
        accountId: 'acc2',
      );

      final expense3 = ExpenseEntity(
        id: '3',
        categoryId: 'cat2',
        amount: 1000,
        description: 'Test 3',
        date: now,
        accountId: 'acc1',
      );

      await viewModel.addExpense(expense1);
      await viewModel.addExpense(expense2);
      await viewModel.addExpense(expense3);

      final cat1Total = viewModel.getTotalSpentForCategoryInMonth('cat1', now);
      expect(cat1Total, 800.0);
    });
  });
}
