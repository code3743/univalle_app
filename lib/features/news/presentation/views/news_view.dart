import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../news_strings.dart';
import '../viewmodels/news_view_model.dart';
import '../widgets/news_article_card.dart';

class NewsView extends ConsumerStatefulWidget {
  const NewsView({super.key});

  @override
  ConsumerState<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends ConsumerState<NewsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 300) return;
    _loadMore();
  }

  Future<void> _loadMore() async {
    try {
      await ref.read(newsViewModelProvider.notifier).loadMore();
    } on Failure catch (failure) {
      if (mounted) context.showSnack(failure.userMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsViewModelProvider);

    return AppScaffold(
      title: NewsStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: newsState,
        onRetry: () => ref.invalidate(newsViewModelProvider),
        data: (feed) => feed.articles.isEmpty
            ? Center(
                child: Text(
                  NewsStrings.emptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : ListView.separated(
                controller: _scrollController,
                itemCount: feed.articles.length + (feed.hasMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (index >= feed.articles.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Center(child: AppLoadingIndicator()),
                    );
                  }
                  return NewsArticleCard(article: feed.articles[index]);
                },
              ),
      ),
    );
  }
}
