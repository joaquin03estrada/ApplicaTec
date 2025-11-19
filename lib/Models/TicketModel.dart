import 'package:applicatec/Helpers/TicketsView.dart';

class TicketModel {
  final int idTicket;
  final String descripcion;
  final DateTime? fechaEmision;
  final String? numControl;
  final String? comentario;
  final String estatus; 

  TicketModel({
    required this.idTicket,
    required this.descripcion,
    this.fechaEmision,
    this.numControl,
    this.comentario,
    required this.estatus,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      idTicket: json['id_ticket'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      fechaEmision: json['fecha_emision'] != null 
          ? DateTime.parse(json['fecha_emision']) 
          : null,
      numControl: json['num_control']?.toString(),
      comentario: json['Comentario']?.toString(),
      estatus: json['Estatus'] ?? 'PENDIENTE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ticket': idTicket,
      'descripcion': descripcion,
      'fecha_emision': fechaEmision?.toIso8601String(),
      'num_control': numControl,
      'Comentario': comentario,
      'Estatus': estatus,
    };
  }

  // Para convertir al formato que usa la vista
  Ticket toTicket() {
    return Ticket(
      fecha: fechaEmision != null 
          ? '${fechaEmision!.day.toString().padLeft(2, '0')}/${fechaEmision!.month.toString().padLeft(2, '0')}/${fechaEmision!.year}'
          : 'N/A',
      clave: 'T${idTicket.toString().padLeft(4, '0')}',
      descripcion: descripcion,
      estatus: estatus,
      comentario: comentario,
    );
  }
}