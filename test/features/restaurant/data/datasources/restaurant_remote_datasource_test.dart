import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/restaurant_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

class MockDio extends Mock implements Dio {}

Response<String> _response(String html) => Response(
  requestOptions: RequestOptions(path: ''),
  statusCode: 200,
  data: html,
);

const _loginHtml =
    '<html><body><input id="signin__csrf_token" value="tok"></body></html>';

String _field(String value) =>
    '<div class="form-group col-sm-6"><div class="form-control">$value</div></div>';

String _accountHtml({
  List<String>? values,
  String pending = '',
  bool withProfile = true,
}) {
  final fields =
      (values ?? ['', '', '', '', '', 'Estudiante', '9500', '3', '20', '1'])
          .map(_field)
          .join();
  return '<html><body>'
      '${withProfile ? '<div id="selecciona_perfil"></div>' : ''}'
      '<div class="panel-body">$fields</div>$pending</body></html>';
}

const _pendingHtml = '''
<input name="comprar_tiquete[pago_en_proceso][cantidad]" value="2">
<input name="comprar_tiquete[pago_en_proceso][valor]" value="19000">
<input name="comprar_tiquete[pago_en_proceso][fecha_compra]" value="2026-01-01">
<input name="comprar_tiquete[pago_en_proceso][fecha_expira]" value="2026-01-02">
<span id="blink">Pago pendiente</span>
<a class="btn btn-danger" href="https://pay.example/1">Pagar</a>
''';

void main() {
  late MockDio dio;
  late CookieJar cookieJar;
  late RestaurantRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    cookieJar = CookieJar();
    dataSource = RestaurantRemoteDataSource(dio, cookieJar);
  });

  void stubGets({required String home, required String purchase}) {
    when(() => dio.get(any())).thenAnswer((invocation) async {
      final path = invocation.positionalArguments[0] as String;
      return _response(
        path == RestaurantConstants.purchasePath ? purchase : home,
      );
    });
    when(
      () => dio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _response(''));
  }

  group('fetchAccount', () {
    test(
      'logs in when no profile is selected and parses the account',
      () async {
        stubGets(
          home: _loginHtml,
          purchase: _accountHtml(pending: _pendingHtml),
        );

        final account = await dataSource.fetchAccount(
          username: 'u',
          password: 'p',
        );

        expect(account.membershipType, 'Estudiante');
        expect(account.lunchPrice, 9500);
        expect(account.accumulatedLunches, 3);
        expect(account.maxPurchase, 20);
        expect(account.minPurchase, 1);
        expect(account.pendingPayment?.quantity, 2);
        expect(account.pendingPayment?.total, 19000);
        expect(account.pendingPayment?.paymentUrl, 'https://pay.example/1');
        expect(account.pendingPayment?.message, 'Pago pendiente');
        verify(
          () => dio.post(
            RestaurantConstants.loginPath,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );

    test('skips the login when a profile is already selected', () async {
      stubGets(home: _accountHtml(), purchase: _accountHtml());

      final account = await dataSource.fetchAccount(
        username: 'u',
        password: 'p',
      );

      expect(account.pendingPayment, isNull);
      verifyNever(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      );
    });

    test('has no pending payment when its fields are incomplete', () async {
      stubGets(
        home: _loginHtml,
        purchase: _accountHtml(
          pending: '<input name="comprar_tiquete[pago_en_proceso][cantidad]" value="2">',
        ),
      );

      final account = await dataSource.fetchAccount(
        username: 'u',
        password: 'p',
      );

      expect(account.pendingPayment, isNull);
    });

    test('throws when the login page has no CSRF token', () async {
      stubGets(home: '<html></html>', purchase: '');

      expect(
        () => dataSource.fetchAccount(username: 'u', password: 'p'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            RestaurantStrings.noToken,
          ),
        ),
      );
    });

    test('throws when the purchase page has no profile selector', () async {
      stubGets(home: _loginHtml, purchase: _accountHtml(withProfile: false));

      expect(
        () => dataSource.fetchAccount(username: 'u', password: 'p'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            RestaurantStrings.serviceUnavailable,
          ),
        ),
      );
    });

    test('throws when the account fields are missing', () async {
      stubGets(
        home: _loginHtml,
        purchase: _accountHtml(values: ['a', 'b']),
      );

      expect(
        () => dataSource.fetchAccount(username: 'u', password: 'p'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            RestaurantStrings.accountUnavailable,
          ),
        ),
      );
    });

    test('throws when a numeric field cannot be parsed', () async {
      stubGets(
        home: _loginHtml,
        purchase: _accountHtml(
          values: ['', '', '', '', '', 'Estudiante', 'x', '3', '20', '1'],
        ),
      );

      expect(
        () => dataSource.fetchAccount(username: 'u', password: 'p'),
        throwsA(isA<ServerException>()),
      );
    });

    test('maps a Dio failure to an AppException', () async {
      when(() => dio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchAccount(username: 'u', password: 'p'),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('buyLunches', () {
    test('returns the payment built from the checkout page', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _response(
          '<h1> Compra lista </h1><a class="btn btn-danger" href="https://pay.example/2">Pagar</a>',
        ),
      );

      final payment = await dataSource.buyLunches(quantity: 2, total: 19000);

      expect(payment.quantity, 2);
      expect(payment.total, 19000);
      expect(payment.paymentUrl, 'https://pay.example/2');
      expect(payment.message, 'Compra lista');
    });

    test('throws when the checkout page has no payment link', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _response('<html></html>'));

      expect(
        () => dataSource.buyLunches(quantity: 1, total: 9500),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            RestaurantStrings.noPaymentLink,
          ),
        ),
      );
    });
  });
}
