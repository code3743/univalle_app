import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';
import 'package:univalle_app/features/resolution/domain/repositories/resolution_repository.dart';
import 'package:univalle_app/features/resolution/presentation/providers/resolution_providers.dart';
import 'package:univalle_app/features/resolution/presentation/viewmodels/resolution_view_model.dart';

import '../../../../helpers/container.dart';

class MockResolutionRepository extends Mock implements ResolutionRepository {}

void main() {
  late MockResolutionRepository repository;

  setUp(() {
    repository = MockResolutionRepository();
  });

  List<Override> overridesWith(ResolutionRepository repo) => [
    resolutionRepositoryProvider.overrideWithValue(repo),
  ];

  test('throws a StateError when there is no active session', () async {
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(resolutionViewModelProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('returns the curriculum for the current session username', () async {
    final curriculum = Curriculum(subjects: []);
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(curriculum));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final result = await container.read(resolutionViewModelProvider.future);

    expect(result, same(curriculum));
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    await expectLater(
      container.read(resolutionViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
