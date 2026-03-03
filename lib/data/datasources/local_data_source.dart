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
