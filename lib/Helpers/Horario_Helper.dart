import 'package:flutter/material.dart';


class Materia {
  final String id; 
  final String nombreCorto;
  final String nombreLargo;
  final String carrera;
  final String clave;
  final String docente;
  final String aula;
  final String paquete;
  final String horario;
  final Color color;

  Materia({
    required this.id,
    required this.nombreCorto,
    required this.nombreLargo,
    required this.carrera,
    required this.clave,
    required this.docente,
    required this.aula,
    required this.paquete,
    required this.color,
    required this.horario,
  });
}

final List<Materia> materias = [
  Materia(
    id: "pru",
    nombreCorto: "PRU",
    carrera: "ING. SIST. COMP.",
    nombreLargo: "PRUEBAS DE SOFTWARE",
    clave: "ISC2102",
    docente: "MARIA DEL ROSARIO GONZALEZ ALVAREZ",
    aula: "EB03",
    paquete: "07A",
    horario: "08:00-09:00",
    color: Colors.pink[200]!,

  ),
  Materia(
    id: "sis_ope",
    nombreCorto: "SIS OPE",
    nombreLargo: "SISTEMAS OPERATIVOS",
    carrera: "ING. SIST. COMP.",
    clave: "AEC1061",
    docente: "EDGAR CERVANTES LOPEZ",
    aula: "CC01",
    paquete: "05A",
    horario: "09:00-10:00",
    color: Colors.blue[200]!,
  ),
  Materia(
    id: "tal_deinv_ii",
    nombreCorto: "TAL DEINV II",
    nombreLargo: "TALLER DE INVESTIGACION II",
    carrera: "ING. SIST. COMP.",
    clave: "ACA0910",
    docente: "MARIA ARACELY MARTINEZ AMAYA",
    aula: "EB02",
    paquete: "08B",
    horario: "10:00-11:00",
    color: Colors.lightBlue[200]!,
  ),
  Materia(
    id: "adm_dered",
    nombreCorto: "ADM DERED",
    nombreLargo: "ADMINISTRACION DE REDES",
    carrera: "ING. SIST. COMP.",
    clave: "SCA1002",
    docente: "EDGAR CERVANTES LOPEZ",
    aula: "CCDS",
    paquete: "08C",
    horario: "11:00-12:00",
    color: Colors.orange[200]!,
  ),
  Materia(
    id: "met_agi",
    nombreCorto: "MET AGI",
    nombreLargo: "METODOS AGILES",
    carrera: "ING. SIST. COMP.",
    clave: "ISC2103",
    docente: "RICARDO RAFAEL QUINTERO MEZA",
    aula: "EB01",
    paquete: "08B",
    horario: "12:00-13:00",
    color: Colors.lightGreen[200]!,
  ),
];

final List<String> dias = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"];
final List<String> horas = [
  "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00"
];

// Jala por el id de la materia
final List<List<String?>> horarioMap = [
  // 08:00
  ["pru", "pru", "pru", "pru", null, null, null],
  // 09:00
  ["sis_ope", "sis_ope", "sis_ope", "sis_ope", null, null, null],
  // 10:00
  ["tal_deinv_ii", "tal_deinv_ii", "tal_deinv_ii", "tal_deinv_ii", null, null, null],
  // 11:00
  ["adm_dered", "adm_dered", "adm_dered", "adm_dered", null, null, null],
  // 12:00
  ["met_agi", "met_agi", "met_agi", "met_agi", null, null, null],
  // 13:00 - 17:00 (vacío)
  [null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null],
];

class HorarioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      for (var i = 1; i <= dias.length; i++) i: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hora", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ...dias.map((d) => TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(d, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              )),
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
                              final materiaId = horarioMap[h][d];
                              final materiaObj = materiaId != null
                                  ? materias.firstWhere((m) => m.id == materiaId)
                                  : null;
                              if (materiaObj != null) {
                                return TableCell(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => DetalleMateriaDialog(
                                          materia: materiaObj,
                                          horario: "${horas[h]}-${_finHora(horas[h])}",
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: materiaObj.color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          materiaObj.nombreCorto,
                                          style: TextStyle(fontWeight: FontWeight.bold),
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

  // Helper para calcular el fin de la hora
  String _finHora(String inicio) {
    final parts = inicio.split(":").map(int.parse).toList();
    int h = parts[0] + 1;
    return "${h.toString().padLeft(2, '0')}:${parts[1].toString().padLeft(2, '0')}";
  }
}

class DetalleMateriaDialog extends StatelessWidget {
  final Materia materia;
  final String horario;

  const DetalleMateriaDialog({required this.materia, required this.horario});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Detalles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: materia.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      materia.nombreCorto,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(materia.nombreLargo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        SizedBox(height: 2),
                        Text("Clave: ${materia.clave}", style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Text("Docente", style: TextStyle(fontWeight: FontWeight.w500)),
              Text(materia.docente),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aula", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(materia.aula),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Paquete", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(materia.paquete),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text("Horario", style: TextStyle(fontWeight: FontWeight.w500)),
              Text(horario),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}