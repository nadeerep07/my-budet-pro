import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/savings_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import 'package:intl/intl.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savingsVM = context.watch<SavingsViewModel>();
    final expenseVM = context.watch<ExpenseViewModel>();

    final savings = savingsVM.savings;
    final currentBalance = savings?.currentBalance ?? 0.0;
    final totalAdded = savings?.totalAdded ?? 0.0;
    final totalDebited = savings?.totalDebited ?? 0.0;
    
    // Find expenses made from savings
    final savingsExpenses = expenseVM.expenses.where((e) => e.isFromSavings).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IOSCard(
              child: Column(
                children: [
                  const Text('Total Savings Balance', style: TextStyle(color: AppTheme.textGray)),
                  const SizedBox(height: 8),
                  Text(
                    '₹${currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Total Added', totalAdded, AppTheme.successGreen),
                      _buildStat('Total Debited', totalDebited, AppTheme.errorRed),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                        foregroundColor: AppTheme.primaryBlue,
                        elevation: 0,
                      ),
                      onPressed: () => _addFundsDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Funds to Savings'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text('Savings Expenses History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            if (savingsExpenses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No expenses from savings yet.', style: TextStyle(color: AppTheme.textGray)),
              ),
            ...savingsExpenses.map((exp) => IOSCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(exp.description.isEmpty ? 'Savings Expense' : exp.description),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(exp.date)),
                    trailing: Text(
                      '-₹${exp.amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.errorRed, fontSize: 16),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, double amount, Color amountColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textGray, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: amountColor),
        ),
      ],
    );
  }

  void _addFundsDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Funds'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount (₹)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val != null && val > 0) {
                context.read<SavingsViewModel>().addToSavings(val);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
