import 'dart:io';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:applicatec/Helpers/ConnectivityHelper.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applicatec/Helpers/ErrorDialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:local_auth/local_auth.dart';
import 'package:applicatec/Helpers/AuthHelper.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  bool _isLoading = false;
  bool _biometricAvailable = false;

  final TextEditingController _controlController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  final Uri _url = Uri.parse('https://www.facebook.com/ambartecnm');

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final hasCredentials = await AuthHelper.hasStoredCredentials();
      final canCheckBiometrics = await AuthHelper.checkBiometrics();

      if (mounted) {
        setState(() {
          _biometricAvailable = hasCredentials && canCheckBiometrics;
        });
      }
    } catch (e) {
      print('Error checking biometric availability: $e');
    }
  }

  Future<void> _biometricLogin() async {
    // Verificar conexión a Internet antes de intentar login
    if (!await _checkConnection()) {
      return;
    }

    try {
      if (!_biometricAvailable) {
        return;
      }

      setState(() => _isLoading = true);

      // Autenticar con biometría
      final bool authenticated = await AuthHelper.authenticate();

      if (!authenticated) {
        if (mounted) {
          CustomDialog.showError(
            context: context,
            title: "Autenticación fallida",
            message: "No se pudo verificar tu identidad.",
          );
        }
        return;
      }

      // Obtener credenciales guardadas
      final credentials = await AuthHelper.getStoredCredentials();

      if (credentials == null) {
        if (mounted) {
          CustomDialog.showError(
            context: context,
            title: "Error",
            message: "No se encontraron credenciales guardadas.",
          );
        }
        return;
      }

      final String control = credentials['num_control'];
      final String password = credentials['password'];

      // Verificar credenciales con la base de datos
      final userData = await supabase
          .from('Login')
          .select('num_control, password')
          .eq('num_control', control)
          .single()
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('La conexión tardó demasiado');
            },
          );

      if (userData == null) {
        throw const AuthException('Usuario no encontrado');
      }

      // Verificar contraseña con BCrypt
      final isCorrect = BCrypt.checkpw(password, userData['password']);

      if (!isCorrect) {
        // Credenciales incorrectas, eliminar datos guardados
        await SecureStorageHelper.deleteAllData();
        setState(() => _biometricAvailable = false);

        if (mounted) {
          CustomDialog.showError(
            context: context,
            title: "Error",
            message:
                "Las credenciales guardadas son inválidas. Por favor, inicia sesión nuevamente.",
          );
        }
        return;
      }

      // Login exitoso
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyScaffold(numControl: control)),
        );
      }
    } on TimeoutException {
      if (mounted) {
        CustomDialog.showError(
          context: context,
          title: "Error de conexión",
          message:
              "La operación tardó demasiado. Verifica tu conexión a Internet.",
        );
      }
    } catch (e) {
      print('Error en autenticación biométrica: $e');
      if (mounted) {
        CustomDialog.showError(
          context: context,
          title: "Error",
          message: "Error en la autenticación biométrica.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchUrl() async {
    try {
      if (!await launchUrl(_url)) {
        throw Exception('No se pudo abrir $_url');
      }
    } catch (e) {
      print('Error al abrir URL: $e');
    }
  }

  // Método auxiliar para verificar conexión
  Future<bool> _checkConnection() async {
    if (_isLoading) return true; // Ya está verificando

    setState(() => _isLoading = true);

    final hasConnection = await ConnectivityHelper.hasInternetConnection();

    setState(() => _isLoading = false);

    if (!hasConnection && mounted) {
      ConnectivityHelper.showNoConnectionDialog(context);
      return false;
    }

    return true;
  }

  Future<void> _login() async {
    if (_isLoading) return;

    final String control = _controlController.text.trim();
    final String password = _passwordController.text.trim();

    // Validación de campos
    if (control.isEmpty || password.isEmpty) {
      CustomDialog.showError(
        context: context,
        title: "Campos vacíos",
        message: "Por favor, completa todos los campos.",
      );
      return;
    }

    // Validación de formato del número de control
    if (!RegExp(r'^\d{8}$').hasMatch(control)) {
      CustomDialog.showError(
        context: context,
        title: "Formato inválido",
        message: "El número de control debe tener 8 dígitos.",
      );
      return;
    }

    // Verificar conexión a Internet
    if (!await _checkConnection()) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      print('Intentando login para: $control');

      // Verificar si el usuario existe en la tabla Login
      final userData = await supabase
          .from('Login')
          .select('num_control, password')
          .eq('num_control', control)
          .single()
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('La conexión tardó demasiado');
            },
          );

      print('Datos encontrados: ${userData != null}');

      if (userData == null) {
        throw const AuthException('Usuario no encontrado');
      }

      // Verificar contraseña con BCrypt
      try {
        final isCorrect = BCrypt.checkpw(password, userData['password']);
        print('Verificación de contraseña: $isCorrect');

        if (!isCorrect) {
          throw const AuthException('Contraseña incorrecta');
        }
      } catch (bcryptError) {
        print('Error en verificación BCrypt: $bcryptError');
        throw const AuthException('Error al verificar la contraseña');
      }

      // *** GUARDAR DATOS PARA AUTENTICACIÓN BIOMÉTRICA ***
      try {
        await AuthHelper.enableBiometricLogin(control, password);
        print('Datos biométricos guardados exitosamente');
      } catch (e) {
        print('Error al guardar datos biométricos: $e');
        // No fallar el login si no se pueden guardar los datos biométricos
      }

      // Actualizar estado de disponibilidad biométrica
      await _checkBiometricAvailability();

      // Navegar al dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyScaffold(numControl: control)),
        );
      }
    } on TimeoutException {
      if (mounted) {
        CustomDialog.showError(
          context: context,
          title: "Error de conexión",
          message:
              "La operación tardó demasiado. Verifica tu conexión a Internet e intenta de nuevo.",
        );
      }
    } on SocketException {
      if (mounted) {
        ConnectivityHelper.showNoConnectionDialog(context);
      }
    } on PostgrestException catch (e) {
      print('Error de PostgrestException: ${e.message}');
      if (mounted) {
        // Verificar si es un error de red
        if (e.message.contains('Failed host lookup') ||
            e.message.contains('SocketException') ||
            e.message.contains('Network')) {
          ConnectivityHelper.showNoConnectionDialog(context);
        } else {
          CustomDialog.showError(
            context: context,
            title: "Error de acceso",
            message: "Número de control no encontrado.",
          );
        }
      }
    } catch (error) {
      print('Error general: $error');
      if (mounted) {
        // Verificar si es un error de red
        if (error.toString().contains('SocketException') ||
            error.toString().contains('Failed host lookup') ||
            error.toString().contains('Network')) {
          ConnectivityHelper.showNoConnectionDialog(context);
        } else {
          CustomDialog.showError(
            context: context,
            title: "Error",
            message: "Usuario y/o contraseña incorrectos.",
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

    
  }

  Future<void> _logout() async {
    try {
      await SecureStorageHelper.deleteAllData();
      setState(() {
        _biometricAvailable = false;
      });
    } catch (e) {
      print('Error en logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b3a6b),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/Logo_TecNM_Horizontal_Blanco.svg',
                    height: 100,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff1b3a6b),
                      BlendMode.srcIn,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "INSTITUTO TECNOLOGICO CULIACAN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Bienvenido, ingresa tus credenciales para acceder a la plataforma",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _controlController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    decoration: InputDecoration(
                      labelText: "Número Control",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xff1b3a6b)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xff1b3a6b)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color:
                              _isLoading
                                  ? Colors.grey.withOpacity(0.5)
                                  : Colors.grey,
                        ),
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  setState(() => _obscureText = !_obscureText);
                                },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_biometricAvailable)
                    Column(
                      children: [
                        IconButton(
                          iconSize: 48,
                          color: Color(0xff1b3a6b),
                          icon: const Icon(Icons.fingerprint),
                          onPressed: _isLoading ? null : _biometricLogin,
                        ),
                        const Text(
                          "Usar autenticación biométrica",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1b3a6b),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton.icon(
                    onPressed: _isLoading ? null : _launchUrl,
                    icon: const Icon(Icons.question_mark_sharp),
                    label: const Text("Soporte AMBAR"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
