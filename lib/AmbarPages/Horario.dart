import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/Helpers/Horario_Helper.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Horario extends StatefulWidget {
  @override
  State<Horario> createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  final String carreraNomL = "INGENIERIA EN SISTEMAS COMPUTACIONALES";
  final String carreraNomS = "ING. SIST. COMP.";

  int myIndex = 0;

  late final List<Widget> widgetsList = [
    SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: HorarioWidget(),
    ), // Inicio

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

      drawer: DrawerMenu(),

      body: widgetsList[myIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyScaffold()),
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
      ),
    );
  }
}
