import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../home/home_strings.dart';
import '../viewmodels/announcements_view_model.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsView extends ConsumerStatefulWidget {
  const AnnouncementsView({super.key});

  @override
  ConsumerState<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends ConsumerState<AnnouncementsView> {
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
      await ref.read(announcementsViewModelProvider.notifier).loadMore();
    } on Failure catch (failure) {
      if (mounted) context.showSnack(failure.userMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementsState = ref.watch(announcementsViewModelProvider);

    return AppScaffold(
      title: HomeStrings.announcementsTitle,
      scrollable: false,
      body: AsyncValueWidget(
        value: announcementsState,
        onRetry: () => ref.invalidate(announcementsViewModelProvider),
        data: (feed) => feed.items.isEmpty
            ? Center(
                child: Text(
                  HomeStrings.announcementsEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : ListView.separated(
                controller: _scrollController,
                itemCount: feed.items.length + (feed.hasMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (index >= feed.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Center(child: AppLoadingIndicator()),
                    );
                  }
                  return AnnouncementCard(announcement: feed.items[index]);
                },
              ),
      ),
    );
  }
}
