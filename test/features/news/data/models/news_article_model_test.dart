import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/news/data/models/news_article_model.dart';

void main() {
  test('toEntity maps every field', () {
    const model = NewsArticleModel(
      title: 'Título',
      summary: 'Resumen',
      sourceUrl: 'https://www.univalle.edu.co/noticia',
      imageUrl: 'https://www.univalle.edu.co/imagen.jpg',
      category: 'Categoría',
    );

    final entity = model.toEntity();

    expect(entity.title, 'Título');
    expect(entity.summary, 'Resumen');
    expect(entity.sourceUrl, 'https://www.univalle.edu.co/noticia');
    expect(entity.imageUrl, 'https://www.univalle.edu.co/imagen.jpg');
    expect(entity.category, 'Categoría');
  });

  test('toEntity keeps optional fields null when absent', () {
    const model = NewsArticleModel(
      title: 'Título',
      summary: 'Resumen',
      sourceUrl: 'https://www.univalle.edu.co/noticia',
    );

    final entity = model.toEntity();

    expect(entity.imageUrl, isNull);
    expect(entity.category, isNull);
  });
}
