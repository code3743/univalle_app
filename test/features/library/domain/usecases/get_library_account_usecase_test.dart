import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/library/domain/entities/library_account.dart';
import 'package:univalle_app/features/library/domain/repositories/library_repository.dart';
import 'package:univalle_app/features/library/domain/usecases/get_library_account_usecase.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

void main() {
  late MockLibraryRepository repository;
  late GetLibraryAccountUseCase useCase;

  setUp(() {
    repository = MockLibraryRepository();
    useCase = GetLibraryAccountUseCase(repository);
  });

  test('returns the account from the repository', () async {
    const account = LibraryAccount(
      currentFine: r'$0',
      currentLoans: [],
      history: [],
    );
    when(() => repository.getAccount())
        .thenAnswer((_) async => const Ok(account));

    final result = await useCase.call();

    expect((result as Ok<LibraryAccount>).value, account);
    verify(() => repository.getAccount()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getAccount()).thenAnswer((_) async => Err(failure));

    final result = await useCase.call();

    expect((result as Err<LibraryAccount>).failure, failure);
  });
}
