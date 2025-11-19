import 'package:applicatec/AmbarPages/Horario.dart';
import 'package:applicatec/Helpers/ticket_dialog.dart';
import 'package:applicatec/services/TicketService.dart';
import 'package:flutter/material.dart';

class CargaAcademica extends StatefulWidget {
  final String numControl;
  final String nombre;
  final String matricula;
  final List<String> carreras;

  const CargaAcademica({
    Key? key,
    required this.nombre,
    required this.matricula,
    required this.carreras,
    required this.numControl,
  }) : super(key: key);

  @override
  State<CargaAcademica> createState() => _CargaAcademicaState();
}

class _CargaAcademicaState extends State<CargaAcademica> {
  late String _selectedCarrera;
  bool _fueraDeHorario = true;
  bool _isCreatingTicket = false;

  @override
  void initState() {
    super.initState();
    _selectedCarrera = widget.carreras.isNotEmpty ? widget.carreras.first : "";
  }

  Future<void> _handleCrearTicket(String tipo, String observaciones) async {
    setState(() => _isCreatingTicket = true);

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Color(0xff1b3a6b)),
      ),
    );

    final descripcion = '$tipo - $observaciones';
    final success = await TicketService.crearTicket(
      numControl: widget.numControl,
      descripcion: descripcion,
    );

    // Cerrar el indicador de carga
    Navigator.pop(context);

    setState(() => _isCreatingTicket = false);

    if (success) {
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket generado con éxito'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar el ticket. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card que contiene el título y los datos del estudiante
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de encabezado con icono y título
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_add,
                          size: 32,
                          color: Color(0xFF1a365d),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Carga Académica",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a365d),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Nombre y matrícula del estudiante
                    Text(
                      widget.nombre.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a365d),
                      ),
                    ),
                    Text(
                      widget.matricula,
                      style: TextStyle(fontSize: 16, color: Color(0xFF1a365d)),
                    ),
                  ],
                ),
              ),
            ),

            // Sección de ticket (alineado a la derecha)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: Icon(Icons.confirmation_number_sharp),
                label: Text("TICKET"),
                onPressed: _isCreatingTicket
                    ? null
                    : () {
                        TicketDialog.show(
                          context,
                          onConfirm: _handleCrearTicket,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1a365d),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.white70,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Mensaje de fuera de horario
            if (_fueraDeHorario)
              Card(
                elevation: 0,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.black54, size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Fuera de horario de carga",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16),

            // Botón de horario (alineado a la derecha)
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: Icon(Icons.pending_actions_rounded),
                label: Text("HORARIO"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Horario(numControl: widget.numControl),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF1a365d),
                  side: BorderSide(color: Color(0xFF1a365d)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}