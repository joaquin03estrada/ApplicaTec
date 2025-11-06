import 'package:applicatec/Helpers/ChangePassword.dart';
import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:applicatec/models/AlumnoModel.dart';
import 'package:applicatec/services/AlumnoService.dart';
import 'package:applicatec/Helpers/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applicatec/Helpers/ExpansionPanel.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/login.dart';

class MyScaffold extends StatefulWidget {
  final String numControl;

  const MyScaffold({Key? key, required this.numControl}) : super(key: key);

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int myIndex = 0;
  bool _isLoading = true;
  AlumnoModel? _alumnoData;
  String? _errorMessage;
  DateTime fechacarga = DateTime(2025, 08, 08);
  TimeOfDay horacarga = TimeOfDay(hour: 11, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadAlumnoData();
  }

  // Cargar datos del alumno desde Supabase
  Future<void> _loadAlumnoData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('Cargando datos para num_control: ${widget.numControl}');

      final alumno = await AlumnoService.getAlumnoByNumControl(
        widget.numControl,
      );

      if (alumno != null) {
        setState(() {
          _alumnoData = alumno;
          _isLoading = false;
        });
        print('Datos cargados exitosamente');
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No se encontraron datos para el número de control';
        });
      }
    } catch (e) {
      print('Error cargando datos del alumno: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar los datos del estudiante'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: _loadAlumnoData,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si está cargando, mostrar indicador
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(color: Colors.white)],
          ),
        ),
      );
    }

    // Si no hay datos, mostrar error
    if (_alumnoData == null) {
      return Scaffold(
        backgroundColor: const Color(0xff1b3a6b),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'No se pudieron cargar los datos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadAlumnoData,
                  icon: Icon(Icons.refresh),
                  label: Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff1b3a6b),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await SecureStorageHelper.deleteAllData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final widgetsList = [_buildMainContent(), MyMap(), Service(), News()];

    return Scaffold(
      appBar: myIndex == 0 ? _buildAppBar() : null,
      drawer: myIndex == 0 ? DrawerMenu(numControl: widget.numControl) : null,
      body: widgetsList[myIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Construir AppBar
  AppBar _buildAppBar() {
    // Usar el nombre completo en landscape, corto en portrait
    final orientation = MediaQuery.of(context).orientation;
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
                      Icon(Icons.refresh, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Actualizar datos"),
                    ],
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, _loadAlumnoData);
                  },
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: const [
                      Icon(Icons.password, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Cambiar Contraseña"),
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
                  value: 3,
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Cerrar Sesión"),
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

  // Construir contenido principal
  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _loadAlumnoData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de identificación
            _buildIdentificationCard(),

            const SizedBox(height: 16),

            // Datos personales
            CustomExpansionPanel(
              icon: Icons.person_outline,
              title: "Datos Personales",
              rows: [
                _buildRow(
                  "CURP",
                  "Ciudad",
                  _alumnoData!.curp.isNotEmpty ? _alumnoData!.curp : 'N/A',
                  _alumnoData!.ciudad.isNotEmpty ? _alumnoData!.ciudad : 'N/A',
                ),
                _buildRow(
                  "Teléfono",
                  "Colonia",
                  _alumnoData!.celular.isNotEmpty
                      ? _alumnoData!.celular
                      : 'N/A',
                  _alumnoData!.colonia.isNotEmpty
                      ? _alumnoData!.colonia
                      : 'N/A',
                ),
                _buildRow(
                  "Correo Personal",
                  "Calle",
                  _alumnoData!.correoPersonal.isNotEmpty
                      ? _alumnoData!.correoPersonal
                      : 'N/A',
                  _alumnoData!.calle.isNotEmpty ? _alumnoData!.calle : 'N/A',
                ),
                _buildRow(
                  "Fecha de Nacimiento",
                  "C.P.",
                  _alumnoData!.fechaNacimiento != null
                      ? "${_alumnoData!.fechaNacimiento!.day}/${_alumnoData!.fechaNacimiento!.month}/${_alumnoData!.fechaNacimiento!.year}"
                      : 'N/A',
                  _alumnoData!.codigoPostal.isNotEmpty
                      ? _alumnoData!.codigoPostal
                      : 'N/A',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información académica
            CustomExpansionPanel(
              icon: Icons.folder_copy_outlined,
            title: "Información de carga académica",
            rows: [
              _buildRow(
                "Fecha de carga",
                "Adeudos",
                "Fecha:${fechacarga.year}-${fechacarga.month}-${fechacarga.day} Hora:${horacarga.hour}:${horacarga.minute.toString().padLeft(2, '0')}",
                "No cuenta con adeudos",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de identificación
  Widget _buildIdentificationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Identificación",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1b3a6b),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Icon(
                Icons.person_outlined,
                size: 200,
                color: Color(0xff1b3a6b),
              ),
            ),
            SizedBox(height: 12),
            Text(
              _alumnoData!.nombreCompleto,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${_alumnoData!.numControl} - ${_alumnoData!.correoInstitucional}",
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                _buildRow(
                  "Carrera",
                  "Especialidad",
                  _alumnoData!.nombreCarrera ?? 'Sin carrera',
                  _alumnoData!.especialidad.isNotEmpty
                      ? _alumnoData!.especialidad
                      : 'N/A',
                ),
                _buildRow(
                  "Semestre",
                  "Prom. sin reprobadas",
                  _alumnoData!.semestre?.toString() ?? 'N/A',
                  _alumnoData!.promedioSinReprobadas != null
                      ? _alumnoData!.promedioSinReprobadas!.toStringAsFixed(2)
                      : 'N/A',
                ),
                _buildRow(
                  "Prom. con reprobadas",
                  "Estatus",
                  _alumnoData!.promedioConReprobadas != null
                      ? _alumnoData!.promedioConReprobadas!.toStringAsFixed(2)
                      : 'N/A',
                  _alumnoData!.situacion.isNotEmpty
                      ? _alumnoData!.situacion
                      : 'Vigente',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Construir bottom navigation bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          myIndex = index;
        });
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

  // Método auxiliar para construir filas de datos
  TableRow _buildRow(
    String label1,
    String label2,
    String value1,
    String value2,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
