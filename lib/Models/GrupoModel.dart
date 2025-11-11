class GrupoModel {
  final String claveGrupo;
  final String aula;

  GrupoModel({
    required this.claveGrupo,
    required this.aula,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      claveGrupo: json['Clave_grupo']?.toString() ?? '',
      aula: json['Aula']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Clave_grupo': claveGrupo,
      'Aula': aula,
    };
  }
}