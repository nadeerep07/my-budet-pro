import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/utils/app_routes.dart';
import 'data/datasources/local_data_source.dart';
import 'data/models/account_model.dart';
import 'data/models/category_model.dart';
import 'data/models/expense_model.dart';
import 'data/models/savings_model.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/savings_repository_impl.dart';
import 'presentation/viewmodels/accounts_view_model.dart';
import 'presentation/viewmodels/auth_view_model.dart';
import 'presentation/viewmodels/budget_view_model.dart';
import 'presentation/viewmodels/expense_view_model.dart';
import 'presentation/viewmodels/savings_view_model.dart';
import 'presentation/viewmodels/month_view_model.dart';
import 'presentation/viewmodels/theme_view_model.dart';
import 'presentation/theme/light_theme.dart';
import 'presentation/theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase FIRST
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 📦 Hive Initialization
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(SavingsModelAdapter());
  await Hive.openBox('settingsBox'); // Initialize settingsBox

  // Data Sources & Repositories
  final localDataSource = HiveDataSourceImpl();
  await localDataSource.init();

  final categoryRepository = CategoryRepositoryImpl(localDataSource);
  final expenseRepository = ExpenseRepositoryImpl(localDataSource);
  final accountRepository = AccountRepositoryImpl(localDataSource);
  final savingsRepository = SavingsRepositoryImpl(localDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MonthViewModel()),
        ChangeNotifierProxyProvider<MonthViewModel, BudgetViewModel>(
          create: (context) =>
              BudgetViewModel(categoryRepository)
                ..loadCategories(context.read<MonthViewModel>().currentMonth),
          update: (context, monthVM, previous) =>
              (previous ?? BudgetViewModel(categoryRepository))
                ..loadCategories(monthVM.currentMonth),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseViewModel(expenseRepository)..loadExpenses(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountsViewModel(accountRepository)..loadAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) => SavingsViewModel(savingsRepository)..loadSavings(),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyBudgetApp(),
    ),
  );
}

class MyBudgetApp extends StatelessWidget {
  const MyBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVM, child) {
        return MaterialApp(
          title: 'MyBudgetPro',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeVM.themeMode,
          initialRoute: AppRoutes.dashboard,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
