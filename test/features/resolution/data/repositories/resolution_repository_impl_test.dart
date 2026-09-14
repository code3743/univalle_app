import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/resolution/data/datasources/sira_resolution_remote_datasource.dart';
import 'package:univalle_app/features/resolution/data/models/curriculum_subject_model.dart';
import 'package:univalle_app/features/resolution/data/repositories/resolution_repository_impl.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';

class MockSiraResolutionRemoteDataSource extends Mock
    implements SiraResolutionRemoteDataSource {}

void main() {
  late MockSiraResolutionRemoteDataSource remote;
  late ResolutionRepositoryImpl repository;

  setUp(() {
    remote = MockSiraResolutionRemoteDataSource();
    repository = ResolutionRepositoryImpl(remote);
  });

  test('wraps the mapped subjects in a Curriculum', () async {
    when(() => remote.fetchCurriculum(username: 'jperez')).thenAnswer(
      (_) async => [
        CurriculumSubjectModel(
          code: '101',
          name: 'Cálculo',
          subjectType: 'Fundamentación',
          credits: 4,
          semester: 1,
          prerequisiteCodes: const [],
        ),
      ],
    );

    final result = await repository.getCurriculum(username: 'jperez');

    expect(result, isA<Ok<Curriculum>>());
    expect((result as Ok<Curriculum>).value.subjects, hasLength(1));
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchCurriculum(username: 'jperez'))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getCurriculum(username: 'jperez');

    expect((result as Err<Curriculum>).failure, isA<ServerFailure>());
  });
}
