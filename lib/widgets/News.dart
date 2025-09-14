import 'package:applicatec/Helpers/NewsItem.dart';
import 'package:flutter/material.dart';
import 'package:applicatec/Helpers/NewsCard.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final List<NewsItem> newsList = [
    NewsItem(
      title:
          'Estudiantes de Ingeniería Bioquímica presentan proyectos de innovación alimentaria a la directora del ITC',
      imageUrl:
          'https://www.culiacan.tecnm.mx/wp-content/uploads/2025/09/Recorrido-por-los-laboratorios-1.png',
      newsUrl:
          'https://www.culiacan.tecnm.mx/estudiantes-de-ingenieria-bioquimica-presentan-proyectos-de-innovacion-alimentaria-a-la-directora-del-itc/',
    ),
    NewsItem(
      title:
          'Titulación masiva de posgrado en el Instituto Tecnológico de Culiacán',
      imageUrl:
          'https://www.culiacan.tecnm.mx/wp-content/uploads/2025/09/Titulacion-2025-MCD-ciencias-de-la-ingenieria-11.png',
      newsUrl:
          'https://www.culiacan.tecnm.mx/titulacion-masiva-de-posgrado-en-el-instituto-tecnologico-de-culiacan/',
    ),
    NewsItem(
      title:
          'Inaugura director general el Centro de Investigación, Innovación y Desarrollo Tecnológico en Culiacán',
      imageUrl:
          'https://www.culiacan.tecnm.mx/wp-content/uploads/2025/09/INAUGURACION-CIIDETEC-05.jpg',
      newsUrl:
          'https://www.culiacan.tecnm.mx/inaugura-director-general-el-centro-de-investigacion-innovacion-y-desarrollo-tecnologico-en-culiacan/',
    ),
  ];

  List<NewsItem> filteredNews = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    filteredNews = newsList; // Inicialmente muestra todas
  }

  void _filterNews(String query) {
    setState(() {
      searchText = query;
      filteredNews =
          newsList.where((news) {
            final titleLower = news.title.toLowerCase();
            final queryLower = query.toLowerCase();
            return titleLower.contains(queryLower);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b3a6b),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar noticia...',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _filterNews,
              ),
            ),
            Expanded(
              child:
                  filteredNews.isEmpty
                      ? const Center(
                        child: Text(
                          'No se encontraron noticias.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredNews.length,
                        itemBuilder: (context, index) {
                          return NewsCard(newsItem: filteredNews[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
