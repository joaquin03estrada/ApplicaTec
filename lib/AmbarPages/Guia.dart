import 'package:applicatec/Helpers/DrawerMenu.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:applicatec/widgets/News.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/widgets/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Guia extends StatefulWidget {
  @override
  State<Guia> createState() => _GuiaState();
}

class _GuiaState extends State<Guia> {
  final String carreraNomL = "INGENIERIA EN SISTEMAS COMPUTACIONALES";
  final String carreraNomS = "ING. SIST. COMP.";
  int myIndex = 0;
  
  // Controladores para el video de YouTube
  late YoutubePlayerController _youtubeController;
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    
    // Extrae el ID del video desde la URL
    final videoID = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=IRgCO2UIJ6w");
    
    // Inicializa el controlador con el ID del video
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoID ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }
  
  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myIndex == 0
          ? AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color(0xff1b3a6b),
              elevation: 10,
              shadowColor: Colors.black,
              titleSpacing: 0,
              title: Builder(
                builder: (context) {
                  final orientation = MediaQuery.of(context).orientation;
                  final textoMateria = orientation == Orientation.portrait
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
                  itemBuilder: (context) => [
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
      body: myIndex == 0 
          ? _buildGuiaDeUso()
          : widgetsList[myIndex],
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

  // Widget para construir la sección de Guía de uso
  Widget _buildGuiaDeUso() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título de la página
          Text(
            "Guía de uso",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a365d),
            ),
          ),
          SizedBox(height: 20),
          
          // Card principal
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección con icono
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_add, 
                        size: 24,
                        color: Color(0xFF1a365d),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Cargas",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Tutorial expandible
                  Card(
                    color: Colors.grey.shade200,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Encabezado expandible
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                              // Pausar video si se cierra
                              if (!_isExpanded) {
                                _youtubeController.pause();
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(
                                  "Tutorial de carga de materias",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),),
                                Icon(
                                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Contenido expandible
                        if (_isExpanded)
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Botón para abrir externo
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    icon: Icon(Icons.open_in_new),
                                    label: Text("ABRIR EXTERNO"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                    ),
                                    onPressed: () async {
                                      final url = "https://www.youtube.com/watch?v=IRgCO2UIJ6w";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
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

  late final List<Widget> widgetsList = [
    _buildGuiaDeUso(), // Esta línea no se usa directamente
    MyMap(), // Mapa Tec
    Service(), // Servicios médicos
    News(), // Noticias
  ];
}