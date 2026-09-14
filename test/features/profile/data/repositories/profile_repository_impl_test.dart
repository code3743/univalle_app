import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/profile/data/datasources/sira_profile_remote_datasource.dart';
import 'package:univalle_app/features/profile/data/models/student_model.dart';
import 'package:univalle_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:univalle_app/features/profile/domain/entities/student.dart';

class MockSiraProfileRemoteDataSource extends Mock
    implements SiraProfileRemoteDataSource {}

void main() {
  late MockSiraProfileRemoteDataSource remote;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = MockSiraProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(remote);
  });

  test('returns the student mapped to an entity', () async {
    when(() => remote.fetchStudent(username: 'jperez')).thenAnswer(
      (_) async => const StudentModel(
        documentId: '123',
        firstName: 'Juan',
        lastName: 'Perez',
        email: 'jperez@correounivalle.edu.co',
        programName: 'Ingeniería de Sistemas',
        campus: 'Meléndez',
        average: 4.2,
        accumulatedCredits: 90,
      ),
    );

    final result = await repository.getStudent(username: 'jperez');

    expect(result, isA<Ok<Student>>());
    expect((result as Ok<Student>).value.firstName, 'Juan');
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchStudent(username: 'jperez'))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getStudent(username: 'jperez');

    expect((result as Err<Student>).failure, isA<ServerFailure>());
  });
}
