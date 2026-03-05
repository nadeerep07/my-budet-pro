import 'package:flutter/foundation.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfer_repository.dart';
import 'accounts_view_model.dart';
import 'savings_view_model.dart';

class TransferViewModel extends ChangeNotifier {
  final TransferRepository _repository;
  final AccountsViewModel _accountsVM;
  final SavingsViewModel _savingsVM;

  List<TransferEntity> _transfers = [];
  bool _isLoading = false;

  TransferViewModel(this._repository, this._accountsVM, this._savingsVM);

  List<TransferEntity> get transfers => _transfers;
  bool get isLoading => _isLoading;

  Future<void> loadTransfers() async {
    _isLoading = true;
    notifyListeners();

    _transfers = await _repository.getTransfers();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransfer(TransferEntity transfer) async {
    await _repository.addTransfer(transfer);
    _transfers.insert(0, transfer);

    await _applyTransferToBalances(transfer);

    notifyListeners();
  }

  Future<void> updateTransfer(
    TransferEntity newTransfer,
    TransferEntity oldTransfer,
  ) async {
    await _repository.updateTransfer(newTransfer);
    final index = _transfers.indexWhere((t) => t.id == newTransfer.id);
    if (index != -1) {
      _transfers[index] = newTransfer;

      // Reverse old transfer
      await _reverseTransferFromBalances(oldTransfer);
      // Apply new transfer
      await _applyTransferToBalances(newTransfer);

      notifyListeners();
    }
  }

  Future<void> deleteTransfer(TransferEntity transfer) async {
    await _repository.deleteTransfer(transfer.id);
    _transfers.removeWhere((t) => t.id == transfer.id);

    await _reverseTransferFromBalances(transfer);

    notifyListeners();
  }

  // --- Balance Management ---

  Future<void> _applyTransferToBalances(TransferEntity t) async {
    // Deduct from sender
    if (t.fromAccountId == 'savings') {
      await _savingsVM.deductFromSavings(t.amount);
    } else {
      await _accountsVM.updateAccountBalance(t.fromAccountId, -t.amount);
    }

    // Add to receiver
    if (t.toAccountId == 'savings') {
      await _savingsVM.addToSavings(t.amount);
    } else {
      await _accountsVM.updateAccountBalance(t.toAccountId, t.amount);
    }
  }

  Future<void> _reverseTransferFromBalances(TransferEntity t) async {
    // Return money to sender
    if (t.fromAccountId == 'savings') {
      await _savingsVM.addToSavings(t.amount);
    } else {
      await _accountsVM.updateAccountBalance(t.fromAccountId, t.amount);
    }

    // Deduct money from receiver
    if (t.toAccountId == 'savings') {
      await _savingsVM.deductFromSavings(t.amount);
    } else {
      await _accountsVM.updateAccountBalance(t.toAccountId, -t.amount);
    }
  }
}
