import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:applicatec/Helpers/ChangePassword.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:applicatec/Models/AlumnoModel.dart';
import 'package:applicatec/models/EstudianteActividadModel.dart';
import 'package:applicatec/services/AlumnoService.dart';
import 'package:applicatec/services/EstudianteActividadService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:applicatec/Helpers/activity_cards.dart';

class Historiactividades extends StatefulWidget {
  final String numControl;

  const Historiactividades({Key? key, required this.numControl})
      : super(key: key);
  @override
  State<Historiactividades> createState() => _HistoriactividadesState();
}

class _HistoriactividadesState extends State<Historiactividades> {
  AlumnoModel? _alumnoData;
  bool _isLoading = true;
  String? _errorMessage;

  List<EstudianteActividadModel> _actividadesComplementarias = [];
  List<EstudianteActividadModel> _actividadesExtraescolares = [];
  List<EstudianteActividadModel> _tutorias = [];
  bool _isLoadingActividades = true;

  int myIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlumnoData();
    _loadActividades();
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

  Future<void> _loadActividades() async {
    try {
      setState(() => _isLoadingActividades = true);

      final actividades =
          await EstudianteActividadService.getActividadesPorEstudiante(
        widget.numControl,
      );

      // Clasificar actividades por tipo
      _clasificarActividades(actividades);

      setState(() {
        _isLoadingActividades = false;
      });
    } catch (e) {
      print('Error cargando actividades: $e');
      setState(() => _isLoadingActividades = false);
    }
  }

  void _clasificarActividades(List<EstudianteActividadModel> actividades) {
    _actividadesComplementarias.clear();
    _actividadesExtraescolares.clear();
    _tutorias.clear();

    for (var estudianteActividad in actividades) {
      final tipoActividad =
          estudianteActividad.actividad?.tipoActividad?.toLowerCase() ?? '';

      if (tipoActividad.contains('complementaria')) {
        _actividadesComplementarias.add(estudianteActividad);
      } else if (tipoActividad.contains('extraescolar')) {
        _actividadesExtraescolares.add(estudianteActividad);
      } else if (tipoActividad.contains('tutoria')) {
        _tutorias.add(estudianteActividad);
      } else {
        _actividadesComplementarias.add(estudianteActividad);
      }
    }
  }

  Widget _buildActividadesComplementariasContent() {
    if (_isLoadingActividades) {
      return const LoadingActivityContent();
    }

    if (_actividadesComplementarias.isEmpty) {
      return const EmptyActivityContent(
        message: 'No cuenta con actividades complementarias registradas',
      );
    }

    return ActividadesContent(actividades: _actividadesComplementarias);
  }

  Widget _buildActividadesExtraescolaresContent() {
    if (_isLoadingActividades) {
      return const LoadingActivityContent();
    }

    if (_actividadesExtraescolares.isEmpty) {
      return const EmptyActivityContent(
        message: 'No cuenta con actividades extraescolares registradas',
      );
    }

    return ActividadesContent(actividades: _actividadesExtraescolares);
  }

  Widget _buildTutoriasContent() {
    if (_isLoadingActividades) {
      return const LoadingActivityContent();
    }

    if (_tutorias.isEmpty) {
      return const EmptyActivityContent(
        message: 'No cuenta con tutorías registradas',
      );
    }

    return ActividadesContent(actividades: _tutorias);
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
            ActivityCard(
              title: 'Actividades complementarias',
              content: _buildActividadesComplementariasContent(),
            ),
            ActivityCard(
              title: 'Actividades extraescolares',
              content: _buildActividadesExtraescolaresContent(),
            ),
            ActivityCard(
              title: 'Tutorías',
              content: _buildTutoriasContent(),
            ),
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
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              carrera,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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