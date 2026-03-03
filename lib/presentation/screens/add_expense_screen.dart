import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/expense_entity.dart';
import '../theme/app_theme.dart';
import '../viewmodels/accounts_view_model.dart';
import '../viewmodels/budget_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/savings_view_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedAccount;
  bool _isFromSavings = false;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final budgetVM = context.watch<BudgetViewModel>();
    final accountsVM = context.watch<AccountsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IOSCard(
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '₹0',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IOSCard(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    initialValue: _selectedCategory,
                    items: budgetVM.categories.map((c) {
                      return DropdownMenuItem(value: c.id, child: Text(c.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Payment Method'),
                    initialValue: _selectedAccount,
                    items: accountsVM.accounts.map((a) {
                      return DropdownMenuItem(value: a.id, child: Text(a.name));
                    }).toList(),
                    onChanged: _isFromSavings ? null : (val) => setState(() => _selectedAccount = val),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Paid from Savings'),
                    value: _isFromSavings,
                    activeThumbColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setState(() {
                        _isFromSavings = val;
                        if (val) _selectedAccount = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Date'),
                    trailing: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveExpense,
                child: const Text('Save Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;
    if (_selectedCategory == null) return;
    if (!_isFromSavings && _selectedAccount == null) return;

    final expense = ExpenseEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: _selectedCategory!,
      amount: amount,
      description: _descController.text,
      date: _selectedDate,
      accountId: _isFromSavings ? 'savings' : _selectedAccount!,
      isFromSavings: _isFromSavings,
    );

    await context.read<ExpenseViewModel>().addExpense(expense);
    
    if (_isFromSavings) {
      await context.read<SavingsViewModel>().deductFromSavings(amount);
    } else {
      await context.read<AccountsViewModel>().updateAccountBalance(_selectedAccount!, -amount);
    }

    if (mounted) Navigator.pop(context);
  }
}
