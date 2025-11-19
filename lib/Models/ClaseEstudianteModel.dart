import 'package:applicatec/models/ClaseModel.dart';

class ClaseEstudianteModel {
  final String numControl;
  final String idClase;

  final ClaseModel? clase;

  ClaseEstudianteModel({
    required this.numControl,
    required this.idClase,
    this.clase,
  });

  factory ClaseEstudianteModel.fromJson(Map<String, dynamic> json) {
    return ClaseEstudianteModel(
      numControl: json['num_control']?.toString() ?? '',
      idClase: json['id_clase']?.toString() ?? '',
      clase: json['Clase'] != null ? ClaseModel.fromJson(json['Clase']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num_control': numControl,
      'id_clase': idClase,
    };
  }
}