import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/storage/auth_local_datasource.dart';
import 'package:univalle_app/features/library/data/datasources/library_remote_datasource.dart';
import 'package:univalle_app/features/library/data/models/library_account_model.dart';
import 'package:univalle_app/features/library/data/repositories/library_repository_impl.dart';
import 'package:univalle_app/features/library/domain/entities/library_account.dart';

class MockLibraryRemoteDataSource extends Mock
    implements LibraryRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockLibraryRemoteDataSource remote;
  late MockAuthLocalDataSource credentials;
  late LibraryRepositoryImpl repository;

  setUp(() {
    remote = MockLibraryRemoteDataSource();
    credentials = MockAuthLocalDataSource();
    repository = LibraryRepositoryImpl(remote, credentials);
  });

  test(
    'returns the account mapped to an entity when credentials exist',
    () async {
      when(() => credentials.getCredentials()).thenAnswer(
        (_) async => const StoredCredentials(username: 'jperez', password: 'x'),
      );
      when(() => remote.fetchAccount(username: 'jperez')).thenAnswer(
        (_) async => const LibraryAccountModel(
          currentFine: r'$0',
          currentLoans: [],
          history: [],
        ),
      );

      final result = await repository.getAccount();

      expect(result, isA<Ok<LibraryAccount>>());
      expect((result as Ok<LibraryAccount>).value.currentFine, r'$0');
    },
  );

  test('returns an AuthFailure when there are no saved credentials', () async {
    when(() => credentials.getCredentials()).thenAnswer((_) async => null);

    final result = await repository.getAccount();

    expect(result, isA<Err<LibraryAccount>>());
    expect((result as Err<LibraryAccount>).failure, isA<AuthFailure>());
    verifyNever(() => remote.fetchAccount(username: any(named: 'username')));
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => credentials.getCredentials()).thenAnswer(
      (_) async => const StoredCredentials(username: 'jperez', password: 'x'),
    );
    when(() => remote.fetchAccount(username: 'jperez'))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getAccount();

    expect((result as Err<LibraryAccount>).failure, isA<ServerFailure>());
  });
}
