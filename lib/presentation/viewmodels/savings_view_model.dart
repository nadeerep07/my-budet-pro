import 'package:flutter/material.dart';
import '../../domain/entities/savings_entity.dart';
import '../../domain/repositories/savings_repository.dart';

class SavingsViewModel extends ChangeNotifier {
  final SavingsRepository _savingsRepository;

  SavingsEntity? _savings;
  SavingsEntity? get savings => _savings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SavingsViewModel(this._savingsRepository);

  Future<void> loadSavings() async {
    _isLoading = true;
    notifyListeners();

    _savings = await _savingsRepository.getSavings();
    if (_savings == null) {
      _savings = const SavingsEntity(id: 'main_savings', totalAdded: 0, totalDebited: 0);
      await _savingsRepository.updateSavings(_savings!);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToSavings(double amount) async {
    if (_savings == null) return;
    final newSavings = SavingsEntity(
      id: _savings!.id,
      totalAdded: _savings!.totalAdded + amount,
      totalDebited: _savings!.totalDebited,
    );
    await _savingsRepository.updateSavings(newSavings);
    await loadSavings();
  }

  Future<void> deductFromSavings(double amount) async {
    if (_savings == null) return;
    final newSavings = SavingsEntity(
      id: _savings!.id,
      totalAdded: _savings!.totalAdded,
      totalDebited: _savings!.totalDebited + amount,
    );
    await _savingsRepository.updateSavings(newSavings);
    await loadSavings();
  }
}
