import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/news_constants.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../models/news_article_model.dart';

class NewsRemoteDataSource {
  final Dio _dio;
  const NewsRemoteDataSource(this._dio);

  Future<List<NewsArticleModel>> fetchNews({required int page}) async {
    final response = await _run(
      () => _dio.get(
        NewsConstants.listPath,
        queryParameters: page == 0
            ? null
            : {'start': page * NewsConstants.itemsPerPage},
      ),
    );

    final document = parse(response.data as String);
    return document
        .querySelectorAll(NewsConstants.itemSelector)
        .map(_parseArticle)
        .whereType<NewsArticleModel>()
        .toList();
  }

  NewsArticleModel? _parseArticle(Element item) {
    final titleAnchor = item.querySelector(NewsConstants.titleLinkSelector);
    final title = titleAnchor?.text.trim();
    final href = titleAnchor?.attributes['href'];
    if (title == null || title.isEmpty || href == null) return null;

    final imageSrc = item
        .querySelector(NewsConstants.imageSelector)
        ?.attributes['src'];
    final category = item
        .querySelector(NewsConstants.categorySelector)
        ?.text
        .trim();

    return NewsArticleModel(
      title: title,
      summary:
          item.querySelector(NewsConstants.summarySelector)?.text.trim() ?? '',
      sourceUrl: _toAbsoluteUrl(href),
      imageUrl: imageSrc == null ? null : _toAbsoluteUrl(imageSrc),
      category: category == null || category.isEmpty ? null : category,
    );
  }

  String _toAbsoluteUrl(String path) {
    return Uri.parse(NewsConstants.baseUrl).resolve(path).toString();
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
