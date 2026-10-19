import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/domain/usecases/get_app_config_usecase.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

class _FakeAppConfig extends Fake implements AppConfig {}

void main() {
  late MockRemoteConfigRepository repository;
  late GetAppConfigUseCase useCase;

  setUp(() {
    repository = MockRemoteConfigRepository();
    useCase = GetAppConfigUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.getConfig(platform: 'android', version: '1.0.0'))
        .thenAnswer((_) async => Ok(_FakeAppConfig()));

    final result = await useCase.call(platform: 'android', version: '1.0.0');

    expect(result.isOk, isTrue);
    verify(() => repository.getConfig(platform: 'android', version: '1.0.0'))
        .called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getConfig(platform: 'android', version: '1.0.0'))
        .thenAnswer((_) async => Err<AppConfig>(failure));

    final result = await useCase.call(platform: 'android', version: '1.0.0');

    expect((result as Err<AppConfig>).failure, failure);
  });
}
