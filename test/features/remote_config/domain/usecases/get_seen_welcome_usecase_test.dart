import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/get_seen_welcome_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

void main() {
  late MockRemoteConfigRepository repository;
  late GetSeenWelcomeUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = GetSeenWelcomeUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.getSeenWelcome())
        .thenAnswer((_) async => const Ok('abc'));

    final result = await useCase.call();

    expect(result.isOk, isTrue);
    verify(() => repository.getSeenWelcome()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getSeenWelcome())
        .thenAnswer((_) async => Err<String?>(failure));

    final result = await useCase.call();

    expect((result as Err<String?>).failure, failure);
  });
}
