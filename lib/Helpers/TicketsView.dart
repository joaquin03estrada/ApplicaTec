import 'package:flutter/material.dart';
import 'package:applicatec/Helpers/ticket_dialog.dart';

class TicketsView extends StatefulWidget {
  // Podemos pasar listas de tickets como parámetros opcionales
  final List<Ticket>? ticketsAbiertos;
  final List<Ticket>? ticketsFinalizados;
  
  const TicketsView({
    Key? key,
    this.ticketsAbiertos,
    this.ticketsFinalizados,
  }) : super(key: key);

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 0;
  int _elementsPerPage = 10;
  ScrollController _horizontalScrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Obtener el factor de escala de texto y la orientación
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado y botón de generación de ticket
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tickets',
                      style: TextStyle(
                        fontSize: isLandscape ? 24 : 28, // Tamaño más pequeño en modo horizontal
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a365d),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Mostrar el diálogo de generación de ticket
                      TicketDialog.show(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1a365d),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('GENERAR TICKET'),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isLandscape ? 16 : 24), // Espacio reducido en horizontal
              
              // Pestañas para tickets abiertos y finalizados
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF1a365d),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF1a365d),
                  indicatorWeight: 3,
                  labelStyle: TextStyle(
                    fontSize: 14 / (textScaleFactor > 1.3 ? textScaleFactor * 0.7 : 1), // Reducir tamaño si la escala es muy grande
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(text: 'ABIERTOS'),
                    Tab(text: 'FINALIZADOS'),
                  ],
                ),
              ),
              
              SizedBox(height: isLandscape ? 8 : 16), // Espacio reducido en horizontal
              
              // Contenido de las pestañas
              Container(
                height: 400, // Altura fija para las tablas
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Pestaña de tickets ABIERTOS
                    _buildTicketsTable(
                      headers: ['Fecha', 'Clave', 'Descripción', 'Estatus', 'Editar'],
                      tickets: widget.ticketsAbiertos,
                    ),
                    
                    // Pestaña de tickets FINALIZADOS
                    _buildTicketsTable(
                      headers: ['Fecha', 'Clave', 'Descripción', 'Estatus', 'Comentario'],
                      tickets: widget.ticketsFinalizados,
                    ),
                  ],
                ),
              ),
              
              // Controles de paginación
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildPaginationControls(constraints.maxWidth);
                  },
                ),
              ),
              
              // Indicador de desplazamiento horizontal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Desliza horizontalmente para ver más información',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
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
  
  // Método separado para construir los controles de paginación
  Widget _buildPaginationControls(double availableWidth) {
    // Para pantallas pequeñas
    if (availableWidth < 500) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector de elementos por página adaptable
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Elementos por página: ',
                  style: TextStyle(fontSize: 13),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _elementsPerPage,
                      icon: Icon(Icons.arrow_drop_down, size: 20),
                      iconSize: 20,
                      elevation: 16,
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(height: 0),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => _elementsPerPage = newValue);
                        }
                      },
                      items: <int>[5, 10, 15, 20].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            width: 24,
                            alignment: Alignment.center,
                            child: Text(value.toString(), style: TextStyle(fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Información y navegación de páginas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0-0 de 0', style: TextStyle(fontSize: 13)),
              Row(
                children: [
                  _buildPageButton(
                    Icons.keyboard_double_arrow_left,
                    _currentPage > 0,
                    () => setState(() => _currentPage = 0),
                  ),
                  _buildPageButton(
                    Icons.keyboard_arrow_left,
                    _currentPage > 0,
                    () => setState(() => _currentPage--),
                  ),
                  _buildPageButton(
                    Icons.keyboard_arrow_right,
                    false,
                    () => setState(() => _currentPage++),
                  ),
                  _buildPageButton(
                    Icons.keyboard_double_arrow_right,
                    false,
                    () => setState(() {}),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      // Para pantallas más grandes
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selector de elementos por página adaptable
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Elementos por página: ',
                  style: TextStyle(fontSize: 13),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _elementsPerPage,
                      icon: Icon(Icons.arrow_drop_down, size: 20),
                      iconSize: 20,
                      elevation: 16,
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(height: 0),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => _elementsPerPage = newValue);
                        }
                      },
                      items: <int>[5, 10, 15, 20].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            width: 24,
                            alignment: Alignment.center,
                            child: Text(value.toString(), style: TextStyle(fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Información y navegación de páginas
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('0-0 de 0', style: TextStyle(fontSize: 13)),
              SizedBox(width: 8),
              _buildPageButton(
                Icons.keyboard_double_arrow_left,
                _currentPage > 0,
                () => setState(() => _currentPage = 0),
              ),
              _buildPageButton(
                Icons.keyboard_arrow_left,
                _currentPage > 0,
                () => setState(() => _currentPage--),
              ),
              _buildPageButton(
                Icons.keyboard_arrow_right,
                false,
                () => setState(() => _currentPage++),
              ),
              _buildPageButton(
                Icons.keyboard_double_arrow_right,
                false,
                () => setState(() {}),
              ),
            ],
          ),
        ],
      );
    }
  }
  
  // Método para crear botones de paginación uniformes
  Widget _buildPageButton(IconData icon, bool isActive, VoidCallback onPressed) {
    return Container(
      width: 28,
      height: 28,
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        onPressed: isActive ? onPressed : null,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }
  
  // Método para construir la tabla de tickets con manejo de desbordamiento
  Widget _buildTicketsTable({
    required List<String> headers,
    List<Ticket>? tickets,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezados de la tabla dentro de un SingleChildScrollView horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 64, // Ancho mínimo con padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera de la tabla
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100, // Ancho fijo para fecha
                            child: Text(
                              'Fecha',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a365d),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Espacio adicional entre columnas
                          Container(
                            width: 80, // Ancho fijo para clave
                            child: Text(
                              'Clave',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a365d),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Espacio adicional entre columnas
                          Container(
                            width: 200, // Ancho fijo para descripción
                            child: Text(
                              'Descripción',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a365d),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Espacio adicional entre columnas
                          Container(
                            width: 100, // Ancho fijo para estatus
                            child: Text(
                              'Estatus',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a365d),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Espacio adicional entre columnas
                          Container(
                            width: 100, // Ancho fijo para acción
                            child: Text(
                              _tabController.index == 0 ? 'Editar' : 'Comentario',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a365d),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Si no hay tickets, mostrar mensaje "No hay datos disponibles"
                  if (tickets == null || tickets.isEmpty)
                    Container(
                      width: 100 + 80 + 200 + 100 + 100 + 16*4, // Suma de todos los anchos + espaciado
                      height: 300,
                      alignment: Alignment.center,
                      child: Text(
                        'No hay datos disponibles',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    )
                  else
                    // Aquí iría el código para mostrar la lista de tickets
                    Column(
                      children: tickets.map((ticket) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fecha
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ticket.fecha,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Clave
                              Container(
                                width: 80,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ticket.clave,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Descripción
                              Container(
                                width: 200,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ticket.descripcion,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Estatus
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ticket.estatus,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Acción (Editar o Comentario)
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: _tabController.index == 0
                                  ? IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        // Acción para editar ticket
                                      },
                                    )
                                  : Text(
                                      ticket.comentario ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13),
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase modelo para representar un Ticket
class Ticket {
  final String fecha;
  final String clave;
  final String descripcion;
  final String estatus;
  final String? comentario; // Solo para tickets finalizados
  
  Ticket({
    required this.fecha,
    required this.clave,
    required this.descripcion,
    required this.estatus,
    this.comentario,
  });
}