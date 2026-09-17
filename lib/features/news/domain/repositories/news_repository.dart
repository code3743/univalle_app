import '../../../../core/error/result.dart';
import '../entities/news_article.dart';

abstract interface class NewsRepository {
  Future<Result<List<NewsArticle>>> getNews({required int page});
}
