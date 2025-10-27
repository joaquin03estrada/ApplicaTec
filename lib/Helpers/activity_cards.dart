import 'package:flutter/material.dart';

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

class ExtraschoolActivity {
  final String code;
  final String name;
  final String period;
  final double score;
  final String evaluation;
  final int credits;

  const ExtraschoolActivity({
    required this.code,
    required this.name,
    required this.period,
    required this.score,
    required this.evaluation,
    required this.credits,
  });
}

class ExtraschoolActivityContent extends StatelessWidget {
  final ExtraschoolActivity activity;
  final VoidCallback onDownload;

  const ExtraschoolActivityContent({
    Key? key,
    required this.activity,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${activity.code} - ${activity.name}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download, color: Colors.black87),
              onPressed: onDownload,
              tooltip: 'Descargar información',
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          'Periodo: ${activity.period}',
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Calificación: ${activity.score.toStringAsFixed(2)} (${activity.evaluation}) - Créditos: ${activity.credits}',
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ],
    );
  }
}