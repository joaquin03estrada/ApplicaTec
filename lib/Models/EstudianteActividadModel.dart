import 'package:applicatec/models/ActividadComplementariaModel.dart';

class EstudianteActividadModel {
  final String numControl;
  final String? periodo;
  final String? calificacion;
  final String? claveAct;

  final ActividadComplementariaModel? actividad;

  EstudianteActividadModel({
    required this.numControl,
    this.periodo,
    this.calificacion,
    this.claveAct,
    this.actividad,
  });

  factory EstudianteActividadModel.fromJson(Map<String, dynamic> json) {
    return EstudianteActividadModel(
      numControl: json['num_control']?.toString() ?? '',
      periodo: json['periodo']?.toString(),
      calificacion: json['calificacion']?.toString(),
      claveAct: json['clave_act']?.toString(),
      actividad: json['Actividades_Complementarias'] != null
          ? ActividadComplementariaModel.fromJson(
              json['Actividades_Complementarias'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num_control': numControl,
      'periodo': periodo,
      'calificacion': calificacion,
      'clave_act': claveAct,
    };
  }

  bool get aprobada {
    if (calificacion == null) return false;
    final calificacionUpper = calificacion!.toUpperCase();
    return calificacionUpper == 'APROBADA' ||
        calificacionUpper == 'AC' ||
        calificacionUpper == 'A';
  }
}