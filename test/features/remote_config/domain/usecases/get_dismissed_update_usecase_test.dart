import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/get_dismissed_update_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

void main() {
  late MockRemoteConfigRepository repository;
  late GetDismissedUpdateUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = GetDismissedUpdateUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.getDismissedUpdate())
        .thenAnswer((_) async => const Ok('2.0.0'));

    final result = await useCase.call();

    expect(result.isOk, isTrue);
    verify(() => repository.getDismissedUpdate()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getDismissedUpdate())
        .thenAnswer((_) async => Err<String?>(failure));

    final result = await useCase.call();

    expect((result as Err<String?>).failure, failure);
  });
}
