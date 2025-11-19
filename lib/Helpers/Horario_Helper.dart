import 'package:flutter/material.dart';
import 'package:applicatec/Models/ClaseModel.dart';
import 'package:applicatec/Services/ClaseService.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/constantes/salones_ubicaciones.dart';
import 'package:latlong2/latlong.dart';

final List<String> dias = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"];
final List<String> horas = [
  "07:00",
  "08:00",
  "09:00",
  "10:00",
  "11:00",
  "12:00",
  "13:00",
  "14:00",
  "15:00",
  "16:00",
  "17:00",
  "18:00",
  "19:00",
  "20:00",
];

final List<Color> coloresMaterias = [
  Colors.pink[200]!,
  Colors.blue[200]!,
  Colors.lightBlue[200]!,
  Colors.orange[200]!,
  Colors.lightGreen[200]!,
  Colors.purple[200]!,
  Colors.amber[200]!,
  Colors.teal[200]!,
  Colors.cyan[200]!,
  Colors.lime[200]!,
];

class HorarioWidget extends StatefulWidget {
  final String numControl;

  const HorarioWidget({Key? key, required this.numControl}) : super(key: key);

  @override
  State<HorarioWidget> createState() => _HorarioWidgetState();
}

class _HorarioWidgetState extends State<HorarioWidget> {
  List<ClaseModel> _clases = [];
  bool _isLoading = true;
  Map<String, Color> _coloresPorMateria = {};
  Map<String, ClaseModel> _horarioMap = {};

  @override
  void initState() {
    super.initState();
    _loadClases();
  }

  Future<void> _loadClases() async {
    try {
      setState(() => _isLoading = true);

      final clases = await ClaseService.getClasesPorEstudiante(
        widget.numControl,
      );

      _asignarColoresYOrganizar(clases.cast<ClaseModel>());

      setState(() {
        _clases = clases.cast<ClaseModel>();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando clases: $e');
      setState(() => _isLoading = false);
    }
  }

  void _asignarColoresYOrganizar(List<ClaseModel> clases) {
    int colorIndex = 0;

    for (var clase in clases) {
      final claveMat = clase.claveMat ?? '';

      if (!_coloresPorMateria.containsKey(claveMat)) {
        _coloresPorMateria[claveMat] =
            coloresMaterias[colorIndex % coloresMaterias.length];
        colorIndex++;
      }

      final horaInicio = clase.horarioInicio;
      final indexHora = horas.indexWhere((h) => horaInicio.startsWith(h));

      if (indexHora != -1) {
        final creditos = clase.materia?.creditos ?? 5;
        int diasAMostrar = 5; // Por defecto lunes a viernes

        if (creditos == 4) {
          diasAMostrar = 4; // Lunes a jueves
        } else if (creditos >= 5) {
          diasAMostrar = 5; // Lunes a viernes
        }

        for (int dia = 0; dia < diasAMostrar; dia++) {
          final key = '$dia-$indexHora';
          _horarioMap[key] = clase;
        }
      }
    }
  }

  ClaseModel? _getClaseEnHorario(int diaIndex, int horaIndex) {
    final key = '$diaIndex-$horaIndex';
    return _horarioMap[key];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xff1b3a6b)));
    }

    if (_clases.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tienes clases registradas',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900,
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.pending_actions_rounded, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Horario Semestral",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: {
                      0: FixedColumnWidth(70),
                      for (var i = 1; i <= dias.length; i++)
                        i: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Hora",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ...dias.map(
                            (d) => TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  d,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int h = 0; h < horas.length; h++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(horas[h]),
                              ),
                            ),
                            ...List.generate(dias.length, (d) {
                              final clase = _getClaseEnHorario(d, h);

                              if (clase != null && clase.materia != null) {
                                final nombreCorto = clase.materia!.nombreCorto;
                                final claveMat = clase.claveMat ?? '';
                                final color =
                                    _coloresPorMateria[claveMat] ??
                                    Colors.grey[300]!;

                                return TableCell(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => DetalleMateriaDialog(
                                              clase: clase,
                                            ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 4,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          nombreCorto,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return TableCell(child: SizedBox(height: 40));
                              }
                            }),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetalleMateriaDialog extends StatelessWidget {
  final ClaseModel clase;

  const DetalleMateriaDialog({Key? key, required this.clase}) : super(key: key);

  void _navigateToMap(BuildContext context, String aula) {

    if (salonesUbicaciones.containsKey(aula)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyMap(
            markerLocation: salonesUbicaciones[aula],
            markerLabel: aula,
            showDrawerBackButton: true,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Salón no encontrado'),
            ],
          ),
          content: Text('El salón "$aula" no se encuentra en el mapa.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Color(0xff1b3a6b)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final materia = clase.materia;
    final maestro = clase.maestro;
    final grupo = clase.grupo;

    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 400,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detalles",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],// Cambia el color algun dia
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        materia?.nombreCorto ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            materia?.nombreMat ?? 'Sin nombre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Clave: ${materia?.claveMat ?? 'N/A'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text(
                  "Docente",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(maestro?.nombreCompleto ?? 'Sin asignar'),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aula",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(grupo?.aula ?? 'N/A'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Grupo",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(grupo?.claveGrupo ?? 'N/A'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "Horario",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${clase.horarioInicio} - ${clase.horarioFin ?? "N/A"}',
                ),
                if (materia?.creditos != null) ...[
                  SizedBox(height: 12),
                  Text(
                    "Créditos",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('${materia!.creditos}'),
                ],
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final aula = grupo?.aula;
                      
                      if (aula == null || aula.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange),
                                SizedBox(width: 8),
                                Text('Sin información'),
                              ],
                            ),
                            content: Text('No se encontró información del aula para esta clase.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(
                                  'Aceptar',
                                  style: TextStyle(color: Color(0xff1b3a6b)),
                                ),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      
                      _navigateToMap(context, aula);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1b3a6b),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ver ubicación",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
