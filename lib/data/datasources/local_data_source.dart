import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/account_model.dart';
import '../models/savings_model.dart';

abstract class LocalDataSource {
  Future<void> init();

  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);

  // Expenses
  Future<List<ExpenseModel>> getExpenses();
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);

  // Accounts
  Future<List<AccountModel>> getAccounts();
  Future<void> addAccount(AccountModel account);
  Future<void> updateAccount(AccountModel account);
  Future<void> deleteAccount(String id);

  // Savings
  Future<SavingsModel?> getSavings();
  Future<void> updateSavings(SavingsModel savings);
}

class HiveDataSourceImpl implements LocalDataSource {
  late Box<CategoryModel> _categoryBox;
  late Box<ExpenseModel> _expenseBox;
  late Box<AccountModel> _accountBox;
  late Box<SavingsModel> _savingsBox;

  @override
  Future<void> init() async {
    _categoryBox = await Hive.openBox<CategoryModel>('categories');
    _expenseBox = await Hive.openBox<ExpenseModel>('expenses');
    _accountBox = await Hive.openBox<AccountModel>('accounts');
    _savingsBox = await Hive.openBox<SavingsModel>('savings');

    await _migrateLegacyCategories();
  }

  Future<void> _migrateLegacyCategories() async {
    final settingsBox = await Hive.openBox('settingsBox');
    final bool hasMigrated = settingsBox.get(
      'migration_legacy_categories',
      defaultValue: false,
    );

    if (hasMigrated) return; // Already ran

    final allCategories = _categoryBox.values.toList();
    final legacyCategories = allCategories
        .where((c) => c.month == null || c.year == null)
        .toList();

    if (legacyCategories.isEmpty) {
      // Nothing to migrate, mark as done
      await settingsBox.put('migration_legacy_categories', true);
      return;
    }

    final allExpenses = _expenseBox.values.toList();

    // Find all unique (month, year) combos from expenses
    final Map<String, DateTime> uniqueMonths = {};
    for (var expense in allExpenses) {
      final key = '${expense.date.year}_${expense.date.month}';
      uniqueMonths[key] = DateTime(expense.date.year, expense.date.month);
    }

    // Always include current month just in case
    final now = DateTime.now();
    uniqueMonths['${now.year}_${now.month}'] = DateTime(now.year, now.month);

    // For every unique month and legacy category, clone the category into that month
    final Map<String, String> oldIdToNewIdMap = {}; // oldId_month_year -> newId

    for (var date in uniqueMonths.values) {
      for (var legacyCat in legacyCategories) {
        final newId = '${legacyCat.id}_${date.month}_${date.year}_migrated';

        final newCat = CategoryModel(
          id: newId,
          name: legacyCat.name,
          monthlyBudget: legacyCat.monthlyBudget,
          isCustom: legacyCat.isCustom,
          month: date.month,
          year: date.year,
        );

        await _categoryBox.put(newId, newCat);
        oldIdToNewIdMap['${legacyCat.id}_${date.month}_${date.year}'] = newId;
      }
    }

    // Update all expenses to point to the newly cloned monthly categories
    for (var expense in allExpenses) {
      // If the expense uses a legacy category, redirect it to the cloned monthly one
      final isLegacyCategory = legacyCategories.any(
        (c) => c.id == expense.categoryId,
      );
      if (isLegacyCategory) {
        final newCategoryId =
            oldIdToNewIdMap['${expense.categoryId}_${expense.date.month}_${expense.date.year}'];
        if (newCategoryId != null) {
          final updatedExpense = ExpenseModel(
            id: expense.id,
            categoryId: newCategoryId,
            amount: expense.amount,
            description: expense.description,
            date: expense.date,
            accountId: expense.accountId,
            isFromSavings: expense.isFromSavings,
          );
          await _expenseBox.put(updatedExpense.id, updatedExpense);
        }
      }
    }

    // Clean up original legacy categories
    for (var legacyCat in legacyCategories) {
      await _categoryBox.delete(legacyCat.id);
    }

    // Migration complete
    await settingsBox.put('migration_legacy_categories', true);
  }

  // --- Categories ---
  @override
  Future<List<CategoryModel>> getCategories() async {
    return _categoryBox.values.toList();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _categoryBox.put(category.id, category);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _categoryBox.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  // --- Expenses ---
  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return _expenseBox.values.toList();
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  // --- Accounts ---
  @override
  Future<List<AccountModel>> getAccounts() async {
    return _accountBox.values.toList();
  }

  @override
  Future<void> addAccount(AccountModel account) async {
    await _accountBox.put(account.id, account);
  }

  @override
  Future<void> updateAccount(AccountModel account) async {
    await _accountBox.put(account.id, account);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await _accountBox.delete(id);
  }

  // --- Savings ---
  @override
  Future<SavingsModel?> getSavings() async {
    if (_savingsBox.isEmpty) return null;
    return _savingsBox.get('main_savings');
  }

  @override
  Future<void> updateSavings(SavingsModel savings) async {
    await _savingsBox.put('main_savings', savings);
  }
}
