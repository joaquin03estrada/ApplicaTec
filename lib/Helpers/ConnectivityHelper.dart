import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

class ConnectivityHelper {
  // Verificar si hay conexión REAL a Internet (hace un ping)
  static Future<bool> hasInternetConnection() async {
    try {
      // Intenta conectarse a múltiples servidores para mayor confiabilidad
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  // Verificar conexión con un servidor específico (como Supabase)
  static Future<bool> canReachServer(String host) async {
    try {
      final result = await InternetAddress.lookup(host)
          .timeout(Duration(seconds: 5));
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error reaching server: $e');
      return false;
    }
  }

  // Verificar múltiples servidores
  static Future<bool> hasInternetConnectionAdvanced() async {
    final servers = [
      'google.com',
      '1.1.1.1',  // Cloudflare DNS
      '8.8.8.8',  // Google DNS
    ];

    for (String server in servers) {
      try {
        final result = await InternetAddress.lookup(server)
            .timeout(Duration(seconds: 3));
        
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    
    return false;
  }

  // Mostrar diálogo de no conexión
  static void showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Expanded(child: Text('Sin conexión')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No se pudo conectar a Internet.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Por favor, verifica tu conexión WiFi o datos móviles e intenta nuevamente.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1b3a6b),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Mostrar snackbar de no conexión
  static void showNoConnectionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Sin conexión a Internet. Verifica tu red.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  // Mostrar snackbar de conexión restaurada
  static void showConnectionRestoredSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi, color: Colors.white),
            SizedBox(width: 10),
            Text('Conexión a Internet restaurada'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}