import 'package:flutter/material.dart';
import 'package:my_budget_pro/presentation/screens/accounts_screen.dart';
import 'package:my_budget_pro/presentation/screens/add_expense_screen.dart';
import 'package:my_budget_pro/presentation/screens/analytics_screen.dart';
import 'package:my_budget_pro/presentation/screens/budget_screen.dart';
import 'package:my_budget_pro/presentation/screens/savings_screen.dart';
import 'package:my_budget_pro/presentation/screens/settings_screen.dart';
import 'package:my_budget_pro/presentation/screens/all_expenses_screen.dart';
import 'package:my_budget_pro/presentation/screens/income_screen.dart';
import 'package:my_budget_pro/presentation/screens/mileage_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String addExpense = '/addExpense';
  static const String budget = '/budget';
  static const String accounts = '/accounts';
  static const String analytics = '/analytics';
  static const String setting = '/settings';
  static const String savings = '/savings';
  static const String allExpenses = '/allExpenses';
  static const String income = '/income';
  static const String mileage = '/mileage';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case addExpense:
        return MaterialPageRoute(builder: (_) => const AddExpenseScreen());
      case budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());
      case accounts:
        return MaterialPageRoute(builder: (_) => const AccountsScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case savings:
        return MaterialPageRoute(builder: (_) => const SavingsScreen());
      case allExpenses:
        return MaterialPageRoute(builder: (_) => const AllExpensesScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case income:
        return MaterialPageRoute(builder: (_) => const IncomeScreen());
      case mileage:
        return MaterialPageRoute(builder: (_) => const MileageScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
