import 'dart:convert';

class MateriaCursadaModel {
  final String clave;
  final String estatus;
  final int? calificacion;

  MateriaCursadaModel({
    required this.clave,
    required this.estatus,
    this.calificacion,
  });

  factory MateriaCursadaModel.fromJson(Map<String, dynamic> json) {
    return MateriaCursadaModel(
      clave: json['clave']?.toString() ?? '',
      estatus: json['estatus']?.toString() ?? 'No Cursado',
      calificacion: json['calificacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clave': clave,
      'estatus': estatus,
      'calificacion': calificacion,
    };
  }
}

class AvanceCicloModel {
  final String numControl;
  final Map<String, List<MateriaCursadaModel>> periodos;

  AvanceCicloModel({
    required this.numControl,
    required this.periodos,
  });

  factory AvanceCicloModel.fromJson(Map<String, dynamic> json) {
    print('[AvanceCicloModel] JSON completo: $json');
    
    Map<String, List<MateriaCursadaModel>> periodosMap = {};

    // El campo 'periodo' contiene otro objeto con 'periodos' dentro
    final periodoData = json['periodo'];
    print('[AvanceCicloModel] periodoData tipo: ${periodoData.runtimeType}');

    if (periodoData != null) {
      // Si es String, parsearlo
      dynamic parsedData = periodoData;
      if (periodoData is String) {
        try {
          parsedData = jsonDecode(periodoData);
        } catch (e) {
          print('[AvanceCicloModel] Error parseando JSON: $e');
          return AvanceCicloModel(
            numControl: json['num_control']?.toString() ?? '',
            periodos: {},
          );
        }
      }

      // Acceder al campo 'periodos' dentro del objeto
      final periodosData = parsedData is Map ? parsedData['periodos'] : null;
      print('[AvanceCicloModel] periodosData encontrado: ${periodosData != null}');

      if (periodosData != null && periodosData is Map) {
        periodosData.forEach((key, value) {
          print('[AvanceCicloModel] Procesando periodo: $key');
          if (value is List) {
            try {
              periodosMap[key.toString()] = (value as List)
                  .map((item) {
                    if (item is Map<String, dynamic>) {
                      return MateriaCursadaModel.fromJson(item);
                    } else {
                      print('[AvanceCicloModel] Item no es Map: $item');
                      return null;
                    }
                  })
                  .whereType<MateriaCursadaModel>() // Filtrar nulls
                  .toList();
              print('[AvanceCicloModel] Materias en $key: ${periodosMap[key]!.length}');
            } catch (e) {
              print('[AvanceCicloModel] Error procesando periodo $key: $e');
            }
          }
        });
      }
    }

    print('[AvanceCicloModel] Total periodos procesados: ${periodosMap.length}');
    int totalMaterias = 0;
    periodosMap.forEach((key, value) {
      totalMaterias += value.length;
      print('[AvanceCicloModel] Periodo $key: ${value.length} materias');
    });
    print('[AvanceCicloModel] Total materias: $totalMaterias');

    return AvanceCicloModel(
      numControl: json['num_control']?.toString() ?? '',
      periodos: periodosMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> periodosJson = {};
    periodos.forEach((key, value) {
      periodosJson[key] = value.map((m) => m.toJson()).toList();
    });

    return {
      'num_control': numControl,
      'periodo': {
        'num_control': numControl,
        'periodos': periodosJson,
      },
    };
  }

  List<MateriaCursadaModel> getMateriasPorEstatus(String estatus) {
    List<MateriaCursadaModel> materias = [];
    periodos.forEach((periodo, listaMaterias) {
      materias.addAll(
        listaMaterias.where((m) => m.estatus == estatus),
      );
    });
    return materias;
  }

  List<MateriaCursadaModel> getMateriasPorPeriodo(String periodo) {
    return periodos[periodo] ?? [];
  }

  MateriaCursadaModel? getMateriaPorClave(String clave) {
    for (var listaMaterias in periodos.values) {
      for (var materia in listaMaterias) {
        if (materia.clave == clave) {
          return materia;
        }
      }
    }
    return null;
  }
}