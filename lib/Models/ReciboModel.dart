class ReciboModel {
  final int idRecibo;
  final String? descripcion;
  final DateTime? emision;
  final DateTime? vigencia;
  final double? importe;
  final String? estado;
  final String? numControl;
  final String? periodoRecibo;

  ReciboModel({
    required this.idRecibo,
    this.descripcion,
    this.emision,
    this.vigencia,
    this.importe,
    this.estado,
    this.numControl,
    this.periodoRecibo,
  });

  bool get isPaid {
    if (estado == null) return false;
    final estadoLower = estado!.toLowerCase();
    return estadoLower == 'cubierto' || estadoLower == 'pagado';
  }

  factory ReciboModel.fromJson(Map<String, dynamic> json) {
    return ReciboModel(
      idRecibo: json['id_recibo'],
      descripcion: json['descripcion']?.toString(),
      emision: json['emision'] != null ? DateTime.parse(json['emision']) : null,
      vigencia: json['vigencia'] != null ? DateTime.parse(json['vigencia']) : null,
      importe: json['importe'] != null ? double.tryParse(json['importe'].toString()) : null,
      estado: json['estado']?.toString(),
      numControl: json['num_control']?.toString(),
      periodoRecibo: json['periodo_recibo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_recibo': idRecibo,
      'descripcion': descripcion,
      'emision': emision?.toIso8601String().split('T')[0],
      'vigencia': vigencia?.toIso8601String().split('T')[0],
      'importe': importe,
      'estado': estado,
      'num_control': numControl,
      'periodo_recibo': periodoRecibo,
    };
  }
}