import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/auth/presentation/viewmodels/reset_password_view_model.dart';

import '../../../../helpers/container.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  List<Override> overridesWith(AuthRepository repo) => [
    authRepositoryProvider.overrideWithValue(repo),
  ];

  test('build starts with no email', () async {
    final container = createContainer(overrides: overridesWith(repository));

    final email = await container.read(resetPasswordViewModelProvider.future);

    expect(email, isNull);
  });

  test('resetPassword resolves to the masked email on success', () async {
    when(() => repository.resetPassword(username: 'jdoe'))
        .thenAnswer((_) async => const Ok('j***@correounivalle.edu.co'));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(resetPasswordViewModelProvider.future);

    await container
        .read(resetPasswordViewModelProvider.notifier)
        .resetPassword(username: 'jdoe');

    expect(
      container.read(resetPasswordViewModelProvider).value,
      'j***@correounivalle.edu.co',
    );
  });

  test('resetPassword sets an AsyncError when the repository fails', () async {
    when(() => repository.resetPassword(username: any(named: 'username')))
        .thenAnswer((_) async => Err(UnknownFailure(message: 'boom')));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(resetPasswordViewModelProvider.future);

    await container
        .read(resetPasswordViewModelProvider.notifier)
        .resetPassword(username: 'jdoe');

    expect(container.read(resetPasswordViewModelProvider), isA<AsyncError>());
  });
}
