import 'package:flutter/material.dart';
import 'package:applicatec/models/EstudianteActividadModel.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final Widget content;

  const ActivityCard({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: Colors.grey[700],
                    size: 24.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b3a6b),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0, thickness: 1.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyActivityContent extends StatelessWidget {
  final String message;

  const EmptyActivityContent({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
    );
  }
}

class LoadingActivityContent extends StatelessWidget {
  const LoadingActivityContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          color: Color(0xff1b3a6b),
        ),
      ),
    );
  }
}

// Widget genérico para mostrar actividades
class ActividadesContent extends StatelessWidget {
  final List<EstudianteActividadModel> actividades;

  const ActividadesContent({
    Key? key,
    required this.actividades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: actividades.asMap().entries.map((entry) {
        int index = entry.key;
        EstudianteActividadModel estudianteActividad = entry.value;
        final actividad = estudianteActividad.actividad;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${actividad?.claveAct ?? 'N/A'} - ${actividad?.nombre ?? 'Sin nombre'}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                'Periodo: ${estudianteActividad.periodo ?? 'N/A'}',
                style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                'Calificación: ${estudianteActividad.calificacion ?? 'N/A'} - Créditos: ${actividad?.creditos ?? 0}',
                style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              if (index < actividades.length - 1)
                const Divider(height: 24.0, thickness: 1.0),
            ],
          ),
        );
      }).toList(),
    );
  }
}