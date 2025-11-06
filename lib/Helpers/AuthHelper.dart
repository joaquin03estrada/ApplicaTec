import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';

class AuthHelper {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final supabase = Supabase.instance.client;

  // Verificar si el dispositivo soporta autenticación biométrica
  static Future<bool> checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } on PlatformException catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  // Obtener los tipos de biometría disponibles
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return <BiometricType>[];
    }
  }

  // Autenticar con biometría
  static Future<bool> authenticate() async {
    try {
      // Verificar si hay credenciales guardadas
      final credentials = await SecureStorageHelper.getUserCredentials();
      
      if (credentials == null) {
        print('No hay credenciales guardadas');
        return false;
      }

      // Intentar autenticación biométrica
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Por favor, autentícate para acceder a la aplicación',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!didAuthenticate) {
        print('Autenticación biométrica fallida');
        return false;
      }

      // Autenticación biométrica exitosa
      print('Autenticación biométrica exitosa');
      return true;

    } on PlatformException catch (e) {
      print('Error en autenticación biométrica: $e');
      return false;
    } catch (e) {
      print('Error general en authenticate: $e');
      return false;
    }
  }

  // Habilitar autenticación biométrica después del login exitoso
  static Future<void> enableBiometricLogin(String control, String password) async {
    try {
      // Guardar credenciales de forma segura
      await SecureStorageHelper.saveUserCredentials(control, password);
      
      // Guardar datos del usuario
      await SecureStorageHelper.saveUserData({'num_control': control});
      
      // Si usas sesión de Supabase, también guardarla
      final session = supabase.auth.currentSession;
      if (session != null) {
        final sessionData = {
          'access_token': session.accessToken,
          'refresh_token': session.refreshToken,
        };
        await SecureStorageHelper.saveSessionData(
          jsonEncode(sessionData),
        );
        print('Sesión de Supabase guardada');
      }
      
      print('Autenticación biométrica habilitada exitosamente');
    } catch (e) {
      print('Error al habilitar el login biométrico: $e');
      rethrow;
    }
  }

  // Verificar si hay credenciales guardadas
  static Future<bool> hasStoredCredentials() async {
    final credentials = await SecureStorageHelper.getUserCredentials();
    return credentials != null;
  }

  // Obtener credenciales guardadas (solo después de autenticación biométrica exitosa)
  static Future<Map<String, dynamic>?> getStoredCredentials() async {
    return await SecureStorageHelper.getUserCredentials();
  }
}