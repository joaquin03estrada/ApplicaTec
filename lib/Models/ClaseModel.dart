import 'package:applicatec/Models/GrupoModel.dart';
import 'package:applicatec/Models/MaestroModel.dart';
import 'package:applicatec/Models/MateriaModel.dart';

class ClaseModel {
  final String idClase;
  final String horarioInicio;
  final String? horarioFin;
  final String? claveGrupo;
  final String? claveMat;
  final String? numControlMaest;

  // Datos de relaciones (joins)
  final GrupoModel? grupo;
  final MateriaModel? materia;
  final MaestroModel? maestro;

  ClaseModel({
    required this.idClase,
    required this.horarioInicio,
    this.horarioFin,
    this.claveGrupo,
    this.claveMat,
    this.numControlMaest,
    this.grupo,
    this.materia,
    this.maestro,
  });

  factory ClaseModel.fromJson(Map<String, dynamic> json) {
    return ClaseModel(
      idClase: json['id_Clase']?.toString() ?? '',
      horarioInicio: json['horario_inicio']?.toString() ?? '',
      horarioFin: json['horario_fin']?.toString(),
      claveGrupo: json['clave_grupo']?.toString(),
      claveMat: json['clave_mat']?.toString(),
      numControlMaest: json['num_control_maest']?.toString(),
      grupo: json['Grupo'] != null ? GrupoModel.fromJson(json['Grupo']) : null,
      materia: json['Materia'] != null ? MateriaModel.fromJson(json['Materia']) : null,
      maestro: json['Maestros'] != null ? MaestroModel.fromJson(json['Maestros']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Clase': idClase,
      'horario_inicio': horarioInicio,
      'horario_fin': horarioFin,
      'clave_grupo': claveGrupo,
      'clave_mat': claveMat,
      'num_control_maest': numControlMaest,
    };
  }
}