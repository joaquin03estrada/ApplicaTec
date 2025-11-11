class MateriaModel {
  final String claveMat;
  final String nombreMat;
  final String? tipoMat;
  final int? creditos;
  final String? claveCarrera;
  final int? semestre;
  final String? nombreMatCorto;

  MateriaModel({
    required this.claveMat,
    required this.nombreMat,
    this.tipoMat,
    this.creditos,
    this.claveCarrera,
    this.semestre,
    this.nombreMatCorto,
  });

  String get nombreCorto => nombreMatCorto ?? claveMat;

  factory MateriaModel.fromJson(Map<String, dynamic> json) {
    return MateriaModel(
      claveMat: json['clave_mat']?.toString() ?? '',
      nombreMat: json['nombre_mat']?.toString() ?? '',
      tipoMat: json['tipo_mat']?.toString(),
      creditos: json['creditos'],
      claveCarrera: json['clave_carrera']?.toString(),
      semestre: json['semestre'],
      nombreMatCorto: json['nombre_mat_corto']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clave_mat': claveMat,
      'nombre_mat': nombreMat,
      'tipo_mat': tipoMat,
      'creditos': creditos,
      'clave_carrera': claveCarrera,
      'semestre': semestre,
      'nombre_mat_corto': nombreMatCorto,
    };
  }
}