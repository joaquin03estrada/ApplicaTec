import 'package:applicatec/AmbarPages/CargaMaterias.dart';
import 'package:applicatec/AmbarPages/Guia.dart';
import 'package:applicatec/AmbarPages/HistoriActividades.dart';
import 'package:applicatec/AmbarPages/Horario.dart';
import 'package:applicatec/AmbarPages/Kardex.dart';
import 'package:applicatec/AmbarPages/Recibos.dart';
import 'package:applicatec/AmbarPages/Tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applicatec/widgets/Scaffold.dart';
import 'package:applicatec/AmbarPages/Calificaciones.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  Uri get _url => Uri.parse('https://www.facebook.com/ambartecnm');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/Logo_TecNM_Horizontal_Blanco.svg',
                height: 100,
                colorFilter: const ColorFilter.mode(
                  Color(0xff1b3a6b),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Inicio"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => MyScaffold()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions_rounded),
            title: const Text("Horario"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Horario()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.collections_bookmark_rounded),
            title: const Text("Calificaciones"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Calificaciones()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.co_present_outlined),
            title: const Text("Kárdex"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Kardex()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Histórico de actividades"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Historiactividades()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text("Recibos"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Recibos()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_add),
            title: const Text("Carga de materias"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Cargamaterias()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number_sharp),
            title: const Text("Tickets"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Tickets()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Soporte"),
            onTap: () {
              _launchUrl();
            },
          ),
          ListTile(
            leading: const Icon(Icons.find_in_page_outlined),
            title: const Text("Guia de uso"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Guia()));
            },
          ),
        ],
      ),
    );
  }
}