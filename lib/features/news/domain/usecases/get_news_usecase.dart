import '../../../../core/error/result.dart';
import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository _repository;
  const GetNewsUseCase(this._repository);

  Future<Result<List<NewsArticle>>> call({required int page}) {
    return _repository.getNews(page: page);
  }
}
