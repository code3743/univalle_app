import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('forwards username and password to the repository', () async {
    const session = AuthSession(username: 'jperez');
    when(() => repository.login(username: 'jperez', password: 'secret'))
        .thenAnswer((_) async => const Ok(session));

    final result = await useCase.call(username: 'jperez', password: 'secret');

    expect(result, isA<Ok<AuthSession>>());
    expect((result as Ok<AuthSession>).value, session);
    verify(() => repository.login(username: 'jperez', password: 'secret'))
        .called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = AuthFailure(message: 'Credenciales inválidas');
    when(() => repository.login(username: 'jperez', password: 'wrong'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'jperez', password: 'wrong');

    expect(result, isA<Err<AuthSession>>());
    expect((result as Err<AuthSession>).failure, failure);
  });
}
