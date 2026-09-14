import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LogoutUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LogoutUseCase(repository);
  });

  test('delegates to the repository and returns its success result', () async {
    when(() => repository.logout()).thenAnswer((_) async => const Ok(null));

    final result = await useCase.call();

    expect(result, isA<Ok<void>>());
    verify(() => repository.logout()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.logout()).thenAnswer((_) async => Err(failure));

    final result = await useCase.call();

    expect(result, isA<Err<void>>());
    expect((result as Err<void>).failure, failure);
  });
}
