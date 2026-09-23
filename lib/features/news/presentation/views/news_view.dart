import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/shimmer/app_shimmer.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import '../../../../core/widgets/shimmer/skeleton_list.dart';
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

  Future<void> _onRefresh() async {
    ref.invalidate(newsViewModelProvider);
    try {
      await ref.read(newsViewModelProvider.future);
    } on Failure {
      // AsyncValueWidget already surfaces the error state below.
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsViewModelProvider);

    return AppScaffold(
      title: NewsStrings.title,
      scrollable: false,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: AsyncValueWidget(
          value: newsState,
          onRetry: () => ref.invalidate(newsViewModelProvider),
          skeleton: const SkeletonList(itemHeight: 112),
          data: (feed) => feed.articles.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: Center(
                        child: Text(
                          NewsStrings.emptyMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: feed.articles.length + (feed.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index >= feed.articles.length) {
                      return const AppShimmer(child: ShimmerBox(height: 112));
                    }
                    return NewsArticleCard(article: feed.articles[index]);
                  },
                ),
        ),
      ),
    );
  }
}
