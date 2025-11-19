import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/ActividadComplementariaModel.dart';

class ActividadComplementariaService {
  static final supabase = Supabase.instance.client;

  static Future<ActividadComplementariaModel?> getActividadPorClave(
    String claveAct,
  ) async {
    try {
      final response = await supabase
          .from('Actividades_Complementarias')
          .select()
          .eq('clave_act', claveAct)
          .single();

      return ActividadComplementariaModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo actividad complementaria: $e');
      return null;
    }
  }

  static Future<List<ActividadComplementariaModel>> getTodasLasActividades() async {
    try {
      final response = await supabase
          .from('Actividades_Complementarias')
          .select()
          .order('nombre');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => ActividadComplementariaModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo todas las actividades: $e');
      return [];
    }
  }

  static Future<List<ActividadComplementariaModel>> getActividadesPorTipo(
    String tipoActividad,
  ) async {
    try {
      final response = await supabase
          .from('Actividades_Complementarias')
          .select()
          .eq('tipo_actividad', tipoActividad)
          .order('nombre');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => ActividadComplementariaModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo actividades por tipo: $e');
      return [];
    }
  }

  static Future<bool> crearActividad(
    Map<String, dynamic> datos,
  ) async {
    try {
      await supabase.from('Actividades_Complementarias').insert(datos);
      return true;
    } catch (e) {
      print('Error creando actividad: $e');
      return false;
    }
  }

  static Future<bool> actualizarActividad(
    String claveAct,
    Map<String, dynamic> datos,
  ) async {
    try {
      await supabase
          .from('Actividades_Complementarias')
          .update(datos)
          .eq('clave_act', claveAct);
      return true;
    } catch (e) {
      print('Error actualizando actividad: $e');
      return false;
    }
  }
}