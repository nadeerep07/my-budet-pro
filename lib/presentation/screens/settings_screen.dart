import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/export_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/expense_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final expenseVM = context.watch<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data & Backup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (authVM.currentUser == null)
                    ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined, color: AppTheme.primaryBlue),
                      title: const Text('Sign in with Google to Backup'),
                      onTap: () => authVM.signInWithGoogle(),
                    )
                  else ...[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(authVM.currentUser!.photoUrl ?? ''),
                        radius: 16,
                      ),
                      title: Text(authVM.currentUser!.displayName ?? 'User'),
                      subtitle: Text(authVM.currentUser!.email),
                      trailing: TextButton(
                        onPressed: () => authVM.signOut(),
                        child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorRed)),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cloud_upload, color: AppTheme.successGreen),
                      title: const Text('Backup to Cloud'),
                      onTap: () => _backupData(context), // Placeholder for actual backup
                    ),
                    ListTile(
                      leading: const Icon(Icons.cloud_download, color: AppTheme.primaryBlue),
                      title: const Text('Restore from Cloud'),
                      onTap: () => _restoreData(context), // Placeholder for actual restore
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 16),
            IOSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Export', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: AppTheme.primaryBlue),
                    title: const Text('Export all data to CSV'),
                    onTap: () async {
                      await ExportService.exportToCsv(expenseVM.expenses);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exported to documents folder successfully!')),
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
                  const Text('Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable PIN / Biometric Lock'),
                    value: false, // Placeholder for local_auth setup
                    onChanged: (val) {
                      // Implement local auth logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PIN Lock to be fully integrated.')),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating Cloud Backup...')),
    );
  }

  void _restoreData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating Cloud Restore...')),
    );
  }
}
