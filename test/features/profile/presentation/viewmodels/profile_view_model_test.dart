import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/profile/domain/entities/student.dart';
import 'package:univalle_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:univalle_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:univalle_app/features/profile/presentation/viewmodels/profile_view_model.dart';

import '../../../../helpers/container.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

const _student = Student(
  documentId: '123',
  firstName: 'Jane',
  lastName: 'Doe',
  email: 'jane@correounivalle.edu.co',
  programName: 'Ingeniería de Sistemas',
  campus: 'Meléndez',
  average: 4.2,
  accumulatedCredits: 90,
);

void main() {
  late MockProfileRepository repository;

  setUp(() {
    repository = MockProfileRepository();
  });

  List<Override> overridesWith(ProfileRepository repo) => [
    profileRepositoryProvider.overrideWithValue(repo),
  ];

  test('throws a StateError when there is no active session', () async {
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(profileViewModelProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('returns the student for the current session username', () async {
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => const Ok(_student));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final student = await container.read(profileViewModelProvider.future);

    expect(student, same(_student));
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    await expectLater(
      container.read(profileViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
