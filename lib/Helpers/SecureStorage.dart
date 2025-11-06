import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();
  static const _keySessionData = 'supabase_session';
  static const _keyUserData = 'user_data';
  static const _keyUserCredentials = 'user_credentials'; // Nueva clave

  // Guardar datos de sesión completos (JSON con access_token y refresh_token)
  static Future<void> saveSessionData(String sessionData) async {
    await _storage.write(key: _keySessionData, value: sessionData);
  }

  // Obtener datos de sesión
  static Future<String?> getSessionData() async {
    return await _storage.read(key: _keySessionData);
  }

  // Guardar datos del usuario
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _keyUserData, value: json.encode(userData));
  }

  // Obtener datos del usuario
  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _keyUserData);
    return data != null ? json.decode(data) : null;
  }

  // Guardar credenciales del usuario (para login biométrico)
  static Future<void> saveUserCredentials(String control, String password) async {
    final credentials = {
      'num_control': control,
      'password': password,
    };
    await _storage.write(key: _keyUserCredentials, value: json.encode(credentials));
  }

  // Obtener credenciales del usuario
  static Future<Map<String, dynamic>?> getUserCredentials() async {
    final data = await _storage.read(key: _keyUserCredentials);
    return data != null ? json.decode(data) : null;
  }

  // Eliminar todos los datos guardados
  static Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }

  // Eliminar solo los datos de sesión
  static Future<void> deleteSessionData() async {
    await _storage.delete(key: _keySessionData);
  }

  // Eliminar credenciales
  static Future<void> deleteUserCredentials() async {
    await _storage.delete(key: _keyUserCredentials);
  }
}