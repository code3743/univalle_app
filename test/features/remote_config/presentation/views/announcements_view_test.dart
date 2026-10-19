import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcements_page.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/views/announcements_view.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/announcement_card.dart';

import '../../../../helpers/pump_app.dart';
import '../remote_config_fixtures.dart';

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpApp(
      const AnnouncementsView(),
      overrides: [remoteConfigRepositoryProvider.overrideWithValue(repository)],
    );
  }

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<AnnouncementsPage>>();
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(AnnouncementCard), findsNothing);
    completer.complete(Ok(announcementsPage([])));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the announcements', (tester) async {
    when(() => repository.getAnnouncements(page: 1)).thenAnswer(
      (_) async => Ok(announcementsPage([announcement(1), announcement(2)])),
    );

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.announcementsTitle), findsOneWidget);
    expect(find.byType(AnnouncementCard), findsNWidgets(2));
  });

  testWidgets('shows the empty state', (tester) async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(announcementsPage([])));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.announcementsEmptyMessage), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(announcementsPage([announcement(1)])));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(AnnouncementCard), findsOneWidget);
  });

  testWidgets('loads the next page when scrolled near the end', (tester) async {
    final first = [for (var i = 1; i <= 10; i++) announcement(i)];
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(announcementsPage(first, total: 12)));
    when(() => repository.getAnnouncements(page: 2)).thenAnswer(
      (_) async => Ok(
        announcementsPage(
          [announcement(11), announcement(12)],
          page: 2,
          total: 12,
        ),
      ),
    );

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(AnnouncementCard).first,
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();

    verify(() => repository.getAnnouncements(page: 2)).called(1);
  });

  testWidgets('shows a snackbar when loading more fails', (tester) async {
    final first = [for (var i = 1; i <= 10; i++) announcement(i)];
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(announcementsPage(first, total: 20)));
    when(() => repository.getAnnouncements(page: 2))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));

    await pumpView(tester);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.drag(
      find.byType(AnnouncementCard).first,
      const Offset(0, -3000),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text(AppStrings.networkError), findsOneWidget);
  });
}
