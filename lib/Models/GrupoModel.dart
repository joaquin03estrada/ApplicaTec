class GrupoModel {
  final String claveGrupo;
  final String aula;

  GrupoModel({
    required this.claveGrupo,
    required this.aula,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    print('[GrupoModel] JSON recibido: $json');
    
    final grupo = GrupoModel(
      claveGrupo: json['clave_grupo']?.toString() ?? '',  
      aula: json['aula']?.toString() ?? '',  
    );
    
    print('[GrupoModel] Parseado - Clave: ${grupo.claveGrupo}, Aula: ${grupo.aula}');
    
    return grupo;
  }

  Map<String, dynamic> toJson() {
    return {
      'clave_grupo': claveGrupo,  
      'aula': aula,  
    };
  }
}