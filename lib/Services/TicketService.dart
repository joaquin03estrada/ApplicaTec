import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicatec/Models/TicketModel.dart';

class TicketService {
  static final supabase = Supabase.instance.client;

  // Obtener todos los tickets de un estudiante
  static Future<List<TicketModel>> getTicketsPorEstudiante(String numControl) async {
    try {
      final response = await supabase
          .from('Tickets')
          .select()
          .eq('num_control', numControl)
          .order('fecha_emision', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => TicketModel.fromJson(item))
          .toList();
    } catch (e) {
      print('[TicketService] Error obteniendo tickets: $e');
      return [];
    }
  }

  // Obtener tickets abiertos (estatus PENDIENTE - tickets no resueltos)
  static Future<List<TicketModel>> getTicketsAbiertos(String numControl) async {
    try {
      final response = await supabase
          .from('Tickets')
          .select()
          .eq('num_control', numControl)
          .eq('Estatus', 'PENDIENTE')  //  Cambiado a PENDIENTE
          .order('fecha_emision', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => TicketModel.fromJson(item))
          .toList();
    } catch (e) {
      print('[TicketService] Error obteniendo tickets abiertos: $e');
      return [];
    }
  }

  // Obtener tickets finalizados (estatus RESUELTO)
  static Future<List<TicketModel>> getTicketsFinalizados(String numControl) async {
    try {
      final response = await supabase
          .from('Tickets')
          .select()
          .eq('num_control', numControl)
          .eq('Estatus', 'RESUELTO')
          .order('fecha_emision', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) => TicketModel.fromJson(item))
          .toList();
    } catch (e) {
      print('[TicketService] Error obteniendo tickets finalizados: $e');
      return [];
    }
  }

  // Crear un nuevo ticket
  static Future<bool> crearTicket({
    required String numControl,
    required String descripcion,
  }) async {
    try {
      print('[TicketService] Creando ticket para: $numControl');
      print('[TicketService] Descripción: $descripcion');
      
      await supabase.from('Tickets').insert({
        'num_control': numControl,
        'descripcion': descripcion,
        'fecha_emision': DateTime.now().toIso8601String().split('T')[0], // Solo fecha YYYY-MM-DD
        'Estatus': 'PENDIENTE',  //  Cambiado a PENDIENTE
      });

      print('[TicketService] Ticket creado exitosamente');
      return true;
    } catch (e) {
      print('[TicketService] Error creando ticket: $e');
      return false;
    }
  }

  // Actualizar un ticket
  static Future<bool> actualizarTicket({
    required int idTicket,
    String? descripcion,
    String? estatus,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      if (descripcion != null) updates['descripcion'] = descripcion;
      if (estatus != null) updates['Estatus'] = estatus;

      if (updates.isEmpty) return false;

      await supabase
          .from('Tickets')
          .update(updates)
          .eq('id_ticket', idTicket);

      return true;
    } catch (e) {
      print('[TicketService] Error actualizando ticket: $e');
      return false;
    }
  }

  // Eliminar un ticket (opcional)
  static Future<bool> eliminarTicket(int idTicket) async {
    try {
      await supabase
          .from('Tickets')
          .delete()
          .eq('id_ticket', idTicket);

      return true;
    } catch (e) {
      print('[TicketService] Error eliminando ticket: $e');
      return false;
    }
  }
}