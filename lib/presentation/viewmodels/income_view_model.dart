import 'package:flutter/material.dart';
import '../../domain/entities/income_entity.dart';
import '../../domain/repositories/income_repository.dart';

class IncomeViewModel extends ChangeNotifier {
  final IncomeRepository _incomeRepository;

  List<IncomeEntity> _incomes = [];
  List<IncomeEntity> get incomes => _incomes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  IncomeViewModel(this._incomeRepository);

  Future<void> loadIncomes() async {
    _isLoading = true;
    notifyListeners();

    _incomes = await _incomeRepository.getIncomes();
    _incomes.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addIncome(IncomeEntity income) async {
    await _incomeRepository.addIncome(income);
    await loadIncomes();
  }

  Future<void> updateIncome(IncomeEntity income) async {
    await _incomeRepository.updateIncome(income);
    await loadIncomes();
  }

  Future<void> deleteIncome(String id) async {
    await _incomeRepository.deleteIncome(id);
    await loadIncomes();
  }

  List<IncomeEntity> getIncomesForMonth(DateTime month) {
    return _incomes
        .where((i) => i.date.year == month.year && i.date.month == month.month)
        .toList();
  }

  double getTotalIncomeForMonth(DateTime month) {
    return getIncomesForMonth(
      month,
    ).fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalIncomeAllTime {
    return _incomes.fold(0.0, (sum, item) => sum + item.amount);
  }
}
