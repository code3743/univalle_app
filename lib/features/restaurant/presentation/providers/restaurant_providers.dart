import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/restaurant_dio_provider.dart';
import '../../../../core/storage/local_storage_providers.dart';
import '../../data/datasources/restaurant_remote_datasource.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../../domain/usecases/buy_lunches_usecase.dart';
import '../../domain/usecases/get_restaurant_account_usecase.dart';

part 'restaurant_providers.g.dart';

@Riverpod(keepAlive: true)
RestaurantRemoteDataSource restaurantRemoteDataSource(Ref ref) {
  return RestaurantRemoteDataSource(
    ref.watch(restaurantDioProvider),
    ref.watch(restaurantCookieJarProvider),
  );
}

@Riverpod(keepAlive: true)
RestaurantRepository restaurantRepository(Ref ref) {
  return RestaurantRepositoryImpl(
    ref.watch(restaurantRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetRestaurantAccountUseCase getRestaurantAccountUseCase(Ref ref) {
  return GetRestaurantAccountUseCase(ref.watch(restaurantRepositoryProvider));
}

@Riverpod(keepAlive: true)
BuyLunchesUseCase buyLunchesUseCase(Ref ref) {
  return BuyLunchesUseCase(ref.watch(restaurantRepositoryProvider));
}
