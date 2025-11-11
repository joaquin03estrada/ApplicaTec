import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/ClaseModel.dart';
import 'dart:async';

class ClaseService {
  static final supabase = Supabase.instance.client;

  static Future<List<ClaseModel>> getClasesPorEstudiante(String numControl) async {
    try {
      final response = await supabase
          .from('Clase_Estudiante')
          .select('''
            id_clase,
            Clase (
              id_Clase,
              horario_inicio,
              horario_fin,
              clave_grupo,
              clave_mat,
              num_control_maest,
              Grupo (
                Clave_grupo,
                Aula
              ),
              Materia (
                clave_mat,
                nombre_mat,
                tipo_mat,
                creditos,
                semestre,
                nombre_mat_corto
              ),
              Maestros (
                num_control_maestro,
                nombre,
                ap_pater,
                ap_mater,
                departamento
              )
            )
          ''')
          .eq('num_control', numControl);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => ClaseModel.fromJson(item['Clase']))
          .toList();
    } catch (e) {
      print('Error obteniendo clases del estudiante: $e');
      return [];
    }
  }

  static Future<ClaseModel?> getClasePorId(String idClase) async {
    try {
      final response = await supabase
          .from('Clase')
          .select('''
            *,
            Grupo (
              Clave_grupo,
              Aula
            ),
            Materia (
              clave_mat,
              nombre_mat,
              tipo_mat,
              creditos,
              semestre,
              nombre_mat_corto
            ),
            Maestros (
              num_control_maestro,
              nombre,
              ap_pater,
              ap_mater,
              departamento
            )
          ''')
          .eq('id_Clase', idClase)
          .single();

      return ClaseModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo clase: $e');
      return null;
    }
  }

  static Future<List<ClaseModel>> getTodasLasClases() async {
    try {
      final response = await supabase
          .from('Clase')
          .select('''
            *,
            Grupo (Clave_grupo, Aula),
            Materia (clave_mat, nombre_mat, nombre_mat_corto),
            Maestros (num_control_maestro, nombre, ap_pater, ap_mater)
          ''');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((item) => ClaseModel.fromJson(item)).toList();
    } catch (e) {
      print('Error obteniendo todas las clases: $e');
      return [];
    }
  }
}