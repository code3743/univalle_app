import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/domain/usecases/restore_session_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RestoreSessionUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RestoreSessionUseCase(repository);
  });

  test('returns the restored session when one exists', () async {
    const session = AuthSession(
      username: 'jperez',
      photoUrl: 'https://x/y.jpg',
    );
    when(() => repository.restoreSession())
        .thenAnswer((_) async => const Ok(session));

    final result = await useCase.call();

    expect((result as Ok<AuthSession?>).value, session);
  });

  test('returns null when there is no saved session', () async {
    when(() => repository.restoreSession())
        .thenAnswer((_) async => const Ok(null));

    final result = await useCase.call();

    expect((result as Ok<AuthSession?>).value, isNull);
  });
}
