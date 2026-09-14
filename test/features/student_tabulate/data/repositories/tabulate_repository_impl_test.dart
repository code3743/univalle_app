import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/student_tabulate/data/datasources/sira_tabulate_remote_datasource.dart';
import 'package:univalle_app/features/student_tabulate/data/repositories/tabulate_repository_impl.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';

class MockSiraTabulateRemoteDataSource extends Mock
    implements SiraTabulateRemoteDataSource {}

void main() {
  late MockSiraTabulateRemoteDataSource remote;
  late TabulateRepositoryImpl repository;

  setUp(() {
    remote = MockSiraTabulateRemoteDataSource();
    repository = TabulateRepositoryImpl(remote);
  });

  test('wraps the raw html with SIRA\'s base url', () async {
    when(() => remote.fetchTabulate(username: 'jperez'))
        .thenAnswer((_) async => '<html>tabulado</html>');

    final result = await repository.getTabulate(username: 'jperez');

    expect(result, isA<Ok<Tabulate>>());
    final tabulate = (result as Ok<Tabulate>).value;
    expect(tabulate.html, '<html>tabulado</html>');
    expect(tabulate.baseUrl, Uri.parse(SiraConstants.baseUrl));
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchTabulate(username: 'jperez'))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getTabulate(username: 'jperez');

    expect((result as Err<Tabulate>).failure, isA<ServerFailure>());
  });
}
