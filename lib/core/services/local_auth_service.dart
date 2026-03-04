import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class LocalAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics || canAuthenticate;
    } on PlatformException catch (e) {
      debugPrint("Error checking biometrics: $e");
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      if (!await isBiometricsAvailable()) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your financial data',
      );
    } on PlatformException catch (e) {
      debugPrint("Error during authentication: $e");
      return false;
    }
  }
}
