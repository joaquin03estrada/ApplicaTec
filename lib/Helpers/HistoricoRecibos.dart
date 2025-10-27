import 'package:flutter/material.dart';
import 'package:applicatec/AmbarPages/Recibos.dart';

class HistoricoRecibos extends StatefulWidget {
  @override
  State<HistoricoRecibos> createState() => _HistoricoRecibosState();
}

class _HistoricoRecibosState extends State<HistoricoRecibos> {
  int _rowsPerPage = 10;
  int _currentPageIndex = 0;

  // Lista de recibos para mostrar en la tabla
  final List<Map<String, dynamic>> recibos = [
    {
      'descripcion':
          'APORTACIÓN VOLUNTARIA SEMESTRE AGOSTO-DICIEMBRE 2025 OCTAVO SEMESTRE EN ADELANTE',
      'periodo': 'AGO-DIC 2025',
      'importe': 3200.00,
      'estado': 'CUBIERTO',
    },
    {
      'descripcion':
          'APORTACIÓN VOLUNTARIA SEMESTRE ENERO JUNIO 2025 SÉPTIMO SEMESTRE EN ADELANTE',
      'periodo': 'ENE-JUN 2025',
      'importe': 3200.00,
      'estado': 'CUBIERTO',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título con flecha de regreso
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: const Color(0xff1b3a6b)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Recibos()),
                  );
                },
              ),
              Expanded(
                child: Text(
                  "Histórico de recibos",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1b3a6b),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tabla de recibos con desplazamiento horizontal
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Contenedor para el desplazamiento horizontal
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth:
                            MediaQuery.of(context).size.width -
                            48, // Ancho mínimo de la pantalla menos padding
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
                                    width: 280, // Ancho fijo para descripción
                                    child: Text(
                                      'Descripción',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1b3a6b),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20), // Espacio adicional entre columnas
                                  Container(
                                    width: 150, // Ancho fijo para periodo
                                    child: Text(
                                      'Periodo',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1b3a6b),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 120, // Ancho fijo para importe
                                    child: Text(
                                      'Importe',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1b3a6b),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 120, // Ancho fijo para estado
                                    child: Text(
                                      'Estado',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1b3a6b),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Filas de datos
                          ...recibos.map((recibo) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 280, // Ancho fijo para descripción
                                      child: Text(
                                        recibo['descripcion'],
                                        style: TextStyle(fontSize: 13),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 20), // Espacio adicional entre columnas
                                    Container(
                                      width: 150, // Ancho fijo para periodo
                                      child: Text(
                                        recibo['periodo'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      width: 120, // Ancho fijo para importe
                                      child: Text(
                                        '\$${recibo['importe'].toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      width: 120, // Ancho fijo para estado
                                      child: Text(
                                        recibo['estado'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                  // Pie de página con paginación
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
        ],
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
                      value: _rowsPerPage,
                      icon: Icon(Icons.arrow_drop_down, size: 20),
                      iconSize: 20,
                      elevation: 16,
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(height: 0),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => _rowsPerPage = newValue);
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
              Text('1-2 de 2', style: TextStyle(fontSize: 13)),
              Row(
                children: [
                  _buildPageButton(
                    Icons.keyboard_double_arrow_left,
                    _currentPageIndex > 0,
                    () => setState(() => _currentPageIndex = 0),
                  ),
                  _buildPageButton(
                    Icons.keyboard_arrow_left,
                    _currentPageIndex > 0,
                    () => setState(() => _currentPageIndex--),
                  ),
                  _buildPageButton(
                    Icons.keyboard_arrow_right,
                    (_currentPageIndex + 1) * _rowsPerPage < recibos.length,
                    () => setState(() => _currentPageIndex++),
                  ),
                  _buildPageButton(
                    Icons.keyboard_double_arrow_right,
                    (_currentPageIndex + 1) * _rowsPerPage < recibos.length,
                    () => setState(() => _currentPageIndex = (recibos.length - 1) ~/ _rowsPerPage),
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
                      value: _rowsPerPage,
                      icon: Icon(Icons.arrow_drop_down, size: 20),
                      iconSize: 20,
                      elevation: 16,
                      isDense: true,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(height: 0),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => _rowsPerPage = newValue);
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
              Text('1-2 de 2', style: TextStyle(fontSize: 13)),
              SizedBox(width: 8),
              _buildPageButton(
                Icons.keyboard_double_arrow_left,
                _currentPageIndex > 0,
                () => setState(() => _currentPageIndex = 0),
              ),
              _buildPageButton(
                Icons.keyboard_arrow_left,
                _currentPageIndex > 0,
                () => setState(() => _currentPageIndex--),
              ),
              _buildPageButton(
                Icons.keyboard_arrow_right,
                (_currentPageIndex + 1) * _rowsPerPage < recibos.length,
                () => setState(() => _currentPageIndex++),
              ),
              _buildPageButton(
                Icons.keyboard_double_arrow_right,
                (_currentPageIndex + 1) * _rowsPerPage < recibos.length,
                () => setState(() => _currentPageIndex = (recibos.length - 1) ~/ _rowsPerPage),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildPageButton(
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
  ) {
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
}