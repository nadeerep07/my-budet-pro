import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/budget_view_model.dart';
import '../viewmodels/expense_view_model.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetVM = context.watch<BudgetViewModel>();
    final expenseVM = context.watch<ExpenseViewModel>();
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets & Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: budgetVM.categories.length,
        itemBuilder: (context, index) {
          final cat = budgetVM.categories[index];
          final spent = expenseVM.getTotalSpentForCategoryInMonth(cat.id, now);
          final remaining = cat.monthlyBudget - spent;
          final percentUsed = (spent / cat.monthlyBudget).clamp(0.0, 1.0);

          return IOSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('₹${cat.monthlyBudget.toStringAsFixed(0)} / mo', style: const TextStyle(color: AppTheme.textGray)),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percentUsed,
                  backgroundColor: AppTheme.backgroundWhite,
                  color: percentUsed > 0.8 ? AppTheme.errorRed : AppTheme.primaryBlue,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Spent: ₹${spent.toStringAsFixed(0)}'),
                    Text(
                      'Left: ₹${remaining.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: remaining < 0 ? AppTheme.errorRed : AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(
              controller: budgetCtrl,
              decoration: const InputDecoration(labelText: 'Monthly Budget'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final budget = double.tryParse(budgetCtrl.text);
              if (nameCtrl.text.isNotEmpty && budget != null) {
                context.read<BudgetViewModel>().addCategory(nameCtrl.text, budget);
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
