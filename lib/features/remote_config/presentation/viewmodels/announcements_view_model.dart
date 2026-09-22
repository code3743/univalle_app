import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/announcement.dart';
import '../providers/remote_config_providers.dart';

part 'announcements_view_model.g.dart';

class AnnouncementsFeed {
  final List<Announcement> items;
  final bool hasMore;
  const AnnouncementsFeed({required this.items, required this.hasMore});
}

@riverpod
class AnnouncementsViewModel extends _$AnnouncementsViewModel {
  int _page = 1;
  bool _isLoadingMore = false;

  @override
  Future<AnnouncementsFeed> build() async {
    _page = 1;
    final result = await ref
        .read(getAnnouncementsUseCaseProvider)
        .call(page: _page);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (page) =>
          AnnouncementsFeed(items: page.items, hasMore: page.hasMore),
    );
  }

  Future<void> loadMore() async {
    final feed = state.value;
    if (feed == null || !feed.hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final result = await ref
          .read(getAnnouncementsUseCaseProvider)
          .call(page: nextPage);
      result.fold(
        onError: (failure) => throw failure,
        onSuccess: (page) {
          _page = nextPage;
          state = AsyncData(
            AnnouncementsFeed(
              items: [...feed.items, ...page.items],
              hasMore: page.hasMore,
            ),
          );
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
