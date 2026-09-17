import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/news_article.dart';
import '../providers/news_providers.dart';

part 'news_view_model.g.dart';

class NewsFeed {
  final List<NewsArticle> articles;
  final bool hasMore;
  const NewsFeed({required this.articles, required this.hasMore});
}

@riverpod
class NewsViewModel extends _$NewsViewModel {
  int _page = 0;
  bool _isLoadingMore = false;

  @override
  Future<NewsFeed> build() async {
    _page = 0;
    final result = await ref.read(getNewsUseCaseProvider).call(page: _page);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (articles) =>
          NewsFeed(articles: articles, hasMore: articles.isNotEmpty),
    );
  }

  Future<void> loadMore() async {
    final feed = state.value;
    if (feed == null || !feed.hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final result = await ref
          .read(getNewsUseCaseProvider)
          .call(page: nextPage);
      result.fold(
        onError: (failure) => throw failure,
        onSuccess: (articles) {
          _page = nextPage;
          state = AsyncData(
            NewsFeed(
              articles: [...feed.articles, ...articles],
              hasMore: articles.isNotEmpty,
            ),
          );
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
