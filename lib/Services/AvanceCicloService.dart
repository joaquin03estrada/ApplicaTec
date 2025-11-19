import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/Models/AvanceCicloModel.dart';

class AvanceCicloService {
  static final supabase = Supabase.instance.client;

  static Future<AvanceCicloModel?> getAvancePorEstudiante(String numControl) async {
    try {
      print('[AvanceCicloService] Obteniendo avance para: $numControl');

      final response = await supabase
          .from('Avance_Ciclo')
          .select()
          .eq('num_control', numControl)
          .maybeSingle();

      if (response == null) {
        print('[AvanceCicloService] No se encontró avance para el estudiante');
        return null;
      }

      print('[AvanceCicloService] Avance obtenido correctamente');
      return AvanceCicloModel.fromJson(response);
    } catch (e) {
      print('[AvanceCicloService] Error obteniendo avance: $e');
      return null;
    }
  }

  // Obtener todas las materias con su información completa
  static Future<Map<String, dynamic>> getMateriasConInfo(
    String numControl,
  ) async {
    try {
      final avance = await getAvancePorEstudiante(numControl);
      if (avance == null) return {};

      // Obtener todas las claves de materias
      Set<String> claves = {};
      avance.periodos.forEach((periodo, materias) {
        for (var materia in materias) {
          claves.add(materia.clave);
        }
      });

      // Consultar información de todas las materias
      final materiasResponse = await supabase
          .from('Materia')
          .select()
          .inFilter('clave_mat', claves.toList());

      Map<String, dynamic> materiasInfo = {};
      if (materiasResponse != null) {
        for (var materia in materiasResponse) {
          materiasInfo[materia['clave_mat']] = materia;
        }
      }

      return materiasInfo;
    } catch (e) {
      print('[AvanceCicloService] Error obteniendo materias con info: $e');
      return {};
    }
  }
}