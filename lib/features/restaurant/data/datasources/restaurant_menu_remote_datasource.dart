import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/restaurant_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../restaurant_strings.dart';
import '../models/weekly_menu_model.dart';

class RestaurantMenuRemoteDataSource {
  final Dio _dio;
  const RestaurantMenuRemoteDataSource(this._dio);

  static final _dayRowLabel = RegExp(
    r'^(lunes|martes|mi[eé]rcoles|jueves|viernes|s[aá]bado|domingo)\s+\d+',
    caseSensitive: false,
  );

  Future<WeeklyMenuModel> fetchWeeklyMenu() async {
    final response = await _run(() => _dio.get(RestaurantConstants.menuPath));
    final table = parse(response.data as String)
        .querySelector(RestaurantConstants.menuTableSelector);

    final rows = table?.querySelectorAll('tr') ?? const <Element>[];
    final categories = _categories(rows);
    final days = rows
        .map((row) => _parseDay(row, categories))
        .whereType<DailyMenuModel>()
        .toList();
    if (days.isEmpty) {
      throw const BusinessException(
        message: RestaurantStrings.menuUnavailable,
        retryable: false,
      );
    }

    return WeeklyMenuModel(weekLabel: _weekLabel(table!), days: days);
  }

  /// The column titles (Sopa, Arroz, ...) come from the header row, so a
  /// column the restaurant adds or renames shows up without a code change.
  List<String> _categories(List<Element> rows) {
    for (final row in rows) {
      final headers = row.querySelectorAll('th');
      if (headers.length > 2 &&
          headers.every((th) => th.attributes['colspan'] == null)) {
        return headers.skip(1).map((th) => _text(th)).toList();
      }
    }
    return const [];
  }

  DailyMenuModel? _parseDay(Element row, List<String> categories) {
    final cells = row.querySelectorAll('td');
    if (cells.isEmpty) return null;

    final dayLabel = _text(cells.first);
    if (!_dayRowLabel.hasMatch(dayLabel)) return null;

    if (cells.length == 2 && cells[1].attributes['colspan'] != null) {
      return DailyMenuModel(dayLabel: dayLabel, closedReason: _text(cells[1]));
    }

    final dishes = <MenuDishModel>[];
    for (var i = 1; i < cells.length; i++) {
      final name = _text(cells[i]);
      if (name.isEmpty) continue;
      dishes.add(
        MenuDishModel(
          category: i - 1 < categories.length ? categories[i - 1] : '',
          name: name,
        ),
      );
    }
    return DailyMenuModel(dayLabel: dayLabel, dishes: dishes);
  }

  String _weekLabel(Element table) {
    for (final header in table.querySelectorAll('th[colspan]')) {
      final strong = header.querySelector('strong');
      final firstText = strong?.nodes
          .whereType<Text>()
          .map((node) => _clean(node.text))
          .firstWhere((text) => text.isNotEmpty, orElse: () => '');
      if (firstText != null && RegExp(r'\d').hasMatch(firstText)) {
        return firstText;
      }
    }
    return '';
  }

  String _text(Element element) => _clean(element.text);

  // The portal's editor litters cells with non-breaking spaces.
  String _clean(String value) =>
      value.replaceAll(' ', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
