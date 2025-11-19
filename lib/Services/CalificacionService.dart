import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/Models/CalificacionModel.dart';  

class CalificacionService {
  static final supabase = Supabase.instance.client;

  static Future<List<CalificacionModel>> getCalificacionesPorEstudiante(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('calificaciones')
          .select('*')
          .eq('num_control', numControl)
          .order('id_clase')
          .order('unidad');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => CalificacionModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<CalificacionModel>> getCalificacionesPorClase(
    String numControl,
    int idClase,
  ) async {
    try {
      final response = await supabase
          .from('calificaciones')
          .select('*')
          .eq('num_control', numControl)
          .eq('id_clase', idClase)
          .order('unidad');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => CalificacionModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<double?> getCalificacionFinal(
    String numControl,
    int idClase,
  ) async {
    try {
      final response = await supabase
          .from('calificaciones')
          .select('calif_final')
          .eq('num_control', numControl)
          .eq('id_clase', idClase)
          .not('calif_final', 'is', null)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return double.tryParse(response['calif_final'].toString());
    } catch (e) {
      return null;
    }
  }
}