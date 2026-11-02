import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/restaurant_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/restaurant/data/datasources/restaurant_menu_remote_datasource.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

class MockDio extends Mock implements Dio {}

Response<String> _response(String html) => Response(
  requestOptions: RequestOptions(path: ''),
  statusCode: 200,
  data: html,
);

void main() {
  late MockDio dio;
  late RestaurantMenuRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = RestaurantMenuRemoteDataSource(dio);
  });

  void stubPage(String html) {
    when(() => dio.get(RestaurantConstants.menuPath))
        .thenAnswer((_) async => _response(html));
  }

  test('parses the week label, closed days and dishes by column', () async {
    stubPage(
      File('test/fixtures/restaurant/weekly_menu.html').readAsStringSync(),
    );

    final menu = await dataSource.fetchWeeklyMenu();

    expect(menu.weekLabel, 'Lunes 02 al viernes 06 de noviembre de 2026');
    expect(menu.days.map((d) => d.dayLabel), [
      'Lunes 02',
      'Martes 03',
      'Miércoles 04',
      'Jueves 05',
      'Viernes 06',
    ]);
    expect(menu.days.first.closedReason, 'FESTIVO');
    expect(menu.days.first.dishes, isEmpty);

    final tuesday = menu.days[1];
    expect(tuesday.closedReason, isNull);
    expect(tuesday.dishes.map((d) => '${d.category}: ${d.name}'), [
      'Sopa: De lentejas',
      'Arroz: Blanco',
      'Carne: Bistec',
      'Principio: Papa a la francesa',
      'Ensalada: Pepino y tomate',
      'Jugo: Mora',
    ]);
    expect(menu.days.last.dishes[2].name, 'Cerdo en Salsa BBQ');
  });

  test('throws a non-retryable BusinessException without a menu table', () {
    stubPage('<html><body><p>Próximamente</p></body></html>');

    expect(
      dataSource.fetchWeeklyMenu(),
      throwsA(
        isA<BusinessException>()
            .having(
              (e) => e.message,
              'message',
              RestaurantStrings.menuUnavailable,
            )
            .having((e) => e.retryable, 'retryable', false),
      ),
    );
  });

  test('maps Dio errors to app exceptions', () {
    when(() => dio.get(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    expect(dataSource.fetchWeeklyMenu(), throwsA(isA<NetworkException>()));
  });
}
