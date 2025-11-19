import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/models/ReciboModel.dart';

class ReciboService {
  static final supabase = Supabase.instance.client;

  static Future<List<ReciboModel>> getRecibosPorEstudiante(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('Recibos')
          .select()
          .eq('num_control', numControl)
          .order('emision', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => ReciboModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo recibos del estudiante: $e');
      return [];
    }
  }

  static Future<ReciboModel?> getReciboMasReciente(String numControl) async {
    try {
      final response = await supabase
          .from('Recibos')
          .select()
          .eq('num_control', numControl)
          .order('emision', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return ReciboModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo recibo más reciente: $e');
      return null;
    }
  }

  static Future<List<ReciboModel>> getRecibosPendientes(
    String numControl,
  ) async {
    try {
      final response = await supabase
          .from('Recibos')
          .select()
          .eq('num_control', numControl)
          .eq('estado', 'pendiente')
          .order('vigencia', ascending: true);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => ReciboModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error obteniendo recibos pendientes: $e');
      return [];
    }
  }

  static Future<ReciboModel?> getReciboPorId(int idRecibo) async {
    try {
      final response = await supabase
          .from('Recibos')
          .select()
          .eq('id_recibo', idRecibo)
          .single();

      return ReciboModel.fromJson(response);
    } catch (e) {
      print('Error obteniendo recibo por ID: $e');
      return null;
    }
  }

  static Future<bool> actualizarEstadoRecibo(
    int idRecibo,
    String nuevoEstado,
  ) async {
    try {
      await supabase
          .from('Recibos')
          .update({'estado': nuevoEstado})
          .eq('id_recibo', idRecibo);
      return true;
    } catch (e) {
      print('Error actualizando estado del recibo: $e');
      return false;
    }
  }
}