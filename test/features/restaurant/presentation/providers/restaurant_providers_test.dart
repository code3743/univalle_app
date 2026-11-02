import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univalle_app/core/storage/local_storage_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';

import '../../../../helpers/container.dart';

void main() {
  test(
    'wires the restaurant data sources, repositories and use cases',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = createContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );

      expect(container.read(restaurantRemoteDataSourceProvider), isNotNull);
      expect(container.read(restaurantRepositoryProvider), isNotNull);
      expect(container.read(getRestaurantAccountUseCaseProvider), isNotNull);
      expect(container.read(buyLunchesUseCaseProvider), isNotNull);
      expect(container.read(restaurantMenuRemoteDataSourceProvider), isNotNull);
      expect(container.read(restaurantMenuRepositoryProvider), isNotNull);
      expect(container.read(getWeeklyMenuUseCaseProvider), isNotNull);
    },
  );
}
