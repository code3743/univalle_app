import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/restaurant_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../restaurant_strings.dart';
import '../models/lunch_payment_model.dart';
import '../models/restaurant_account_model.dart';

class RestaurantRemoteDataSource {
  final Dio _dio;
  final CookieJar _cookieJar;
  const RestaurantRemoteDataSource(this._dio, this._cookieJar);

  Future<void> _authenticate({
    required String username,
    required String password,
  }) async {
    await _cookieJar.deleteAll();

    final homeResponse = await _run(() => _dio.get(''));
    final homeDocument = parse(homeResponse.data as String);
    if (homeDocument.querySelector('#selecciona_perfil') != null) return;

    final token = homeDocument
        .querySelector('#signin__csrf_token')
        ?.attributes['value'];
    if (token == null) {
      throw const ServerException(message: RestaurantStrings.noToken);
    }

    await _run(
      () => _dio.post(
        RestaurantConstants.loginPath,
        data: {
          'signin[username]': username,
          'signin[password]': password,
          'signin[_csrf_token]': token,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      ),
    );
    await _run(() => _dio.get(RestaurantConstants.homePath));
  }

  Future<RestaurantAccountModel> fetchAccount({
    required String username,
    required String password,
  }) async {
    try {
      await _authenticate(username: username, password: password);

      final response = await _run(
        () => _dio.get(RestaurantConstants.purchasePath),
      );
      final document = parse(response.data as String);
      if (document.querySelector('#selecciona_perfil') == null) {
        throw const ServerException(
          message: RestaurantStrings.serviceUnavailable,
        );
      }

      final fields = document
          .querySelector('.panel-body')
          ?.querySelectorAll('.form-group.col-sm-6');
      if (fields == null || fields.length < 10) {
        throw const ServerException(
          message: RestaurantStrings.accountUnavailable,
        );
      }

      final lunchPrice = double.tryParse(_fieldText(fields[6]));
      final accumulatedLunches = int.tryParse(_fieldText(fields[7]));
      final maxPurchase = int.tryParse(_fieldText(fields[8]));
      final minPurchase = int.tryParse(_fieldText(fields[9]));
      if (lunchPrice == null ||
          accumulatedLunches == null ||
          maxPurchase == null ||
          minPurchase == null) {
        throw const ServerException(
          message: RestaurantStrings.accountUnavailable,
        );
      }

      return RestaurantAccountModel(
        membershipType: _fieldText(fields[5]),
        lunchPrice: lunchPrice,
        accumulatedLunches: accumulatedLunches,
        minPurchase: minPurchase,
        maxPurchase: maxPurchase,
        pendingPayment: _pendingPayment(document),
      );
    } catch (_) {
      await _cookieJar.deleteAll();
      rethrow;
    }
  }

  String _fieldText(Element group) =>
      group.querySelector('.form-control')?.text.trim() ?? '';

  LunchPaymentModel? _pendingPayment(Document document) {
    final quantityValue = document
        .querySelector(
          'input[name="comprar_tiquete[pago_en_proceso][cantidad]"]',
        )
        ?.attributes['value'];
    if (quantityValue == null) return null;

    final totalValue = document
        .querySelector('input[name="comprar_tiquete[pago_en_proceso][valor]"]')
        ?.attributes['value'];
    final purchaseDate = document
        .querySelector(
          'input[name="comprar_tiquete[pago_en_proceso][fecha_compra]"]',
        )
        ?.attributes['value'];
    final expirationDate = document
        .querySelector(
          'input[name="comprar_tiquete[pago_en_proceso][fecha_expira]"]',
        )
        ?.attributes['value'];
    final paymentUrl = document
        .querySelector('.btn.btn-danger')
        ?.attributes['href'];

    final quantity = int.tryParse(quantityValue);
    final total = totalValue == null ? null : double.tryParse(totalValue);
    if (quantity == null ||
        total == null ||
        purchaseDate == null ||
        expirationDate == null ||
        paymentUrl == null) {
      return null;
    }

    return LunchPaymentModel(
      quantity: quantity,
      total: total,
      purchaseDate: purchaseDate,
      expirationDate: expirationDate,
      message: document.querySelector('#blink')?.text.trim() ?? '',
      paymentUrl: paymentUrl,
    );
  }

  Future<LunchPaymentModel> buyLunches({
    required int quantity,
    required double total,
  }) async {
    final response = await _run(
      () => _dio.post(
        RestaurantConstants.payPath,
        data: {
          'comprar_tiquete[cantidad_tiquetes]': quantity,
          'comprar_tiquete[total_compra]': total.toInt(),
        },
      ),
    );

    final document = parse(response.data as String);
    final paymentUrl = document
        .querySelector('a.btn.btn-danger')
        ?.attributes['href'];
    if (paymentUrl == null) {
      throw const ServerException(message: RestaurantStrings.noPaymentLink);
    }
    final now = DateTime.now();

    return LunchPaymentModel(
      quantity: quantity,
      total: total,
      purchaseDate: now.toString(),
      expirationDate: now.add(const Duration(days: 1)).toString(),
      message: document.querySelector('h1')?.text.trim() ?? '',
      paymentUrl: paymentUrl,
    );
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
