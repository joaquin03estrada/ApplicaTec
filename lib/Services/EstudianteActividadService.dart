import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/EstudianteActividadModel.dart';

class EstudianteActividadService {
  static final supabase = Supabase.instance.client;

  static Future<List<EstudianteActividadModel>> getActividadesPorEstudiante(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('Estudiante_Actividad')
          .select('''
            *,
            Actividades_Complementarias (
              clave_act,
              nombre,
              creditos,
              tipo_actividad
            )
          ''')
          .eq('num_control', numControl)
          .order('periodo', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => EstudianteActividadModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo actividades del estudiante: $e');
      return [];
    }
  }

  static Future<List<EstudianteActividadModel>> getActividadesAprobadasPorEstudiante(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('Estudiante_Actividad')
          .select('''
            *,
            Actividades_Complementarias (
              clave_act,
              nombre,
              creditos,
              tipo_actividad
            )
          ''')
          .eq('num_control', numControl)
          .or('calificacion.eq.APROBADA,calificacion.eq.AC,calificacion.eq.A')
          .order('periodo', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => EstudianteActividadModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo actividades aprobadas: $e');
      return [];
    }
  }

  static Future<List<EstudianteActividadModel>> getActividadesPorPeriodo(
    String numControl,
    String periodo,
  ) async {
    try {
      final response = await supabase
          .from('Estudiante_Actividad')
          .select('''
            *,
            Actividades_Complementarias (
              clave_act,
              nombre,
              creditos,
              tipo_actividad
            )
          ''')
          .eq('num_control', numControl)
          .eq('periodo', periodo);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => EstudianteActividadModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo actividades por periodo: $e');
      return [];
    }
  }

  static Future<int> getCreditosTotales(String numControl) async {
    try {
      final actividades = await getActividadesAprobadasPorEstudiante(numControl);
      
      int totalCreditos = 0;
      for (var estudianteActividad in actividades) {
        if (estudianteActividad.actividad?.creditos != null) {
          totalCreditos += estudianteActividad.actividad!.creditos!;
        }
      }
      
      return totalCreditos;
    } catch (e) {
      print('Error calculando créditos totales: $e');
      return 0;
    }
  }

  static Future<bool> registrarActividad(
    Map<String, dynamic> datos,
  ) async {
    try {
      await supabase.from('Estudiante_Actividad').insert(datos);
      return true;
    } catch (e) {
      print('Error registrando actividad del estudiante: $e');
      return false;
    }
  }

  static Future<bool> actualizarCalificacion(
    String numControl,
    String claveAct,
    String calificacion,
  ) async {
    try {
      await supabase
          .from('Estudiante_Actividad')
          .update({'calificacion': calificacion})
          .eq('num_control', numControl)
          .eq('clave_act', claveAct);
      return true;
    } catch (e) {
      print('Error actualizando calificación: $e');
      return false;
    }
  }

  static Future<bool> eliminarActividad(
    String numControl,
    String claveAct,
  ) async {
    try {
      await supabase
          .from('Estudiante_Actividad')
          .delete()
          .eq('num_control', numControl)
          .eq('clave_act', claveAct);
      return true;
    } catch (e) {
      print('Error eliminando actividad: $e');
      return false;
    }
  }

  static Future<bool> actividadYaRegistrada(
    String numControl,
    String claveAct,
  ) async {
    try {
      final response = await supabase
          .from('Estudiante_Actividad')
          .select('num_control')
          .eq('num_control', numControl)
          .eq('clave_act', claveAct)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error verificando actividad: $e');
      return false;
    }
  }
}