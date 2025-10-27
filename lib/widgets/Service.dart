import 'package:flutter/material.dart';
import 'package:applicatec/Helpers/ExpansionPanel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:applicatec/widgets/Map.dart';
import 'package:latlong2/latlong.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  final Uri _url1 = Uri.parse('https://consultas-lorena-tec.youcanbook.me/');
  final Uri _url2 = Uri.parse('https://misael-burgos.youcanbook.me/');
  final LatLng medicLocation = LatLng(24.788421, -107.397258);
  final LatLng psicoLocation = LatLng(24.788617, -107.396301);

  Future<void> _Lorena() async {
    if (!await launchUrl(_url1)) {
      throw Exception('Could not launch $_url1');
    }
  }

  Future<void> _Misael() async {
    if (!await launchUrl(_url2)) {
      throw Exception('Could not launch $_url2');
    }
  }

  void _verUbicacion(LatLng location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MyMap(
              markerLocation: location,
              markerLabel: "",
              showDrawerBackButton: true, 
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b3a6b),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Primera Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Consultorio Médico",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Dr. Felipe Chucuan Jacobo",
                        rows: [
                          _buildRow(
                            "Días de servicio",
                            "Horario",
                            "Lunes a Viernes",
                            "7:00 a 11:00 hrs.",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Dr. Brigido Inzunza Palazuelos",
                        rows: [
                          _buildRow(
                            "Días de servicio",
                            "Horario",
                            "Lunes a Viernes",
                            "11:00 a 16:00 hrs.",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Dr. Baltazar de J. Urquidez Rojo",
                        rows: [
                          _buildRow(
                            "Días de servicio",
                            "Horario",
                            "Lunes a Jueves",
                            "16:00 a 19:00 hrs.",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _verUbicacion(medicLocation),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
                    ],
                  ),
                ),
              ),

              // Segunda Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Psicólogos",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Psicól. Alma Lorena López Ríos",
                        rows: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _Lorena,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1b3a6b),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Agendar Cita",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Psicól. Misael Alejandro Burgos Bayliss",
                        rows: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _Misael,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1b3a6b),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Agendar Cita",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _verUbicacion(psicoLocation),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
                    ],
                  ),
                ),
              ),

              // Tercera Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Dentista",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3a6b),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanel(
                        icon: Icons.local_hospital,
                        title: "Dr. José Antonio López Hernández",
                        rows: [
                          _buildRow(
                            "Días de servicio",
                            "Horario",
                            "Lunes a Viernes",
                            "9:00 a 14:00 hrs.",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _verUbicacion(medicLocation),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
