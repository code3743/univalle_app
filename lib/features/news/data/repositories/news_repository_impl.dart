import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remote;
  const NewsRepositoryImpl(this._remote);

  @override
  Future<Result<List<NewsArticle>>> getNews({required int page}) async {
    try {
      final articles = await _remote.fetchNews(page: page);
      return Ok(articles.map((article) => article.toEntity()).toList());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}
