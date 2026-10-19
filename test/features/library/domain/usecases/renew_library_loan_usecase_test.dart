import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/library/domain/repositories/library_repository.dart';
import 'package:univalle_app/features/library/domain/usecases/renew_library_loan_usecase.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

void main() {
  late MockLibraryRepository repository;
  late RenewLibraryLoanUseCase useCase;

  setUp(() {
    repository = MockLibraryRepository();
    useCase = RenewLibraryLoanUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.renewLoan('123'))
        .thenAnswer((_) async => const Ok('Renovado'));

    final result = await useCase.call('123');

    expect(result.isOk, isTrue);
    verify(() => repository.renewLoan('123')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.renewLoan('123'))
        .thenAnswer((_) async => Err<String>(failure));

    final result = await useCase.call('123');

    expect((result as Err<String>).failure, failure);
  });
}
