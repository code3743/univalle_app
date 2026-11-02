import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/data/datasources/restaurant_menu_remote_datasource.dart';
import 'package:univalle_app/features/restaurant/data/models/weekly_menu_model.dart';
import 'package:univalle_app/features/restaurant/data/repositories/restaurant_menu_repository_impl.dart';
import 'package:univalle_app/features/restaurant/domain/entities/weekly_menu.dart';

class MockRestaurantMenuRemoteDataSource extends Mock
    implements RestaurantMenuRemoteDataSource {}

void main() {
  late MockRestaurantMenuRemoteDataSource remote;
  late RestaurantMenuRepositoryImpl repository;

  setUp(() {
    remote = MockRestaurantMenuRemoteDataSource();
    repository = RestaurantMenuRepositoryImpl(remote);
  });

  test('returns the menu mapped to an entity', () async {
    when(() => remote.fetchWeeklyMenu()).thenAnswer(
      (_) async => const WeeklyMenuModel(weekLabel: 'Semana 1', days: []),
    );

    final result = await repository.getWeeklyMenu();

    expect(result, isA<Ok<WeeklyMenu>>());
    expect((result as Ok<WeeklyMenu>).value.weekLabel, 'Semana 1');
  });

  test('maps an AppException to a Failure', () async {
    when(() => remote.fetchWeeklyMenu())
        .thenThrow(const NetworkException(message: 'offline'));

    final result = await repository.getWeeklyMenu();

    expect(result, isA<Err<WeeklyMenu>>());
    expect((result as Err<WeeklyMenu>).failure, isA<Failure>());
  });
}
