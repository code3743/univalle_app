import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/student_tabulate/domain/repositories/tabulate_repository.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/tabulate_providers.dart';
import 'package:univalle_app/features/student_tabulate/presentation/viewmodels/tabulate_view_model.dart';

import '../../../../helpers/container.dart';

class MockTabulateRepository extends Mock implements TabulateRepository {}

void main() {
  late MockTabulateRepository repository;

  setUp(() {
    repository = MockTabulateRepository();
  });

  List<Override> overridesWith(TabulateRepository repo) => [
    tabulateRepositoryProvider.overrideWithValue(repo),
  ];

  test('throws a StateError when there is no active session', () async {
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(tabulateViewModelProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('returns the tabulate for the current session username', () async {
    final tabulate = Tabulate(
      html: '<html></html>',
      baseUrl: Uri.parse('https://x'),
    );
    when(() => repository.getTabulate(username: 'jdoe'))
        .thenAnswer((_) async => Ok(tabulate));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final result = await container.read(tabulateViewModelProvider.future);

    expect(result, same(tabulate));
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getTabulate(username: 'jdoe'))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    await expectLater(
      container.read(tabulateViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
