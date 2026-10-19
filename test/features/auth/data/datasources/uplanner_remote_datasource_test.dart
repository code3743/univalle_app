import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/uplanner_constants.dart';
import 'package:univalle_app/features/auth/data/datasources/uplanner_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _json(Map<String, dynamic> body) => Response(
  requestOptions: RequestOptions(path: ''),
  statusCode: 200,
  data: body,
);

void main() {
  late MockDio dio;
  late UplannerRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    dataSource = UplannerRemoteDataSource(dio);
  });

  void stubLogin(Map<String, dynamic> body) {
    when(() => dio.post('', data: any(named: 'data')))
        .thenAnswer((_) async => _json(body));
  }

  void stubValidate(Map<String, dynamic> body) {
    when(
      () => dio.post(
        UplannerConstants.validatePath,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _json(body));
  }

  void stubDetails(Map<String, dynamic> body) {
    when(
      () => dio.get(
        UplannerConstants.userDetailsPath,
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _json(body));
  }

  Future<String?> fetch() =>
      dataSource.fetchPhotoUrl(username: 'jperez', password: 'secret');

  test('returns the photo url after the 3-step exchange', () async {
    stubLogin({'data': 'exchange'});
    stubValidate({
      'data': {
        'user': {'id': 42},
        'token': 'access',
      },
    });
    stubDetails({
      'data': {'picture': 'https://photos/jperez.jpg'},
    });

    expect(await fetch(), 'https://photos/jperez.jpg');

    final login =
        verify(() => dio.post('', data: captureAny(named: 'data')))
                .captured
                .single
            as Map;
    expect(login['name'], 'jperez');
    expect(login['password'], 'c2VjcmV0');
    verify(
      () => dio.get(
        UplannerConstants.userDetailsPath,
        queryParameters: {'id': 42},
        options: any(named: 'options'),
      ),
    ).called(1);
  });

  test('looks up the details without headers when no access token', () async {
    stubLogin({'data': 'exchange'});
    stubValidate({
      'data': {
        'user': {'id': 42},
      },
    });
    stubDetails({
      'data': {'picture': 'https://photos/a.jpg'},
    });

    expect(await fetch(), 'https://photos/a.jpg');
  });

  test('returns null when login yields no exchange token', () async {
    stubLogin({'message': 'denied'});

    expect(await fetch(), isNull);
    verifyNever(
      () => dio.post(
        UplannerConstants.validatePath,
        options: any(named: 'options'),
      ),
    );
  });

  test('returns null when validation yields no user id', () async {
    stubLogin({'data': 'exchange'});
    stubValidate({'data': <String, dynamic>{}});

    expect(await fetch(), isNull);
  });

  test('returns null when the picture is empty', () async {
    stubLogin({'data': 'exchange'});
    stubValidate({
      'data': {
        'user': {'id': 42},
        'token': 'access',
      },
    });
    stubDetails({
      'data': {'picture': ''},
    });

    expect(await fetch(), isNull);
  });

  test('returns null instead of throwing on a network error', () async {
    when(() => dio.post('', data: any(named: 'data')))
        .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

    expect(await fetch(), isNull);
  });
}
