import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_photo_url_provider.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/auth/presentation/viewmodels/auth_view_model.dart';

import '../../../../helpers/container.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  List<Override> overridesWith(AuthRepository repo) => [
    authRepositoryProvider.overrideWithValue(repo),
  ];

  group('build (restoreSession)', () {
    test(
      'hydrates the session providers and returns true when a session exists',
      () async {
        when(() => repository.restoreSession()).thenAnswer(
          (_) async => const Ok(
            AuthSession(username: 'jdoe', photoUrl: 'https://x/p.jpg'),
          ),
        );
        final container = createContainer(overrides: overridesWith(repository));

        final loggedIn = await container.read(authViewModelProvider.future);

        expect(loggedIn, isTrue);
        expect(container.read(currentUsernameProvider), 'jdoe');
        expect(container.read(currentPhotoUrlProvider), 'https://x/p.jpg');
      },
    );

    test('returns false without touching session providers when there is no session', () async {
      when(() => repository.restoreSession())
          .thenAnswer((_) async => const Ok(null));
      final container = createContainer(overrides: overridesWith(repository));

      final loggedIn = await container.read(authViewModelProvider.future);

      expect(loggedIn, isFalse);
      expect(container.read(currentUsernameProvider), isNull);
    });

    test('returns false when restoring the session fails', () async {
      when(() => repository.restoreSession())
          .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      final container = createContainer(overrides: overridesWith(repository));

      final loggedIn = await container.read(authViewModelProvider.future);

      expect(loggedIn, isFalse);
    });
  });

  group('login', () {
    test(
      'hydrates session providers and resolves to true on success',
      () async {
        when(() => repository.restoreSession())
            .thenAnswer((_) async => const Ok(null));
        when(() => repository.login(username: 'jdoe', password: 'secret'))
            .thenAnswer(
              (_) async =>
                  const Ok(AuthSession(username: 'jdoe', photoUrl: null)),
            );
        final container = createContainer(overrides: overridesWith(repository));
        await container.read(authViewModelProvider.future);

        await container
            .read(authViewModelProvider.notifier)
            .login(username: 'jdoe', password: 'secret');

        expect(container.read(authViewModelProvider).value, isTrue);
        expect(container.read(currentUsernameProvider), 'jdoe');
      },
    );

    test('sets an AsyncError when the credentials are rejected', () async {
      when(() => repository.restoreSession())
          .thenAnswer((_) async => const Ok(null));
      when(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Err(AuthFailure(message: 'bad credentials')));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(authViewModelProvider.future);

      await container
          .read(authViewModelProvider.notifier)
          .login(username: 'jdoe', password: 'wrong');

      expect(container.read(authViewModelProvider), isA<AsyncError>());
    });
  });

  group('logout', () {
    test('clears session providers and resolves to false on success', () async {
      when(() => repository.restoreSession()).thenAnswer(
        (_) async => const Ok(AuthSession(username: 'jdoe', photoUrl: 'x')),
      );
      when(() => repository.logout()).thenAnswer((_) async => const Ok(null));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(authViewModelProvider.future);

      await container.read(authViewModelProvider.notifier).logout();

      expect(container.read(authViewModelProvider).value, isFalse);
      expect(container.read(currentUsernameProvider), isNull);
      expect(container.read(currentPhotoUrlProvider), isNull);
    });

    test('sets an AsyncError when the repository fails', () async {
      when(() => repository.restoreSession())
          .thenAnswer((_) async => const Ok(null));
      when(() => repository.logout())
          .thenAnswer((_) async => Err(UnknownFailure(message: 'boom')));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(authViewModelProvider.future);

      await container.read(authViewModelProvider.notifier).logout();

      expect(container.read(authViewModelProvider), isA<AsyncError>());
    });
  });
}
