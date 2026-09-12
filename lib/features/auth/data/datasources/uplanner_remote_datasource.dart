import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/constants/uplanner_constants.dart';

/// Looks up the student's SIRA photo URL through U-Planner — the
/// third-party system Univalle's own app actually uses for this, since SIRA
/// itself has no page that exposes the photo. It's a 3-step exchange:
/// log in for a short-lived token, validate it to get the numeric user id,
/// then look up that id for the (clean) photo URL — a separate endpoint
/// returns the same photo prefixed with U-Planner's blob storage host, so
/// this deliberately avoids that one.
///
/// The photo is always optional: every failure here (network, unexpected
/// response shape, credentials rejected, etc.) resolves to `null` instead
/// of throwing, so callers never need to treat it as something that can
/// fail login.
class UplannerRemoteDataSource {
  final Dio _dio;
  const UplannerRemoteDataSource(this._dio);

  Future<String?> fetchPhotoUrl({
    required String username,
    required String password,
  }) async {
    try {
      final loginResponse = await _dio.post(
        '',
        data: {
          'name': username,
          'password': base64Encode(utf8.encode(password)),
          'type': 'web',
          'authName': '',
        },
      );
      final exchangeToken = (loginResponse.data as Map?)?['data'] as String?;
      if (exchangeToken == null) return null;

      final validateResponse = await _dio.post(
        UplannerConstants.validatePath,
        options: Options(headers: {'x-access-token': exchangeToken}),
      );
      final validateData = (validateResponse.data as Map?)?['data'] as Map?;
      final userId = (validateData?['user'] as Map?)?['id'];
      final accessToken = validateData?['token'] as String?;
      if (userId == null) return null;

      final detailsResponse = await _dio.get(
        UplannerConstants.userDetailsPath,
        queryParameters: {'id': userId},
        options: accessToken == null
            ? null
            : Options(headers: {'x-access-token': accessToken}),
      );
      final dataPicture = (detailsResponse.data as Map?)?['data'] as Map?;
      final picture = dataPicture?['picture'] as String?;
      return (picture == null || picture.isEmpty) ? null : picture;
    } catch (_) {
      return null;
    }
  }
}
