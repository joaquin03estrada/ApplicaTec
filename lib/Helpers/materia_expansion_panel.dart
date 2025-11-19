import 'package:flutter/material.dart';

class MateriaPanelData { 
  final String titulo;
  final String materia;
  final String docente;
  final String creditos;
  final String grupo;
  final String clave;
  final List<String> dias;
  final List<String> horarios; // ["10:00 - 11:00 EB02", ...]
  final List<String> califTitulos; // ["U01", "U02", ...]
  final List<String> califValores; // ["0 - NC", ...]

  MateriaPanelData({
    required this.titulo,
    required this.materia,
    required this.docente,
    required this.creditos,
    required this.grupo,
    required this.clave,
    required this.dias,
    required this.horarios,
    required this.califTitulos,
    required this.califValores,
  });
}

class MateriaExpansionPanel extends StatefulWidget {
  final MateriaPanelData data;

  const MateriaExpansionPanel({Key? key, required this.data}) : super(key: key);

  @override
  State<MateriaExpansionPanel> createState() => _MateriaExpansionPanelState();
}

class _MateriaExpansionPanelState extends State<MateriaExpansionPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _expanded = !_expanded;
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _expanded,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Text(
                  d.titulo,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Color(0xff1b3a6b),
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Datos Generales
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.grey[800]),
                      SizedBox(width: 8),
                      Text(
                        "Datos Generales",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Materia: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${d.materia}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Docente: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${d.docente}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),

                  Text(
                    "Créditos: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${d.creditos}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Grupo: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${d.grupo}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Clave: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${d.clave}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  // Horario
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[800]),
                      SizedBox(width: 8),
                      Text(
                        "Horario",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // horario
                  for (int i = 0; i < d.dias.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              d.dias[i],
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              d.horarios[i],
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24),
                  Divider(thickness: 1, height: 1),
                  SizedBox(height: 24),
                  // Calificaciones
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Colors.grey[100]),
                      SizedBox(width: 8),
                      Text(
                        "Calificaciones",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  for (int i = 0; i < d.califTitulos.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              d.califTitulos[i],
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 14),
                          Builder(
                            builder: (context) {
                              final rawCalif = d.califValores[i];
                              final numCalif = int.tryParse(rawCalif) ?? 0;

                              String display;
                              Color bgColor;

                              if (numCalif == 0) {
                                display = "$numCalif - NC";
                                bgColor = Colors.grey.shade300; 
                              } else if (numCalif >= 70) {
                                display = "$numCalif - REG";
                                bgColor =
                                    Colors.greenAccent.shade100; // verde claro
                              } else {
                                display = "$numCalif - NC";
                                bgColor =
                                    Colors.redAccent.shade100; // rojo claro
                              }

                              return Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  display,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
