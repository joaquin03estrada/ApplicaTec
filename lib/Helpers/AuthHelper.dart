import 'package:local_auth/local_auth.dart';

class AuthHelper {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      //Verificar si el dispositivo soporta biometría
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      print("¿Puede checar biometría?: $canCheckBiometrics");

      //Obtener los biométricos disponibles
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      print("Biométricos disponibles: $availableBiometrics");

      //Ejecutar el prompt de autenticación
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Usa tu huella para iniciar sesión',
        options: const AuthenticationOptions(
          biometricOnly: true,   // Solo biometría, sin PIN
          stickyAuth: true,      // Mantener si se va a background
          useErrorDialogs: true, // Mostrar errores del sistema
        ),
      );

      print("👉 Resultado autenticación: $didAuthenticate");
      return didAuthenticate;
    } catch (e) {
      print("❌ Error en autenticación biométrica: $e");
      return false;
    }
  }
}
