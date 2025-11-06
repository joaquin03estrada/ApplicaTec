class AlumnoModel {
  final String numControl;
  final String nombre;
  final String apPat;
  final String apMat;
  final int? semestre;
  final DateTime? fechaIngreso;
  final DateTime? fechaEgreso;
  final String situacion;
  final String especialidad;
  final String celular;
  final String curp;
  final String ciudad;
  final String colonia;
  final String calle;
  final String codigoPostal;
  final DateTime? fechaNacimiento;
  final String correoInstitucional;
  final String correoPersonal;
  final double? promedioConReprobadas;
  final double? promedioSinReprobadas;
  final int? creditosAcumulados;
  final String periodoIngreso;
  final String? claveCarrera;
  final String? nombreCarrera;

  AlumnoModel({
    required this.numControl,
    required this.nombre,
    required this.apPat,
    required this.apMat,
    this.semestre,
    this.fechaIngreso,
    this.fechaEgreso,
    required this.situacion,
    required this.especialidad,
    required this.celular,
    required this.curp,
    required this.ciudad,
    required this.colonia,
    required this.calle,
    required this.codigoPostal,
    this.fechaNacimiento,
    required this.correoInstitucional,
    required this.correoPersonal,
    this.promedioConReprobadas,
    this.promedioSinReprobadas,
    this.creditosAcumulados,
    required this.periodoIngreso,
    this.claveCarrera,
    this.nombreCarrera,
  });

  String get nombreCompleto {
    return '$nombre ${apPat.isNotEmpty ? apPat : ''} ${apMat.isNotEmpty ? apMat : ''}'
        .trim();
  }


  factory AlumnoModel.fromJson(Map<String, dynamic> json) {
    final carreraData = json['Carrera'];
    
    return AlumnoModel(
      numControl: json['num_control']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      apPat: json['ap_pat']?.toString() ?? '',
      apMat: json['ap_mat']?.toString() ?? '',
      semestre: json['semestre'],
      fechaIngreso: json['fecha_ingreso'] != null
          ? DateTime.parse(json['fecha_ingreso'])
          : null,
      fechaEgreso: json['fecha_egreso'] != null
          ? DateTime.parse(json['fecha_egreso'])
          : null,
      situacion: json['situacion']?.toString() ?? 'Vigente',
      especialidad: json['especialidad']?.toString() ?? '',
      celular: json['celular']?.toString() ?? '',
      curp: json['curp']?.toString() ?? '',
      ciudad: json['ciudad']?.toString() ?? '',
      colonia: json['colonia']?.toString() ?? '',
      calle: json['calle']?.toString() ?? '',
      codigoPostal: json['CP']?.toString() ?? '',
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'])
          : null,
      correoInstitucional: json['correo_insti']?.toString() ?? '',
      correoPersonal: json['correo_perso']?.toString() ?? '',
      promedioConReprobadas: json['prom_con_repro'] != null
          ? double.parse(json['prom_con_repro'].toString())
          : null,
      promedioSinReprobadas: json['prom_sin_repro'] != null
          ? double.parse(json['prom_sin_repro'].toString())
          : null,
      creditosAcumulados: json['creditos_acumulados'],
      periodoIngreso: json['periodo_ingreso']?.toString() ?? '',
      claveCarrera: json['carrera']?.toString(),
      nombreCarrera: carreraData != null 
          ? carreraData['nom_carrera']?.toString()
          : null,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'num_control': numControl,
      'nombre': nombre,
      'ap_pat': apPat,
      'ap_mat': apMat,
      'semestre': semestre,
      'fecha_ingreso': fechaIngreso?.toIso8601String(),
      'fecha_egreso': fechaEgreso?.toIso8601String(),
      'situacion': situacion,
      'especialidad': especialidad,
      'celular': celular,
      'curp': curp,
      'ciudad': ciudad,
      'colonia': colonia,
      'calle': calle,
      'CP': codigoPostal,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'correo_insti': correoInstitucional,
      'correo_perso': correoPersonal,
      'prom_con_repro': promedioConReprobadas,
      'prom_sin_repro': promedioSinReprobadas,
      'creditos_acumulados': creditosAcumulados,
      'periodo_ingreso': periodoIngreso,
      'carrera': claveCarrera,
    };
  }
}