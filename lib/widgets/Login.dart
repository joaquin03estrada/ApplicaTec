import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applicatec/Helpers/ErrorDialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:local_auth/local_auth.dart';
import 'package:applicatec/Helpers/AuthHelper.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final TextEditingController _controlController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  final Uri _url = Uri.parse('https://www.facebook.com/ambartecnm');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _login() async {
    final String control = _controlController.text.trim();
    final String password = _passwordController.text.trim();

    if (control == "21170312" && password == "EAMJ031004HSLSNQA1") {
      // Primero autenticación biométrica
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyScaffold()),
      );
    } else {
      CustomDialog.showError(
        context: context,
        title: "Usuario y/o Contraseña incorrecto",
        message: "Comprueba Usuario y/o Contraseña y vuelve a intentarlo.",
      );
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
                    decoration: InputDecoration(
                      labelText: "Número Control",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xff1b3a6b)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
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
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  IconButton(
                    iconSize: 48,
                    color: Color(0xff1b3a6b),
                    icon: const Icon(Icons.fingerprint),
                    onPressed: () async {
                      bool ok = await AuthHelper.authenticate();
                      if (ok) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyScaffold()),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1b3a6b),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
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
                    onPressed: _launchUrl,
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
}
