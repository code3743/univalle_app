import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/storage/auth_local_datasource.dart';
import 'package:univalle_app/features/auth/data/datasources/sira_auth_remote_datasource.dart';
import 'package:univalle_app/features/auth/data/datasources/uplanner_remote_datasource.dart';
import 'package:univalle_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';

class MockSiraAuthRemoteDataSource extends Mock
    implements SiraAuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockUplannerRemoteDataSource extends Mock
    implements UplannerRemoteDataSource {}

void main() {
  late MockSiraAuthRemoteDataSource remote;
  late MockAuthLocalDataSource local;
  late MockUplannerRemoteDataSource uplanner;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = MockSiraAuthRemoteDataSource();
    local = MockAuthLocalDataSource();
    uplanner = MockUplannerRemoteDataSource();
    repository = AuthRepositoryImpl(remote, local, uplanner);

    when(
      () => local.saveCredentials(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => local.savePhotoUrl(any())).thenAnswer((_) async {});
    when(() => local.clearCredentials()).thenAnswer((_) async {});
  });

  group('login', () {
    test('logs in, saves credentials and fetches a fresh photo url', () async {
      when(() => remote.login(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async {});
      when(() => uplanner.fetchPhotoUrl(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async => 'https://x/y.jpg');

      final result = await repository.login(
        username: 'jperez',
        password: 'secret',
      );

      final session = (result as Ok<AuthSession>).value;
      expect(session.username, 'jperez');
      expect(session.photoUrl, 'https://x/y.jpg');
      verify(
        () => local.saveCredentials(username: 'jperez', password: 'secret'),
      ).called(1);
      verify(() => local.savePhotoUrl('https://x/y.jpg')).called(1);
    });

    test('succeeds with a null photo url when U-Planner has none', () async {
      when(() => remote.login(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async {});
      when(() => uplanner.fetchPhotoUrl(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async => null);

      final result = await repository.login(
        username: 'jperez',
        password: 'secret',
      );

      expect((result as Ok<AuthSession>).value.photoUrl, isNull);
      verifyNever(() => local.savePhotoUrl(any()));
    });

    test('maps a thrown AppException to a Failure', () async {
      when(() => remote.login(username: 'jperez', password: 'wrong'))
          .thenThrow(const AuthException(message: 'Credenciales inválidas'));

      final result = await repository.login(
        username: 'jperez',
        password: 'wrong',
      );

      expect(result, isA<Err<AuthSession>>());
      expect((result as Err<AuthSession>).failure, isA<AuthFailure>());
      verifyNever(
        () => local.saveCredentials(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });
  });

  group('logout', () {
    test(
      'clears local credentials even when the remote logout throws',
      () async {
        when(() => remote.logout())
            .thenThrow(const NetworkException(message: 'offline'));

        final result = await repository.logout();

        expect(result, isA<Ok<void>>());
        verify(() => local.clearCredentials()).called(1);
      },
    );

    test('clears local credentials when the remote logout succeeds', () async {
      when(() => remote.logout()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, isA<Ok<void>>());
      verify(() => local.clearCredentials()).called(1);
    });
  });

  group('restoreSession', () {
    test('returns Ok(null) when there are no saved credentials', () async {
      when(() => local.getCredentials()).thenAnswer((_) async => null);

      final result = await repository.restoreSession();

      expect((result as Ok<AuthSession?>).value, isNull);
      verifyNever(
        () => remote.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test(
      'reuses the cached photo url without calling U-Planner again',
      () async {
        when(() => local.getCredentials()).thenAnswer(
          (_) async => const StoredCredentials(
            username: 'jperez',
            password: 'secret',
            photoUrl: 'https://cached/photo.jpg',
          ),
        );
        when(() => remote.login(username: 'jperez', password: 'secret'))
            .thenAnswer((_) async {});

        final result = await repository.restoreSession();

        expect(
          (result as Ok<AuthSession?>).value?.photoUrl,
          'https://cached/photo.jpg',
        );
        verifyNever(
          () => uplanner.fetchPhotoUrl(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    test('fetches a fresh photo url when none is cached', () async {
      when(() => local.getCredentials()).thenAnswer(
        (_) async =>
            const StoredCredentials(username: 'jperez', password: 'secret'),
      );
      when(() => remote.login(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async {});
      when(() => uplanner.fetchPhotoUrl(username: 'jperez', password: 'secret'))
          .thenAnswer((_) async => 'https://fresh/photo.jpg');

      final result = await repository.restoreSession();

      expect(
        (result as Ok<AuthSession?>).value?.photoUrl,
        'https://fresh/photo.jpg',
      );
      verify(() => local.savePhotoUrl('https://fresh/photo.jpg')).called(1);
    });

    test(
      'clears stale credentials and returns Ok(null) on AuthException',
      () async {
        when(() => local.getCredentials()).thenAnswer(
          (_) async =>
              const StoredCredentials(username: 'jperez', password: 'stale'),
        );
        when(() => remote.login(username: 'jperez', password: 'stale'))
            .thenThrow(const AuthException(message: 'expired'));

        final result = await repository.restoreSession();

        expect((result as Ok<AuthSession?>).value, isNull);
        verify(() => local.clearCredentials()).called(1);
      },
    );

    test(
      'keeps credentials and returns Ok(null) on any other AppException',
      () async {
        when(() => local.getCredentials()).thenAnswer(
          (_) async =>
              const StoredCredentials(username: 'jperez', password: 'secret'),
        );
        when(() => remote.login(username: 'jperez', password: 'secret'))
            .thenThrow(const NetworkException(message: 'offline'));

        final result = await repository.restoreSession();

        expect((result as Ok<AuthSession?>).value, isNull);
        verifyNever(() => local.clearCredentials());
      },
    );
  });

  group('resetPassword', () {
    test('returns the email the repository reports', () async {
      when(() => remote.resetPassword(username: 'jperez'))
          .thenAnswer((_) async => 'j***@correounivalle.edu.co');

      final result = await repository.resetPassword(username: 'jperez');

      expect((result as Ok<String>).value, 'j***@correounivalle.edu.co');
    });

    test('maps a thrown AppException to a Failure', () async {
      when(
        () => remote.resetPassword(username: 'ghost'),
      ).thenThrow(const ServerException(message: 'no existe', statusCode: 404));

      final result = await repository.resetPassword(username: 'ghost');

      expect((result as Err<String>).failure, isA<ServerFailure>());
    });
  });
}
