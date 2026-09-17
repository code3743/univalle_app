import '../../domain/entities/news_article.dart';

class NewsArticleModel {
  final String title;
  final String summary;
  final String sourceUrl;
  final String? imageUrl;
  final String? category;

  const NewsArticleModel({
    required this.title,
    required this.summary,
    required this.sourceUrl,
    this.imageUrl,
    this.category,
  });

  NewsArticle toEntity() => NewsArticle(
    title: title,
    summary: summary,
    sourceUrl: sourceUrl,
    imageUrl: imageUrl,
    category: category,
  );
}
