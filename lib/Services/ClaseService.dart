import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/Models/ClaseModel.dart';  

class ClaseService {
  static final supabase = Supabase.instance.client;

  static Future<List<ClaseModel>> getClasesPorEstudiante(
    String numControl,
  ) async {
    try {
      final numControlNormalizado = numControl.trim();
      
      final responseCalif = await supabase
          .from('calificaciones')
          .select('id_clase')
          .eq('num_control', numControlNormalizado);

      if (responseCalif == null || responseCalif.isEmpty) {
        return [];
      }

      Set<int> idsClases = {};
      for (var item in responseCalif) {
        final idClase = item['id_clase'];
        if (idClase != null) {
          idsClases.add(idClase);
        }
      }

      if (idsClases.isEmpty) {
        return [];
      }

      final responseClases = await supabase
          .from('Clase')
          .select('''
            *,
            Grupo (
              clave_grupo,
              aula
            ),
            Materia (
              clave_mat,
              nombre_mat,
              nombre_mat_corto,
              creditos
            ),
            Maestros (
              num_control_maestro,
              nombre,
              ap_pater,
              ap_mater
            )
          ''')
          .inFilter('id_clase', idsClases.toList());

      if (responseClases == null || responseClases.isEmpty) {
        return [];
      }

      return (responseClases as List)
          .map((item) => ClaseModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }
}