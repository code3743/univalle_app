import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcements_page.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/get_announcements_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

class _FakeAnnouncementsPage extends Fake implements AnnouncementsPage {}

void main() {
  late MockRemoteConfigRepository repository;
  late GetAnnouncementsUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = GetAnnouncementsUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Ok(_FakeAnnouncementsPage()));

    final result = await useCase.call(page: 1);

    expect(result.isOk, isTrue);
    verify(() => repository.getAnnouncements(page: 1)).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getAnnouncements(page: 1))
        .thenAnswer((_) async => Err<AnnouncementsPage>(failure));

    final result = await useCase.call(page: 1);

    expect((result as Err<AnnouncementsPage>).failure, failure);
  });
}
