import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_providers.dart';
import 'package:univalle_app/features/teaching_rating/presentation/viewmodels/teachers_to_rate_view_model.dart';

import '../../../../helpers/container.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

const _teacher = TeacherToRate(
  id: '1',
  teacherName: 'Prof',
  subjectName: 'Cálculo',
  subjectCode: '101',
  group: '01',
  campusId: '1',
  teacherId: 't1',
  teacherDocument: 'doc1',
  programId: 'p1',
  programName: 'Sistemas',
  programCode: 'pc1',
  isQualified: true,
);

void main() {
  late MockTeachingRatingRepository repository;

  setUp(() {
    repository = MockTeachingRatingRepository();
  });

  List<Override> overridesWith(TeachingRatingRepository repo) => [
    teachingRatingRepositoryProvider.overrideWithValue(repo),
  ];

  test('returns the teachers pending evaluation', () async {
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => const Ok([_teacher]));
    final container = createContainer(overrides: overridesWith(repository));

    final result = await container.read(teachersToRateViewModelProvider.future);

    expect(result, [_teacher]);
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(teachersToRateViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
