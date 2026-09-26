import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/library/domain/entities/library_account.dart';
import 'package:univalle_app/features/library/domain/repositories/library_repository.dart';
import 'package:univalle_app/features/library/presentation/providers/library_providers.dart';
import 'package:univalle_app/features/library/presentation/viewmodels/library_view_model.dart';

import '../../../../helpers/container.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

void main() {
  late MockLibraryRepository repository;

  setUp(() {
    repository = MockLibraryRepository();
  });

  List<Override> overridesWith(LibraryRepository repo) => [
    libraryRepositoryProvider.overrideWithValue(repo),
  ];

  test('returns the account mapped from the repository', () async {
    const account = LibraryAccount(
      currentFine: '0',
      currentLoans: [],
      history: [],
    );
    when(() => repository.getAccount())
        .thenAnswer((_) async => const Ok(account));
    final container = createContainer(overrides: overridesWith(repository));

    final result = await container.read(libraryViewModelProvider.future);

    expect(result, same(account));
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getAccount()).thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(libraryViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
