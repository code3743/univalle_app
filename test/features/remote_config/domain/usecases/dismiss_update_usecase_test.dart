import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/dismiss_update_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

void main() {
  late MockRemoteConfigRepository repository;
  late DismissUpdateUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = DismissUpdateUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.dismissUpdate('2.0.0'))
        .thenAnswer((_) async => const Ok(null));

    final result = await useCase.call('2.0.0');

    expect(result.isOk, isTrue);
    verify(() => repository.dismissUpdate('2.0.0')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.dismissUpdate('2.0.0'))
        .thenAnswer((_) async => Err<void>(failure));

    final result = await useCase.call('2.0.0');

    expect((result as Err<void>).failure, failure);
  });
}
