import 'package:flutter/material.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';

class AccountsViewModel extends ChangeNotifier {
  final AccountRepository _accountRepository;

  List<AccountEntity> _accounts = [];
  List<AccountEntity> get accounts => _accounts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AccountsViewModel(this._accountRepository);

  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();

    _accounts = await _accountRepository.getAccounts();

    // Setup predefined accounts if none exist
    if (_accounts.isEmpty) {
      final defaults = [
        const AccountEntity(id: 'sbi', name: 'SBI', initialBalance: 0),
        const AccountEntity(id: 'hdfc', name: 'HDFC', initialBalance: 0),
        const AccountEntity(id: 'airtel', name: 'Airtel Payment Bank', initialBalance: 0),
        const AccountEntity(id: 'supermoney', name: 'Super Money Credit Card', initialBalance: 0),
        const AccountEntity(id: 'cash', name: 'Cash', initialBalance: 0),
      ];

      for (var acc in defaults) {
        await _accountRepository.addAccount(acc);
      }
      _accounts = defaults;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateAccountBalance(String id, double difference) async {
    final accountIndex = _accounts.indexWhere((acc) => acc.id == id);
    if (accountIndex != -1) {
      final acc = _accounts[accountIndex];
      final newAcc = AccountEntity(
        id: acc.id,
        name: acc.name,
        initialBalance: acc.initialBalance + difference,
      );
      await _accountRepository.updateAccount(newAcc);
      await loadAccounts();
    }
  }

  double get totalBalance {
    return _accounts.fold(0.0, (sum, acc) => sum + acc.initialBalance);
  }
}
