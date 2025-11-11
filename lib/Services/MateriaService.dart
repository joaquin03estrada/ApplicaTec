import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/MateriaModel.dart';

class MateriaService {
  static final supabase = Supabase.instance.client;

  static Future<MateriaModel?> getMateriaPorClave(String claveMat) async {
    try {
      final response = await supabase
          .from('Materia')
          .select()
          .eq('clave_mat', claveMat)
          .single();

      return MateriaModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo materia: $e');
      return null;
    }
  }

  static Future<List<MateriaModel>> getMateriasPorCarrera(String claveCarrera) async {
    try {
      final response = await supabase
          .from('Materia')
          .select()
          .eq('clave_carrera', claveCarrera);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((item) => MateriaModel.fromJson(item)).toList();
    } catch (e) {
      print('Error obteniendo materias por carrera: $e');
      return [];
    }
  }

  static Future<List<MateriaModel>> getTodasLasMaterias() async {
    try {
      final response = await supabase.from('Materia').select();

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((item) => MateriaModel.fromJson(item)).toList();
    } catch (e) {
      print('Error obteniendo materias: $e');
      return [];
    }
  }
}