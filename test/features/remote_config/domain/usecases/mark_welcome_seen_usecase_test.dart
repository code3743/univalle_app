import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/mark_welcome_seen_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

void main() {
  late MockRemoteConfigRepository repository;
  late MarkWelcomeSeenUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = MarkWelcomeSeenUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.markWelcomeSeen('abc'))
        .thenAnswer((_) async => const Ok(null));

    final result = await useCase.call('abc');

    expect(result.isOk, isTrue);
    verify(() => repository.markWelcomeSeen('abc')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.markWelcomeSeen('abc'))
        .thenAnswer((_) async => Err<void>(failure));

    final result = await useCase.call('abc');

    expect((result as Err<void>).failure, failure);
  });
}
