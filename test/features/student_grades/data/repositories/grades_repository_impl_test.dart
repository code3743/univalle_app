import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/student_grades/data/datasources/sira_grades_remote_datasource.dart';
import 'package:univalle_app/features/student_grades/data/models/academic_history_model.dart';
import 'package:univalle_app/features/student_grades/data/models/grades_model.dart';
import 'package:univalle_app/features/student_grades/data/repositories/grades_repository_impl.dart';
import 'package:univalle_app/features/student_grades/domain/entities/academic_history.dart';

class MockSiraGradesRemoteDataSource extends Mock
    implements SiraGradesRemoteDataSource {}

void main() {
  late MockSiraGradesRemoteDataSource remote;
  late GradesRepositoryImpl repository;

  setUp(() {
    remote = MockSiraGradesRemoteDataSource();
    repository = GradesRepositoryImpl(remote);
  });

  test('returns the periods mapped to entities', () async {
    when(() => remote.fetchGrades(username: 'jperez')).thenAnswer(
      (_) async => const AcademicHistoryModel(
        periods: [
          GradesModel(
            period: 'Feb/22 – Jun/22',
            average: 4.1,
            credits: 18,
            approvedPercentage: '100%',
            hasAcademicMerit: false,
            subjects: [],
          ),
        ],
        equivalences: [],
      ),
    );

    final result = await repository.getGrades(username: 'jperez');

    expect(result, isA<Ok<AcademicHistory>>());
    expect((result as Ok<AcademicHistory>).value.periods, hasLength(1));
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchGrades(username: 'jperez'))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getGrades(username: 'jperez');

    expect((result as Err<AcademicHistory>).failure, isA<ServerFailure>());
  });
}
