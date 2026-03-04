import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/budget_view_model.dart';
import '../viewmodels/month_view_model.dart';
import '../viewmodels/accounts_view_model.dart';
import '../viewmodels/savings_view_model.dart';
import 'add_expense_screen.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({super.key});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  String _searchQuery = '';
  String? _paymentFilter;

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();
    final budgetVM = context.watch<BudgetViewModel>();
    final monthVM = context.watch<MonthViewModel>();
    final currentMonth = monthVM.currentMonth;

    var expenses = expenseVM.getExpensesForMonth(currentMonth);

    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      expenses = expenses
          .where(
            (e) => e.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    // Apply Payment Filter
    if (_paymentFilter != null && _paymentFilter != 'All') {
      if (_paymentFilter == 'savings') {
        expenses = expenses.where((e) => e.isFromSavings).toList();
      } else {
        expenses = expenses
            .where((e) => !e.isFromSavings && e.accountId == _paymentFilter)
            .toList();
      }
    }

    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All Expenses'),
            Text(
              DateFormat('MMMM yyyy').format(currentMonth),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sub-Header padding
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtered Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${totalSpent.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Expenses...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // List
          Expanded(
            child: expenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No expenses found.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters or add a new expense.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      final catName = budgetVM.categories
                          .firstWhere(
                            (c) => c.id == expense.categoryId,
                            orElse: () => budgetVM.categories.first,
                          )
                          .name;

                      return Dismissible(
                        key: Key(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          _deleteExpense(context, expense);
                        },
                        child: IOSCard(
                          padding: const EdgeInsets.all(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              expense.description.isNotEmpty
                                  ? expense.description
                                  : catName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    'dd MMM, hh:mm a',
                                  ).format(expense.date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (expense.isFromSavings)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'From Savings',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${expense.amount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddExpenseScreen(
                                          existingExpense: expense,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _deleteExpense(BuildContext context, expense) async {
    final expenseVM = context.read<ExpenseViewModel>();
    final accountsVM = context.read<AccountsViewModel>();
    final savingsVM = context.read<SavingsViewModel>();

    // Delete the expense
    await expenseVM.deleteExpense(expense.id);

    // Restore the balance
    if (expense.isFromSavings) {
      await savingsVM.addToSavings(expense.amount);
    } else {
      await accountsVM.updateAccountBalance(expense.accountId, expense.amount);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully')),
      );
    }
  }
}
