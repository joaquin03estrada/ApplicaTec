import 'package:flutter/material.dart';

class KardexCard extends StatefulWidget {
  final String nombre;
  final String matricula;
  final String carrera;
  final String especialidad;
  final int semestre;
  final String situacion;
  final int creditosAcumulados;
  final int creditosTotales;
  final String periodoIngreso;
  final double porcentajeAvance;

  const KardexCard({
    Key? key,
    required this.nombre,
    required this.matricula,
    required this.carrera,
    required this.especialidad,
    required this.semestre,
    required this.situacion,
    required this.creditosAcumulados,
    required this.creditosTotales,
    required this.periodoIngreso,
    required this.porcentajeAvance,
  }) : super(key: key);

  @override
  _KardexCardState createState() => _KardexCardState();
}

class _KardexCardState extends State<KardexCard> {
  late String _selectedOption;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _options = [widget.carrera, "Inglés"];
    _selectedOption = _options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.badge_outlined, color: Color(0xFF404060), size: 28),
                const SizedBox(width: 12),
                Text(
                  "Kárdex",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a365d),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            
            Text(
              widget.nombre,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a365d),
              ),
            ),
            Text(
              widget.matricula,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),

            const SizedBox(height: 20),

            
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth, 
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedOption,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[600],
                      ),
                      isExpanded: true, 
                      itemHeight: null, 
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      borderRadius: BorderRadius.circular(8),
                      alignment: AlignmentDirectional.centerStart,
                      items:
                          _options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (option == _selectedOption)
                                      Container(
                                        width: constraints.maxWidth - 60,
                                        child: Text(
                                          "Selecciona una carrera",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    Container(
                                      width: constraints.maxWidth - 60,
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Especialidad:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a365d),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.especialidad,
                  style: TextStyle(fontSize: 15, color: Color(0xFF1a365d)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            
            Row(
              children: [    
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Semestre:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.semestre}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Situación:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.situacion,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            
            Row(
              children: [
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Créditos acumulados:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.creditosAcumulados}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Créditos totales:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.creditosTotales}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            
            Row(
              children: [
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Porcentaje de avance:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.porcentajeAvance.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ingreso:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.periodoIngreso,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
