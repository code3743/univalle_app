import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';
import 'package:univalle_app/features/resolution/domain/repositories/resolution_repository.dart';
import 'package:univalle_app/features/resolution/domain/usecases/get_curriculum_usecase.dart';

class MockResolutionRepository extends Mock implements ResolutionRepository {}

void main() {
  late MockResolutionRepository repository;
  late GetCurriculumUseCase useCase;

  setUp(() {
    repository = MockResolutionRepository();
    useCase = GetCurriculumUseCase(repository);
  });

  test('forwards the username to the repository', () async {
    final curriculum = Curriculum(subjects: []);
    when(() => repository.getCurriculum(username: 'jperez'))
        .thenAnswer((_) async => Ok(curriculum));

    final result = await useCase.call(username: 'jperez');

    expect((result as Ok<Curriculum>).value, curriculum);
    verify(() => repository.getCurriculum(username: 'jperez')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getCurriculum(username: 'jperez'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'jperez');

    expect((result as Err<Curriculum>).failure, failure);
  });
}
