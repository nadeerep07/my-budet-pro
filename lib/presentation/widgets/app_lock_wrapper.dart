import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/local_auth_service.dart';

class AppLockWrapper extends StatefulWidget {
  final Widget child;

  const AppLockWrapper({super.key, required this.child});

  @override
  State<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<AppLockWrapper>
    with WidgetsBindingObserver {
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settingsBox = Hive.box('settingsBox');
    _checkInitialAuth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuthOnResume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isAppLockEnabled() && !_isAuthenticating) {
        setState(() {
          _isAuthenticated = false;
        });
      }
    }
  }

  bool _isAppLockEnabled() {
    return _settingsBox.get('app_lock_enabled', defaultValue: false) as bool;
  }

  Future<void> _checkInitialAuth() async {
    if (!_isAppLockEnabled()) {
      setState(() {
        _isAuthenticated = true;
      });
      return;
    }

    await _authenticate();
  }

  Future<void> _checkAuthOnResume() async {
    if (!_isAppLockEnabled() || _isAuthenticated || _isAuthenticating) {
      return;
    }
    await _authenticate();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    final success = await LocalAuthService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticated = success;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAppLockEnabled()) return widget.child;

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'App Locked',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please authenticate to access your data.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (!_isAuthenticating)
                ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                )
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
