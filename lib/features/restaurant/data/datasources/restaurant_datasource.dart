import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/parser.dart';
import 'package:univalle_app/config/constants/restaurant_constants.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/features/restaurant/domain/datasources/student_restaurant_datasource.dart';
import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';

class RestaurantDatasource implements StudentRestaurantDatasource {
  final _dio = Dio();
  final _cookieJar = CookieJar();

  RestaurantDatasource() {
    _dio
      ..interceptors.add(CookieManager(_cookieJar))
      ..options.contentType = 'application/x-www-form-urlencoded';
  }

  @override
  Future<PaymentProcess> buyLunches(int numberLunch, double total) async {
    try {
      final response = await _dio.post(
        RestaurantConstants.baseUrl + RestaurantConstants.buyLucnhes,
        data: {
          'comprar_tiquete[cantidad_tiquetes]': numberLunch,
          'comprar_tiquete[total_compra]': total.toInt(),
        },
      );

      if (response.statusCode != 200) {
        throw SiraException('No se pudo realizar la compra');
      }

      final document = parse(response.data);
      final url =
          document.querySelector('a.btn.btn-danger')?.attributes['href'];
      if (url == null) {
        throw SiraException('No se pudo realizar la compra');
      }
      final message = document.querySelector('h1')?.text ?? '';
      return PaymentProcess(
        numberLunch: numberLunch,
        total: total,
        paymentUrl: url,
        startDate: '',
        expirationDate: '',
        message: message,
      );
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  Future<void> _login(String user, String password) async {
    final response = await _dio.get(
      RestaurantConstants.baseUrl,
    );
    final document = parse(response.data);

    final token =
        document.querySelector('#signin__csrf_token')?.attributes['value'];

    if (document.querySelector('#selecciona_perfil') != null) {
      return;
    }
    if (token == null) {
      throw SiraException('No se pudo obtener el token');
    }

    await _dio.post(RestaurantConstants.baseUrl + RestaurantConstants.login,
        data: {
          'signin[username]': user,
          'signin[password]': password,
          'signin[_csrf_token]': token,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ));
    await _dio.get(RestaurantConstants.baseUrl + RestaurantConstants.home);
  }

  @override
  Future<StudentRestaurant> getStudentRestaurant(
      String user, String password) async {
    try {
      await _login(user, password);
      final response = await _dio.get(
        RestaurantConstants.baseUrl + RestaurantConstants.info,
      );
      final document = parse(response.data);
      if (document.querySelector('#selecciona_perfil') == null) {
        throw SiraException('El servicio no está disponible');
      }

      final dataRaw = document
          .querySelector('.panel-body')!
          .querySelectorAll('.form-group.col-sm-6');
      final typeLink = dataRaw[5]
          .querySelector('.form-control')!
          .text
          .trim()
          .replaceAll('\n', '');
      final lunchPrice = dataRaw[6].querySelector('.form-control')!.text;
      final accumulatedLunches =
          dataRaw[7].querySelector('.form-control')!.text;
      final maxLunches = dataRaw[8].querySelector('.form-control')!.text;
      final minLunches = dataRaw[9].querySelector('.form-control')!.text;
      final paymentProcess = _hasPaymentProcess(response.data);

      return StudentRestaurant(
        typeLink: typeLink,
        priceLunch: double.parse(lunchPrice),
        numberLunch: int.parse(accumulatedLunches),
        maxNumberLunch: int.parse(maxLunches),
        minNumberLunch: int.parse(minLunches),
        paymentProcess: paymentProcess,
      );
    } catch (e) {
      await _cookieJar.deleteAll();
      throw handleSiraError(e);
    }
  }

  PaymentProcess? _hasPaymentProcess(String data) {
    final document = parse(data);
    final numberLunch = document
        .querySelector(
            'input[name="comprar_tiquete[pago_en_proceso][cantidad]"]')
        ?.attributes['value'];
    if (numberLunch == null) return null;
    final total = document
        .querySelector('input[name="comprar_tiquete[pago_en_proceso][valor]"]')!
        .attributes['value'];
    final startDate = document
        .querySelector(
            'input[name="comprar_tiquete[pago_en_proceso][fecha_compra]"]')!
        .attributes['value'];
    final expirationDate = document
        .querySelector(
            'input[name="comprar_tiquete[pago_en_proceso][fecha_expira]"]')!
        .attributes['value'];
    final message = document.querySelector('#blink')!.text;
    final paymentUrl =
        document.querySelector('.btn.btn-danger')!.attributes['href'];
    return PaymentProcess(
        numberLunch: int.parse(numberLunch),
        total: double.parse(total!),
        startDate: startDate!,
        expirationDate: expirationDate!,
        message: message,
        paymentUrl: paymentUrl!);
  }
}
