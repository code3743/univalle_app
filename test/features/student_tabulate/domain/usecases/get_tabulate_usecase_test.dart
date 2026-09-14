import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/student_tabulate/domain/repositories/tabulate_repository.dart';
import 'package:univalle_app/features/student_tabulate/domain/usecases/get_tabulate_usecase.dart';

class MockTabulateRepository extends Mock implements TabulateRepository {}

void main() {
  late MockTabulateRepository repository;
  late GetTabulateUseCase useCase;

  setUp(() {
    repository = MockTabulateRepository();
    useCase = GetTabulateUseCase(repository);
  });

  test('forwards the username to the repository', () async {
    final tabulate = Tabulate(
      html: '<html></html>',
      baseUrl: Uri.parse('https://sira.univalle.edu.co'),
    );
    when(() => repository.getTabulate(username: 'jperez'))
        .thenAnswer((_) async => Ok(tabulate));

    final result = await useCase.call(username: 'jperez');

    expect((result as Ok<Tabulate>).value, tabulate);
    verify(() => repository.getTabulate(username: 'jperez')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getTabulate(username: 'jperez'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'jperez');

    expect((result as Err<Tabulate>).failure, failure);
  });
}
