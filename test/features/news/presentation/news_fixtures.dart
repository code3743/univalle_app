import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/news/domain/entities/news_article.dart';
import 'package:univalle_app/features/news/domain/repositories/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

NewsArticle article(int id, {String? imageUrl, String? category}) =>
    NewsArticle(
      title: 'Noticia $id',
      summary: 'Resumen $id',
      sourceUrl: 'https://news.example/$id',
      imageUrl: imageUrl,
      category: category,
    );
