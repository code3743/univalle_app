import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/domain/usecases/reset_password_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late ResetPasswordUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = ResetPasswordUseCase(repository);
  });

  test(
    'forwards the username to the repository and returns its success message',
    () async {
      when(() => repository.resetPassword(username: 'jperez'))
          .thenAnswer((_) async => const Ok('Revisa tu correo institucional'));

      final result = await useCase.call(username: 'jperez');

      expect(result, isA<Ok<String>>());
      expect((result as Ok<String>).value, 'Revisa tu correo institucional');
      verify(() => repository.resetPassword(username: 'jperez')).called(1);
    },
  );

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'no existe');
    when(() => repository.resetPassword(username: 'ghost'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'ghost');

    expect(result, isA<Err<String>>());
    expect((result as Err<String>).failure, failure);
  });
}
