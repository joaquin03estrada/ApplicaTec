class ActividadComplementariaModel {
  final String claveAct;
  final String nombre;
  final int? creditos;
  final String? tipoActividad;

  ActividadComplementariaModel({
    required this.claveAct,
    required this.nombre,
    this.creditos,
    this.tipoActividad,
  });

  factory ActividadComplementariaModel.fromJson(Map<String, dynamic> json) {
    return ActividadComplementariaModel(
      claveAct: json['clave_act']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      creditos: json['creditos'],
      tipoActividad: json['tipo_actividad']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clave_act': claveAct,
      'nombre': nombre,
      'creditos': creditos,
      'tipo_actividad': tipoActividad,
    };
  }
}