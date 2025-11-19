import 'package:flutter/material.dart';

// Clase para mostrar un diálogo de generación de ticket
class TicketDialog extends StatefulWidget {
  final Function(String, String)? onConfirm; // Callback para cuando se confirma el ticket

  const TicketDialog({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  // Método estático para mostrar el diálogo fácilmente desde cualquier parte
  static Future<void> show(BuildContext context, {Function(String, String)? onConfirm}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: TicketDialog(onConfirm: onConfirm),
        );
      },
    );
  }

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  String? _selectedTicketType;
  final TextEditingController _observationsController = TextEditingController();
  
  // Lista de tipos de ticket disponibles
  final List<String> _ticketTypes = [
    'Cambio de materia',
    'Baja de materia',
  ];

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determinar si el teclado está abierto
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    
    // Determinar la orientación
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Calcular el ancho y alto disponibles
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Ajustar el tamaño máximo del diálogo según la orientación
    final double maxDialogWidth = isLandscape ? screenWidth * 0.7 : 700;
    final double maxDialogHeight = isLandscape ? screenHeight * 0.9 : screenHeight * 0.8;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: isKeyboardOpen ? double.infinity : maxDialogHeight,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del diálogo
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Generación de ticket',
                        style: TextStyle(
                          fontSize: isLandscape ? 22 : 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a365d),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isLandscape ? 16 : 24),
                
                // Selector de tipo de ticket
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isLandscape ? 12 : 16
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        isDense: isLandscape, // Más compacto en horizontal
                        hint: Text(
                          'SELECCIONE TIPO DE TICKET',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isLandscape ? 13 : 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: _selectedTicketType,
                        icon: Icon(Icons.arrow_drop_down, size: isLandscape ? 20 : 24),
                        iconSize: isLandscape ? 20 : 24,
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: isLandscape ? 14 : 15
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedTicketType = newValue;
                          });
                        },
                        items: _ticketTypes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: isLandscape ? 14 : 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isLandscape ? 12 : 16),
                
                // Campo de observaciones con altura adaptable
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _observationsController,
                    maxLines: isKeyboardOpen || isLandscape ? 3 : 5, // Reducir líneas si el teclado está abierto o es horizontal
                    decoration: InputDecoration(
                      hintText: 'OBSERVACIONES PARA EL TICKET',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: isLandscape ? 13 : 14,
                      ),
                      contentPadding: EdgeInsets.all(isLandscape ? 12 : 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: isLandscape ? 16 : 24),
                
                // Botones de acción - en modo horizontal los ponemos más pequeños
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Botón de Cerrar
                      TextButton(
                        onPressed: () {
                          // Cerrar el teclado si está abierto
                          FocusScope.of(context).unfocus();
                          // Esperar un momento para que el teclado se cierre completamente
                          Future.delayed(Duration(milliseconds: 100), () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape || isKeyboardOpen ? 12 : 20,
                            vertical: isLandscape || isKeyboardOpen ? 6 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          minimumSize: Size(isLandscape ? 80 : 100, 0), // Ancho mínimo más pequeño en horizontal
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'CERRAR',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: isLandscape || isKeyboardOpen ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isLandscape ? 8 : 12),
                      
                      // Botón de Confirmar
                      ElevatedButton(
                        onPressed: () {
                          // Cerrar el teclado si está abierto
                          FocusScope.of(context).unfocus();
                          
                          // Validar que se haya seleccionado un tipo de ticket
                          if (_selectedTicketType != null) {
                            // Esperar un momento para que el teclado se cierre completamente
                            Future.delayed(Duration(milliseconds: 100), () {
                              // Llamar al callback si existe
                              if (widget.onConfirm != null) {
                                widget.onConfirm!(_selectedTicketType!, _observationsController.text);
                              }
                              Navigator.of(context).pop();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Por favor, seleccione un tipo de ticket'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1b3a6b), 
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape || isKeyboardOpen ? 12 : 20,
                            vertical: isLandscape || isKeyboardOpen ? 6 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          minimumSize: Size(isLandscape ? 80 : 100, 0), // Ancho mínimo más pequeño en horizontal
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'CONFIRMAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: isLandscape || isKeyboardOpen ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ], 
            ),
          ),
        ),
      ),
    );
  }
}