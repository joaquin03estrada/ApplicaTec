import 'package:flutter/material.dart';
import 'package:applicatec/Models/AvanceCicloModel.dart';
import 'package:applicatec/models/MateriaModel.dart';
import 'package:applicatec/services/AvanceCicloService.dart';
import 'package:applicatec/services/MateriaService.dart';
import 'package:applicatec/Helpers/materia_card_widget.dart';

class AvanceAcademicoView extends StatefulWidget {
  final String numControl;

  const AvanceAcademicoView({
    Key? key,
    required this.numControl,
  }) : super(key: key);

  @override
  State<AvanceAcademicoView> createState() => _AvanceAcademicoViewState();
}

class _AvanceAcademicoViewState extends State<AvanceAcademicoView> {
  AvanceCicloModel? _avance;
  Map<String, MateriaModel> _materiasInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      print('[AvanceAcademicoView] Cargando avance para: ${widget.numControl}');
      
      final avance = await AvanceCicloService.getAvancePorEstudiante(
        widget.numControl,
      );

      print('[AvanceAcademicoView] Avance recibido: ${avance != null ? "SI" : "NO"}');
      
      if (avance != null) {
        print('[AvanceAcademicoView] Total periodos: ${avance.periodos.length}');
        
        Set<String> claves = {};
        avance.periodos.forEach((periodo, materias) {
          for (var materia in materias) {
            claves.add(materia.clave);
          }
        });

        print('[AvanceAcademicoView] Total claves únicas: ${claves.length}');

        // Intentar cargar información de materias
        Map<String, MateriaModel> materiasMap = {};
        for (var clave in claves) {
          final materia = await MateriaService.getMateriaPorClave(clave);
          if (materia != null) {
            materiasMap[clave] = materia;
          }
        }

        print('[AvanceAcademicoView] Total materias con info completa: ${materiasMap.length}');

        setState(() {
          _avance = avance;
          _materiasInfo = materiasMap;
          _isLoading = false;
        });
      } else {
        print('[AvanceAcademicoView] No se obtuvo avance');
        setState(() => _isLoading = false);
      }
    } catch (e, stackTrace) {
      print('[AvanceAcademicoView] Error: $e');
      print('[AvanceAcademicoView] StackTrace: $stackTrace');
      setState(() => _isLoading = false);
    }
  }

  // Organizar materias por semestre
  Map<int, List<MateriaCursadaModel>> _organizarPorSemestre() {
    if (_avance == null) return {};

    Map<int, List<MateriaCursadaModel>> materiasPorSemestre = {};

    for (int i = 1; i <= 9; i++) {
      materiasPorSemestre[i] = [];
    }

    _avance!.periodos.forEach((periodo, materias) {
      for (var materiaCursada in materias) {
        final materiaInfo = _materiasInfo[materiaCursada.clave];
        
        if (materiaInfo != null && materiaInfo.semestre != null) {
          final semestre = materiaInfo.semestre!;
          if (semestre >= 1 && semestre <= 9) {
            materiasPorSemestre[semestre]!.add(materiaCursada);
          }
        } else {
          final semestreInferido = _inferirSemestreDesdeClaveOPeriodo(
            materiaCursada.clave,
            periodo,
          );
          if (semestreInferido != null && semestreInferido >= 1 && semestreInferido <= 9) {
            materiasPorSemestre[semestreInferido]!.add(materiaCursada);
          }
        }
      }
    });

    return materiasPorSemestre;
  }

  int? _inferirSemestreDesdeClaveOPeriodo(String clave, String periodo) {
    if (clave == 'ACOM1') return 1;
    if (clave == 'SERV1') return 7;
    if (clave == 'RESSIST') return 9;
    
    final mapaPeriodo = {
      '2021-AGO-DIC': 1,
      '2022-ENE-JUN': 2,
      '2022-AGO-DIC': 3,
      '2023-ENE-JUN': 4,
      '2023-AGO-DIC': 5,
      '2024-ENE-JUN': 6,
      '2024-AGO-DIC': 7,
      '2025-ENE-JUN': 8,
      'VERANO 2025': 8,
      '2025-AGO-DIC': 9,
    };
    
    return mapaPeriodo[periodo];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Color(0xFF1a365d)),
        ),
      );
    }

    if (_avance == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No se encontró información de avance académico',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final materiasPorSemestre = _organizarPorSemestre();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leyenda de colores
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLeyendaItem('Aprobado', Color(0xFFB8E6B8)),
                      SizedBox(width: 16),
                      _buildLeyendaItem('Cursando', Color(0xFFFFF4B8)),
                      SizedBox(width: 16),
                      _buildLeyendaItem('Reprobado', Color(0xFFFFB8B8)),
                      SizedBox(width: 16),
                      _buildLeyendaItem('No Cursado', Color(0xFFE0E0E0)),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Grid de materias organizadas por semestre (sin encabezados)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(9, (index) {
                      final semestre = index + 1;
                      final materias = materiasPorSemestre[semestre] ?? [];

                      // Si el semestre no tiene materias, no mostrar la columna
                      if (materias.isEmpty) return SizedBox.shrink();

                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: materias.map((materiaCursada) {
                            final materiaInfo = _materiasInfo[materiaCursada.clave];
                            
                            String nombreMostrar = materiaCursada.clave;
                            if (materiaInfo != null) {
                              nombreMostrar = materiaInfo.nombreMatCorto ?? 
                                             materiaInfo.nombreMat;
                            }
                            
                            return Container(
                              width: 140,
                              margin: EdgeInsets.only(bottom: 12),
                              child: MateriaCardWidget(
                                claveMat: materiaCursada.clave,
                                nombreMat: nombreMostrar,
                                calificacion: materiaCursada.calificacion,
                                estatus: materiaCursada.estatus,
                                creditos: materiaInfo?.creditos,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeyendaItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}