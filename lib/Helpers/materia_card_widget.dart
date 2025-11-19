import 'package:flutter/material.dart';

class MateriaCardWidget extends StatelessWidget {
  final String claveMat;
  final String nombreMat;
  final int? calificacion;
  final String estatus;
  final int? creditos;

  const MateriaCardWidget({
    Key? key,
    required this.claveMat,
    required this.nombreMat,
    this.calificacion,
    required this.estatus,
    this.creditos,
  }) : super(key: key);

  Color _getColorPorEstatus() {
    switch (estatus) {
      case 'Aprobado':
        return Color(0xFFB8E6B8); // Verde claro
      case 'Reprobado':
        return Color(0xFFFFB8B8); // Rojo claro
      case 'Cursando':
        return Color(0xFFFFF4B8); // Amarillo claro
      case 'No Cursado':
        return Color(0xFFE0E0E0); // Gris
      default:
        return Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130, // Altura fija
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _getColorPorEstatus(),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.black87,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clave de materia
          Text(
            claveMat,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a365d),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 4),
          
          // Nombre de materia (solo si es diferente de la clave)
          if (nombreMat != claveMat)
            Expanded(
              child: Text(
                nombreMat,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Spacer(),
          
          SizedBox(height: 4),
          
          // Calificación
          if (calificacion != null)
            Text(
              'Calificación: $calificacion',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            SizedBox(height: 12),
          
          // Créditos
          if (creditos != null)
            Text(
              'Créditos: $creditos',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          
          Spacer(),
        ],
      ),
    );
  }
}