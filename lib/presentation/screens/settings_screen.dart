import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/export_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/theme_view_model.dart';
import '../../core/services/local_auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/account_model.dart';
import '../../data/models/savings_model.dart';
import '../../data/models/income_model.dart';
import '../../data/models/mileage_entry_model.dart';
import '../../data/models/transfer_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/diet_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box _settingsBox;
  bool _isAppLockEnabled = false;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settingsBox');
    _isAppLockEnabled = _settingsBox.get(
      'app_lock_enabled',
      defaultValue: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final expenseVM = context.watch<ExpenseViewModel>();
    final themeVM = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Appearance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose app theme',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: themeVM.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeVM.setTheme(val);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: themeVM.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeVM.setTheme(val);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    value: ThemeMode.system,
                    groupValue: themeVM.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeVM.setTheme(val);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data & Backup',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (authVM.currentUser == null)
                    ListTile(
                      leading: Icon(
                        Icons.cloud_upload_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Sign in with Google to Backup'),
                      onTap: () => authVM.signInWithGoogle(),
                    )
                  else ...[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          authVM.currentUser!.photoUrl ?? '',
                        ),
                        radius: 16,
                      ),
                      title: Text(authVM.currentUser!.displayName ?? 'User'),
                      subtitle: Text(authVM.currentUser!.email),
                      trailing: TextButton(
                        onPressed: () => authVM.signOut(),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.cloud_upload,
                        color: Colors.green,
                      ),
                      title: const Text('Backup to Cloud'),
                      onTap: () =>
                          _backupData(context), // Placeholder for actual backup
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.cloud_download,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Restore from Cloud'),
                      onTap: () => _restoreData(
                        context,
                      ), // Placeholder for actual restore
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Export',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(
                      Icons.file_download_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Export all data to CSV'),
                    onTap: () async {
                      final success = await ExportService.exportToCsv(
                        expenseVM.expenses,
                      );
                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('CSV Export ready!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to export CSV.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable PIN / Biometric Lock'),
                    value: _isAppLockEnabled,
                    onChanged: (val) async {
                      if (val) {
                        // User wants to enable app lock, authenticate first
                        final success = await LocalAuthService.authenticate();
                        if (success) {
                          _settingsBox.put('app_lock_enabled', true);
                          setState(() {
                            _isAppLockEnabled = true;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('App Lock enabled successfully.'),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Authentication failed. Cannot enable App Lock.',
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        // User wants to disable app lock
                        _settingsBox.put('app_lock_enabled', false);
                        setState(() {
                          _isAppLockEnabled = false;
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('App Lock disabled.')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _backupData(BuildContext context) async {
    final authVM = context.read<AuthViewModel>();
    if (authVM.currentUser == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Backing up data...')));

    try {
      final remoteDataSource = FirebaseDataSource(FirebaseFirestore.instance);

      // Access boxes to convert models
      final categoriesBox = await Hive.openBox<CategoryModel>('categories');
      final expensesBox = await Hive.openBox<ExpenseModel>('expenses');
      final accountsBox = await Hive.openBox<AccountModel>('accounts');
      final savingsBox = await Hive.openBox<SavingsModel>('savings');
      final incomesBox = await Hive.openBox<IncomeModel>('incomes');
      final mileageBox = await Hive.openBox<MileageEntryModel>('mileage');
      final transferBox = await Hive.openBox<TransferModel>('transferBox');
      final goalBox = await Hive.openBox<GoalModel>('goalBox');
      final serviceBox = await Hive.openBox<ServiceModel>('serviceBox');
      final dietProfileBox = await Hive.openBox<DietProfileModel>(
        'dietProfileBox',
      );
      final mealEntryBox = await Hive.openBox<MealEntryModel>('mealEntryBox');

      final categoriesJson = categoriesBox.values
          .map((e) => e.toJson())
          .toList();
      final expensesJson = expensesBox.values.map((e) => e.toJson()).toList();
      final accountsJson = accountsBox.values.map((e) => e.toJson()).toList();
      final savingsJson = savingsBox.values.isNotEmpty
          ? savingsBox.values.first.toJson()
          : null;
      final incomesJson = incomesBox.values.map((e) => e.toJson()).toList();
      final mileageJson = mileageBox.values.map((e) => e.toJson()).toList();
      final transfersJson = transferBox.values.map((e) => e.toJson()).toList();
      final goalsJson = goalBox.values.map((e) => e.toJson()).toList();
      final servicesJson = serviceBox.values.map((e) => e.toJson()).toList();
      final dietProfileJson = dietProfileBox.values.isNotEmpty
          ? dietProfileBox.values.first.toJson()
          : null;
      final mealEntriesJson = mealEntryBox.values
          .map((e) => e.toJson())
          .toList();

      await remoteDataSource.backupData(
        userId: authVM.currentUser!.id,
        categories: categoriesJson,
        expenses: expensesJson,
        accounts: accountsJson,
        savings: savingsJson,
        incomes: incomesJson,
        mileages: mileageJson,
        transfers: transfersJson,
        goals: goalsJson,
        services: servicesJson,
        dietProfile: dietProfileJson,
        mealEntries: mealEntriesJson,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Backup error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restoreData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating Cloud Restore...')),
    );
  }
}
