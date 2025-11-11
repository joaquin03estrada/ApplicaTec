import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:applicatec/Helpers/ChangePassword.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:applicatec/models/AlumnoModel.dart';
import 'package:applicatec/services/AlumnoService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:applicatec/Helpers/materia_expansion_panel.dart';

class Calificaciones extends StatefulWidget {
  final String numControl;

  const Calificaciones({Key? key, required this.numControl}) : super(key: key);
  @override
  State<Calificaciones> createState() => _CalificacionesState();
}

class _CalificacionesState extends State<Calificaciones> {
  AlumnoModel? _alumnoData;
  bool _isLoading = true;
  String? _errorMessage;

  int myIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlumnoData();
  }

  Future<void> _loadAlumnoData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final alumno = await AlumnoService.getAlumnoByNumControl(
        widget.numControl,
      );

      if (alumno != null) {
        setState(() {
          _alumnoData = alumno;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No se encontraron datos para el número de control';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: ${e.toString()}';
      });
    }
  }

  late final List<Widget> widgetsList = [
    SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.feed_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Impresión de boleta",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: "Periodo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "periodo1",
                        child: Text(
                          "Seleccione periodo",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
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
                        "Descargar boleta",
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
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.book_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Calificaciones",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "TALLER DE INVESTIGACION II",
                      materia: "TALLER DE INVESTIGACION II",
                      docente: "MARIA ARACELY MARTINEZ AMAYA",
                      creditos: "4",
                      grupo: "gB",
                      clave: "ACA0910",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "10:00 - 11:00 EB02",
                        "10:00 - 11:00 EB02",
                        "10:00 - 11:00 EB02",
                        "10:00 - 11:00 EB02",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: ["U01", "U02", "U03", "Final"],
                      califValores: ["20", "70", "69", "0"],
                    ),
                  ),

                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "SISTEMAS OPERATIVOS",
                      materia: "SISTEMAS OPERATIVOS",
                      docente: "EDGAR CERVANTES LOPEZ",
                      creditos: "4",
                      grupo: "gA",
                      clave: "AEC1061",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "09:00 - 10:00 CC01",
                        "09:00 - 10:00 CC01",
                        "09:00 - 10:00 CC01",
                        "09:00 - 10:00 CC01",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: [
                        "U01",
                        "U02",
                        "U03",
                        "U04",
                        "U05",
                        "U06",
                        "Final",
                      ],
                      califValores: [
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                      ],
                    ),
                  ),

                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "PRUEBAS DE SOFTWARE",
                      materia: "PRUEBAS DE SOFTWARE",
                      docente: "MARIA DEL ROSARIO GONZALEZ ALVAREZ",
                      creditos: "4",
                      grupo: "gA",
                      clave: "ISC2102",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "08:00 - 09:00 EB03",
                        "08:00 - 09:00 EB03",
                        "08:00 - 09:00 EB03",
                        "08:00 - 09:00 EB03",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: ["U01", "U02", "U03", "U04", "Final"],
                      califValores: [
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                      ],
                    ),
                  ),

                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "METODOS AGILES",
                      materia: "METODOS AGILES",
                      docente: "RICARDO RAFAEL QUINTERO MEZA",
                      creditos: "4",
                      grupo: "gB",
                      clave: "ISC2103",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "12:00 - 13:00 EB01",
                        "12:00 - 13:00 EB01",
                        "12:00 - 13:00 EB01",
                        "12:00 - 13:00 EB01",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: [
                        "U01",
                        "U02",
                        "U03",
                        "U04",
                        "U05",
                        "Final",
                      ],
                      califValores: [
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                      ],
                    ),
                  ),

                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "ARQUITECTURA DE SOFTWARE (OPTATIVA)",
                      materia: "ARQUITECTURA DE SOFTWARE (OPTATIVA)",
                      docente: "CATALINA DE LA LUZ SOSA OCHOA",
                      creditos: "4",
                      grupo: "gA",
                      clave: "ISC2104",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "18:00 - 19:00 CCCD",
                        "18:00 - 19:00 CCCD",
                        "18:00 - 19:00 CCCD",
                        "18:00 - 19:00 CCCD",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: [
                        "U01",
                        "U02",
                        "U03",
                        "U04",
                        "U05",
                        "Final",
                      ],
                      califValores: [
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                      ],
                    ),
                  ),

                  MateriaExpansionPanel(
                    data: MateriaPanelData(
                      titulo: "ADMINISTRACION DE REDES",
                      materia: "ADMINISTRACION DE REDES",
                      docente: "EDGAR CERVANTES LOPEZ",
                      creditos: "4",
                      grupo: "gC",
                      clave: "SCA1002",
                      dias: ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
                      horarios: [
                        "11:00 - 12:00 CCDS",
                        "11:00 - 12:00 CCDS",
                        "11:00 - 12:00 CCDS",
                        "11:00 - 12:00 CCDS",
                        "-",
                        "-",
                        "-",
                      ],
                      califTitulos: ["U01", "U02", "U03", "U04", "Final"],
                      califValores: [
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                        "0 - NC",
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ), // Inicio

    MyMap(), // Mapa Tec

    Service(), // Servicios medicos

    News(), // Noticias
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: myIndex == 0 ? _buildAppBar() : null,
      drawer: myIndex == 0 ? DrawerMenu(numControl: widget.numControl) : null,
      body: widgetsList[myIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    final carrera = _alumnoData?.nombreCarrera ?? 'TecNM Culiacán';

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xff1b3a6b),
      elevation: 10,
      shadowColor: Colors.black,
      titleSpacing: 0,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/images/Logo_TecNM_Horizontal_Blanco.svg',
            height: 40,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              carrera,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.person, color: Colors.white),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const [
                  Icon(Icons.password, color: Colors.grey),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Cambiar Contraseña",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ChangePasswordDialog(
                      numControl: widget.numControl,
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.grey),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Cerrar Sesión",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await SecureStorageHelper.deleteAllData();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyScaffold(numControl: widget.numControl),
            ),
          );
        } else {
          setState(() {
            myIndex = index;
          });
        }
      },
      elevation: 10,
      backgroundColor: const Color(0xfff0f1f5),
      selectedItemColor: const Color(0xff1b3a6b),
      unselectedItemColor: Colors.grey,
      currentIndex: myIndex,
      items: [
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage('assets/icons/Icon_Tecnm.png'),
            width: 24,
            height: 24,
            color: myIndex == 0 ? const Color(0xff1b3a6b) : Colors.grey,
          ),
          label: 'Ambar',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: "Servicios Medicos",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: "Noticias",
        ),
      ],
    );
  }
}
