import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/AlumnoModel.dart';
import 'dart:async';

class AlumnoService {
  static final supabase = Supabase.instance.client;

  static Future<AlumnoModel?> getAlumnoByNumControl(String numControl) async {
    try {
      final response = await supabase
          .from('Estudiantes')
          .select()
          .eq('num_control', numControl)
          .single()
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('La consulta tardó demasiado');
            },
          );

      if (response == null) {
        return null;
      }

      if (response['carrera'] != null && response['carrera'].toString().isNotEmpty) {
        try {
          final carreraResponse = await supabase
              .from('Carrera')
              .select('clave_carrera, nom_carrera')
              .eq('clave_carrera', response['carrera'])
              .maybeSingle();

          if (carreraResponse != null) {
            response['Carrera'] = carreraResponse;
          }
        } catch (e) {
          print('Error al buscar carrera: $e');
        }
      }

      return AlumnoModel.fromJson(response);
    } on PostgrestException catch (e) {
      print('Error PostgrestException: ${e.message}');
      return null;
    } on TimeoutException catch (e) {
      print('Timeout al obtener datos: $e');
      return null;
    } catch (e) {
      print('Error al obtener datos del alumno: $e');
      return null;
    }
  }

  static Future<bool> estudianteExiste(String numControl) async {
    try {
      final response = await supabase
          .from('Estudiantes')
          .select('num_control')
          .eq('num_control', numControl)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error verificando existencia del estudiante: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getEstudianteDatosBasicos(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('Estudiantes')
          .select()
          .eq('num_control', numControl)
          .single();

      return response;
    } catch (e) {
      print('Error obteniendo datos básicos: $e');
      return null;
    }
  }

  static Future<bool> actualizarEstudiante(
    String numControl,
    Map<String, dynamic> datos,
  ) async {
    try {
      await supabase
          .from('Estudiantes')
          .update(datos)
          .eq('num_control', numControl);

      return true;
    } catch (e) {
      print('Error actualizando estudiante: $e');
      return false;
    }
  }
}