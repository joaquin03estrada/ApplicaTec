import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:applicatec/Helpers/ChangePassword.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:applicatec/Models/AlumnoModel.dart';
import 'package:applicatec/Models/ClaseModel.dart';
import 'package:applicatec/Models/CalificacionModel.dart';
import 'package:applicatec/services/AlumnoService.dart';
import 'package:applicatec/services/ClaseService.dart';
import 'package:applicatec/services/CalificacionService.dart';
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

  List<ClaseModel> _clases = [];
  Map<String, List<CalificacionModel>> _calificacionesPorClase = {};
  bool _isLoadingData = true;

  int myIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlumnoData();
    _loadData();
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

  Future<void> _loadData() async {
    try {
      setState(() => _isLoadingData = true);

      final clases = await ClaseService.getClasesPorEstudiante(widget.numControl);
      final calificaciones = await CalificacionService.getCalificacionesPorEstudiante(widget.numControl);

      Map<String, List<CalificacionModel>> califPorClase = {};
      for (var calif in calificaciones) {
        final idClaseStr = calif.idClase.toString();
        if (!califPorClase.containsKey(idClaseStr)) {
          califPorClase[idClaseStr] = [];
        }
        califPorClase[idClaseStr]!.add(calif);
      }

      setState(() {
        _clases = clases;
        _calificacionesPorClase = califPorClase;
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
    }
  }

  List<MateriaPanelData> _buildMateriaPanelDataList() {
    List<MateriaPanelData> panelDataList = [];

    for (var clase in _clases) {
      if (clase.materia == null) continue;

      final materia = clase.materia!;
      final maestro = clase.maestro;
      final grupo = clase.grupo;

      final creditos = materia.creditos ?? 5;
      int diasAMostrar = creditos == 4 ? 4 : 5;

      List<String> dias = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"];
      List<String> horarios = [];

      for (int i = 0; i < 7; i++) {
        if (i < diasAMostrar) {
          final aula = grupo?.aula ?? 'N/A';
          horarios.add('${clase.horarioInicio} - ${clase.horarioFin ?? "N/A"} $aula');
        } else {
          horarios.add('-');
        }
      }

      final idClaseStr = clase.idclase;
      final calificaciones = _calificacionesPorClase[idClaseStr] ?? [];

      List<String> califTitulos = [];
      List<String> califValores = [];

      if (calificaciones.isEmpty) {
        int numUnidades = creditos == 4 ? 4 : 6;
        for (int i = 1; i <= numUnidades; i++) {
          califTitulos.add('U${i.toString().padLeft(2, '0')}');
          califValores.add('0');
        }
        califTitulos.add('Final');
        califValores.add('0');
      } else {
        for (var calif in calificaciones) {
          if (calif.unidad.toUpperCase() == 'FINAL') {
            califTitulos.add('Final');
            califValores.add(calif.califFinal?.toInt().toString() ?? '0');
          } else {
            califTitulos.add(calif.unidad.toUpperCase());
            califValores.add(calif.calificacion?.toInt().toString() ?? '0');
          }
        }
      }

      panelDataList.add(
        MateriaPanelData(
          titulo: materia.nombreMat,
          materia: materia.nombreMat,
          docente: maestro?.nombreCompleto ?? 'Sin asignar',
          creditos: materia.creditos?.toString() ?? '0',
          grupo: grupo?.claveGrupo ?? 'N/A',
          clave: materia.claveMat,
          dias: dias,
          horarios: horarios,
          califTitulos: califTitulos,
          califValores: califValores,
        ),
      );
    }

    return panelDataList;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final widgetsList = [
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (_isLoadingData)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: Color(0xff1b3a6b),
                          ),
                        ),
                      )
                    else
                      ..._buildMateriaPanelDataList().map(
                        (data) => MateriaExpansionPanel(data: data),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      MyMap(),
      Service(),
      News(),
    ];

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