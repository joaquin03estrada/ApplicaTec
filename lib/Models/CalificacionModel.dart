import 'package:applicatec/models/ClaseModel.dart';

class CalificacionModel {
  final int idCalificacion;
  final int idClase;
  final String numControl;
  final String unidad;
  final double? calificacion;
  final double? califFinal;
  
  final ClaseModel? clase;

  CalificacionModel({
    required this.idCalificacion,
    required this.idClase,
    required this.numControl,
    required this.unidad,
    this.calificacion,
    this.califFinal,
    this.clase,
  });

  bool get isAprobada {
    if (calificacion == null) return false;
    return calificacion! >= 70;
  }

  String get calificacionDisplay {
    if (calificacion == null || calificacion == 0) {
      return "0 - NC";
    }
    return calificacion! >= 70 
        ? "${calificacion!.toInt()} - REG" 
        : "${calificacion!.toInt()} - NC";
  }

  factory CalificacionModel.fromJson(Map<String, dynamic> json) {
    return CalificacionModel(
      idCalificacion: json['id_calificacion'],
      idClase: json['id_clase'],
      numControl: json['num_control']?.toString() ?? '',
      unidad: json['unidad']?.toString() ?? '',
      calificacion: json['calificacion'] != null 
          ? double.tryParse(json['calificacion'].toString()) 
          : null,
      califFinal: json['calif_final'] != null 
          ? double.tryParse(json['calif_final'].toString()) 
          : null,
      clase: json['Clase'] != null 
          ? ClaseModel.fromJson(json['Clase']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_calificacion': idCalificacion,
      'id_clase': idClase,
      'num_control': numControl,
      'unidad': unidad,
      'calificacion': calificacion,
      'calif_final': califFinal,
    };
  }
}