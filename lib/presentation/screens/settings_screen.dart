import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/export_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/theme_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                      await ExportService.exportToCsv(expenseVM.expenses);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Exported to documents folder successfully!',
                            ),
                          ),
                        );
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
                    value: false, // Placeholder for local_auth setup
                    onChanged: (val) {
                      // Implement local auth logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIN Lock to be fully integrated.'),
                        ),
                      );
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

  void _backupData(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Simulating Cloud Backup...')));
  }

  void _restoreData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating Cloud Restore...')),
    );
  }
}
