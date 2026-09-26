import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcement.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcements_page.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/viewmodels/announcements_view_model.dart';

import '../../../../helpers/container.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

Announcement _announcement(int id) =>
    Announcement(id: id, title: 'a$id', description: 'd$id');

AnnouncementsPage _page(List<Announcement> items, {required bool hasMore}) =>
    AnnouncementsPage(
      items: items,
      page: 1,
      limit: items.isEmpty ? 1 : items.length,
      total: hasMore ? items.length + 1 : items.length,
    );

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
  });

  List<Override> overridesWith(RemoteConfigRepository repo) => [
    remoteConfigRepositoryProvider.overrideWithValue(repo),
  ];

  test('build fetches page 1 and exposes hasMore from the response', () async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(_page([_announcement(1)], hasMore: true)));
    final container = createContainer(overrides: overridesWith(repository));

    final feed = await container.read(announcementsViewModelProvider.future);

    expect(feed.items, hasLength(1));
    expect(feed.hasMore, isTrue);
  });

  test('build throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(announcementsViewModelProvider.future),
      throwsA(same(failure)),
    );
  });

  test('loadMore appends the next page and advances the page cursor', () async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(_page([_announcement(1)], hasMore: true)));
    when(() => repository.getAnnouncements(page: 2))
        .thenAnswer((_) async => Ok(_page([_announcement(2)], hasMore: false)));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(announcementsViewModelProvider.future);

    await container.read(announcementsViewModelProvider.notifier).loadMore();

    final feed = container.read(announcementsViewModelProvider).value!;
    expect(feed.items.map((a) => a.id), [1, 2]);
    expect(feed.hasMore, isFalse);
  });

  test('loadMore is a no-op once the feed has no more pages', () async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(_page([_announcement(1)], hasMore: false)));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(announcementsViewModelProvider.future);

    await container.read(announcementsViewModelProvider.notifier).loadMore();

    verifyNever(() => repository.getAnnouncements(page: 2));
  });
}
