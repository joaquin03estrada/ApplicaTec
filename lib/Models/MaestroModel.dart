class MaestroModel {
  final String numControlMaestro;
  final String? nombre;
  final String? apPater;
  final String? apMater;
  final String? departamento;

  MaestroModel({
    required this.numControlMaestro,
    this.nombre,
    this.apPater,
    this.apMater,
    this.departamento,
  });

  String get nombreCompleto {
    return '$nombre ${apPater ?? ''} ${apMater ?? ''}'.trim();
  }

  factory MaestroModel.fromJson(Map<String, dynamic> json) {
    return MaestroModel(
      numControlMaestro: json['num_control_maestro']?.toString() ?? '',
      nombre: json['nombre']?.toString(),
      apPater: json['ap_pater']?.toString(),
      apMater: json['ap_mater']?.toString(),
      departamento: json['departamento']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num_control_maestro': numControlMaestro,
      'nombre': nombre,
      'ap_pater': apPater,
      'ap_mater': apMater,
      'departamento': departamento,
    };
  }
}