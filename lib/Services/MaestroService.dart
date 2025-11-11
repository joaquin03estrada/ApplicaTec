import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/MaestroModel.dart';

class MaestroService {
  static final supabase = Supabase.instance.client;

  static Future<MaestroModel?> getMaestroPorNumControl(String numControl) async {
    try {
      final response = await supabase
          .from('Maestros')
          .select()
          .eq('num_control_maestro', numControl)
          .single();

      return MaestroModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo maestro: $e');
      return null;
    }
  }

  static Future<List<MaestroModel>> getTodosLosMaestros() async {
    try {
      final response = await supabase.from('Maestros').select();

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((item) => MaestroModel.fromJson(item)).toList();
    } catch (e) {
      print('Error obteniendo maestros: $e');
      return [];
    }
  }
}