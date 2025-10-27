import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SalonSidebarDrawer extends StatefulWidget {
  final Map<String, LatLng> salonesUbicaciones;
  final Function(String) onSalonSelected;

  const SalonSidebarDrawer({
    Key? key,
    required this.salonesUbicaciones,
    required this.onSalonSelected,
  }) : super(key: key);

  @override
  State<SalonSidebarDrawer> createState() => _SalonSidebarDrawerState();
}

class _SalonSidebarDrawerState extends State<SalonSidebarDrawer> {
  List<String> salonesFiltrados = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    salonesFiltrados = widget.salonesUbicaciones.keys.toList();
  }

  void _filtrarSalones(String value) {
    setState(() {
      searchText = value;
      salonesFiltrados = widget.salonesUbicaciones.keys
          .where((s) => s.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Buscar salón...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: _filtrarSalones,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: salonesFiltrados.length,
                itemBuilder: (context, index) {
                  final salon = salonesFiltrados[index];
                  return ListTile(
                    title: Text(salon),
                    leading: Icon(Icons.meeting_room, color: Color(0xff1b3a6b)),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el Drawer
                      widget.onSalonSelected(salon);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}