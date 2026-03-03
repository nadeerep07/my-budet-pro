import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_routes.dart';
import '../theme/app_theme.dart';
import '../viewmodels/accounts_view_model.dart';
import '../viewmodels/budget_view_model.dart';
import '../viewmodels/expense_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();
    final budgetVM = context.watch<BudgetViewModel>();
    final accountsVM = context.watch<AccountsViewModel>();

    final double totalBudget = budgetVM.categories.fold(0, (sum, cat) => sum + cat.monthlyBudget);
    final double totalSpent = expenseVM.getTotalSpentInMonth(DateTime.now());
    final double remaining = totalBudget - totalSpent;
    final double totalBalance = accountsVM.totalBalance;

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text('MyBudgetPro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.setting),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCard(context, totalBudget, totalSpent, remaining),
              const SizedBox(height: 16),
              _buildAccountsOverview(context, totalBalance),
              const SizedBox(height: 16),
              _buildActionGrid(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addExpense),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double total, double spent, double remaining) {
    return IOSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textGray,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('Budget', '₹${total.toStringAsFixed(0)}', AppTheme.textBlack),
              _buildColumn('Spent', '₹${spent.toStringAsFixed(0)}', AppTheme.errorRed),
              _buildColumn('Remaining', '₹${remaining.toStringAsFixed(0)}', remaining >= 0 ? AppTheme.successGreen : AppTheme.errorRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textGray, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _buildAccountsOverview(BuildContext context, double totalBalance) {
    return IOSCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Balance', style: TextStyle(color: AppTheme.textGray, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                '₹${totalBalance.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.accounts),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
              foregroundColor: AppTheme.primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View All'),
          )
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildActionCard(context, 'Budget', Icons.pie_chart_outline, AppRoutes.budget),
          _buildActionCard(context, 'Analytics', Icons.bar_chart, AppRoutes.analytics),
          _buildActionCard(context, 'Savings', Icons.savings_outlined, AppRoutes.savings),
          _buildActionCard(context, 'Accounts', Icons.account_balance_wallet_outlined, AppRoutes.accounts),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
