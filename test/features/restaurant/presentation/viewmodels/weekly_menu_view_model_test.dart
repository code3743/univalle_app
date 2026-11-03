import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/di/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/domain/entities/weekly_menu.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_menu_repository.dart';
import 'package:univalle_app/features/restaurant/presentation/viewmodels/weekly_menu_view_model.dart';

import '../../../../helpers/container.dart';

class MockRestaurantMenuRepository extends Mock
    implements RestaurantMenuRepository {}

void main() {
  late MockRestaurantMenuRepository repository;

  setUp(() {
    repository = MockRestaurantMenuRepository();
  });

  test('returns the weekly menu on success', () async {
    const menu = WeeklyMenu(weekLabel: 'Semana 1', days: []);
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => const Ok(menu));
    final container = createContainer(
      overrides: [
        restaurantMenuRepositoryProvider.overrideWithValue(repository),
      ],
    );

    final result = await container.read(weeklyMenuViewModelProvider.future);

    expect(result.weekLabel, 'Semana 1');
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(
      overrides: [
        restaurantMenuRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await expectLater(
      container.read(weeklyMenuViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
