import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/GrupoModel.dart';

class GrupoService {
  static final supabase = Supabase.instance.client;

  static Future<GrupoModel?> getGrupoPorClave(String claveGrupo) async {
    try {
      final response = await supabase
          .from('Grupo')
          .select()
          .eq('Clave_grupo', claveGrupo)
          .single();

      return GrupoModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo grupo: $e');
      return null;
    }
  }

  static Future<List<GrupoModel>> getTodosLosGrupos() async {
    try {
      final response = await supabase.from('Grupo').select();

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((item) => GrupoModel.fromJson(item)).toList();
    } catch (e) {
      print('Error obteniendo grupos: $e');
      return [];
    }
  }
}