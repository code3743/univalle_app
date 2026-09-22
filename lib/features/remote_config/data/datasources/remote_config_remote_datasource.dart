import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../models/app_config_model.dart';
import '../models/announcement_model.dart';

class RemoteConfigRemoteDataSource {
  final Dio _dio;
  const RemoteConfigRemoteDataSource(this._dio);

  // The backend splits app-launch data across separate endpoints
  // (`/app/config` only carries maintenance/update); fetch them together
  // and merge into the single `AppConfigModel` the rest of the app expects.
  Future<AppConfigModel> fetchConfig({
    required String platform,
    required String version,
  }) async {
    final responses = await _run(
      () => Future.wait([
        _dio.get(
          ApiConstants.configPath,
          queryParameters: {'platform': platform, 'version': version},
        ),
        _dio.get(
          ApiConstants.modulesPath,
          queryParameters: {'platform': platform},
        ),
        _dio.get(ApiConstants.welcomePath),
      ]),
    );
    return AppConfigModel.fromParts(
      config: responses[0].data as Map<String, dynamic>,
      modules: responses[1].data as Map<String, dynamic>,
      welcome: responses[2].data as Map<String, dynamic>,
    );
  }

  Future<AnnouncementsPageModel> fetchAnnouncements({required int page}) async {
    final response = await _run(
      () => _dio.get(
        ApiConstants.announcementsPath,
        queryParameters: {'page': page},
      ),
    );
    return AnnouncementsPageModel.fromJson(
      response.data as Map<String, dynamic>,
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
