import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/Helpers/avance_academico_view.dart';
import 'package:applicatec/Helpers/kardex_card.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:applicatec/Helpers/ChangePassword.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:applicatec/Models/AlumnoModel.dart';
import 'package:applicatec/services/AlumnoService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Kardex extends StatefulWidget {
  final String numControl;

  const Kardex({Key? key, required this.numControl}) : super(key: key);
  @override
  State<Kardex> createState() => _KardexState();
}

class _KardexState extends State<Kardex> {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_errorMessage != null || _alumnoData == null) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                _errorMessage ?? 'No se encontraron datos',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    
    final widgetsList = [
      SingleChildScrollView(
        child: Column(
          children: [
            KardexCard(
            nombre: _alumnoData!.nombreCompleto.toUpperCase(),
            matricula: _alumnoData!.numControl,
            carrera: _alumnoData!.nombreCarrera ?? 'CARRERA NO ESPECIFICADA',
            especialidad: _alumnoData!.especialidad.isNotEmpty 
                ? _alumnoData!.especialidad 
                : 'SIN ESPECIALIDAD',
            semestre: _alumnoData!.semestre ?? 0,
            situacion: _alumnoData!.situacion.toUpperCase(),
            creditosAcumulados: _alumnoData!.creditosAcumulados ?? 0,
            creditosTotales: 260, 
            periodoIngreso: _alumnoData!.periodoIngreso,
            porcentajeAvance: _calcularPorcentajeAvance(
              _alumnoData!.creditosAcumulados ?? 0,
              260,
            ),
          ),
            SizedBox(height: 16),
            AvanceAcademicoView(numControl: widget.numControl),
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

  // Método para calcular el porcentaje de avance
  double _calcularPorcentajeAvance(
    int creditosAcumulados,
    int creditosTotales,
  ) {
    if (creditosTotales == 0) return 0.0;
    return (creditosAcumulados / creditosTotales) * 100;
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
          itemBuilder:
              (context) => [
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
                        builder:
                            (context) => ChangePasswordDialog(
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
