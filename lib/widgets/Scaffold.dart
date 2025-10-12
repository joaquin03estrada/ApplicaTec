import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applicatec/Helpers/ExpansionPanel.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/login.dart';

class MyScaffold extends StatefulWidget {
  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int myIndex = 0;

  final String carreraNomL = "INGENIERIA EN SISTEMAS COMPUTACIONALES";
  final String carreraNomS = "ING. SIST. COMP.";

  String Especialidad = "ING. DE SOFTWARE";

  String Nombre = "JOSE JOAQUIN ESTRADA MENDOZA";

  int Matricula = 21170312;

  double PromedioSR = 85.49;

  double PromedioCR = 83.55;

  int Semestre = 9;

  String estatus = "Vigente"; //Prox Boolean

  String curp = "EJMO920101HOCSTR09";

  String ciudad = "CULIACAN";

  String telefono = "6671234567";

  String colonia = "CENTRO";

  String calle = "AV. UNIVERSIDAD #123";

  String correo = "JOAQUIN03ESTRADA@GMAIL.COM";

  DateTime fechaNac = DateTime(2003, 01, 01);

  String cp = "80000";

  DateTime fechacarga = DateTime(2025, 08, 08);

  TimeOfDay horacarga = TimeOfDay(hour: 11, minute: 0);

  late final List<Widget> widgetsList = [
    SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Selecciona una carrera",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: "ING. SIST. COMP.", // valor inicial
            items: const [
              DropdownMenuItem(
                value: "ING. SIST. COMP.",
                child: Text(
                  "INGENIERÍ0A EN SISTEMAS COMPUTACIONALES",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              DropdownMenuItem(
                value: "Ingles",
                child: Text(
                  "INGLES",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            onChanged: (value) {
              // Aquí puedes manejar el cambio de carrera
            },

            selectedItemBuilder: (context) {
              return [
                const Text(
                  "INGENIERÍA EN SISTEMAS COMPUTACIONALES",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const Text(
                  "INGLES",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ];
            },
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
                      size: 250,
                      color: Color(0xff1b3a6b),
                    ),
                  ),
                  Text(
                    Nombre,
                    style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                  ),
                  Text(
                    "${Matricula.toString()} - L${Matricula.toString()}@CULIACAN.TECNM.MX",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
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
                        carreraNomS,
                        Especialidad,
                      ),
                      _buildRow(
                        "Semestre",
                        "Prom. sin reprobadas",
                        Semestre.toString(),
                        PromedioSR.toStringAsFixed(2),
                      ),
                      _buildRow(
                        "Prom. con reprobadas",
                        "Estatus",
                        PromedioCR.toStringAsFixed(2),
                        estatus,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          CustomExpansionPanel(
            icon: Icons.person_outline,
            title: "Datos Personales",
            rows: [
              _buildRow("CURP", "Ciudad", curp, ciudad),
              _buildRow("Teléfono", "Colonia", telefono, colonia),
              _buildRow("Correo", "Calle", correo, calle),
              _buildRow(
                "Fecha de Nacimiento",
                "C.P.",
                "${fechaNac.day}-${fechaNac.month}-${fechaNac.year}",
                cp,
              ),
            ],
          ),

          const SizedBox(height: 16),

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

    MyMap(), // Mapa Tec

    Service(), // Servicios medicos

    News(), // Noticias
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          myIndex == 0
              ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff1b3a6b),
                elevation: 10,
                shadowColor: Colors.black,
                titleSpacing: 0,
                title: Builder(
                  builder: (context) {
                    final orientation = MediaQuery.of(context).orientation;
                    final textoMateria =
                        orientation == Orientation.portrait
                            ? carreraNomS
                            : carreraNomL;
                    return Row(
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
                            textoMateria,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
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
                                Text("Cambiar Contraseña"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.grey),
                                SizedBox(width: 8),
                                Text("Salir"),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                          ),
                        ],
                  ),
                ],
              )
              : null,
      //Menu de la izquierda
      drawer: myIndex == 0 ? DrawerMenu() : null,

      //Cuerpo de la app
      body: widgetsList[myIndex],

      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

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
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 15,
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
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 15,
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
