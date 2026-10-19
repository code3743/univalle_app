import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/api_constants.dart';
import 'package:univalle_app/core/constants/course_evaluation_constants.dart';
import 'package:univalle_app/core/constants/library_constants.dart';
import 'package:univalle_app/core/constants/news_constants.dart';
import 'package:univalle_app/core/constants/restaurant_constants.dart';
import 'package:univalle_app/core/constants/schedule_constants.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/constants/uplanner_constants.dart';
import 'package:univalle_app/core/network/api_dio_provider.dart';
import 'package:univalle_app/core/network/course_evaluation_dio_provider.dart';
import 'package:univalle_app/core/network/library_dio_provider.dart';
import 'package:univalle_app/core/network/news_dio_provider.dart';
import 'package:univalle_app/core/network/restaurant_dio_provider.dart';
import 'package:univalle_app/core/network/schedule_dio_provider.dart';
import 'package:univalle_app/core/network/sira_dio_provider.dart';
import 'package:univalle_app/core/network/uplanner_dio_provider.dart';

import '../../helpers/container.dart';

void main() {
  test('each Dio provider targets its own base URL', () {
    final container = createContainer();

    final dios = {
      ApiConstants.baseUrl: container.read(apiDioProvider),
      CourseEvaluationConstants.baseUrl: container.read(
        courseEvaluationDioProvider,
      ),
      LibraryConstants.baseUrl: container.read(libraryDioProvider),
      NewsConstants.baseUrl: container.read(newsDioProvider),
      RestaurantConstants.baseUrl: container.read(restaurantDioProvider),
      ScheduleConstants.baseUrl: container.read(scheduleDioProvider),
      SiraConstants.baseUrl: container.read(siraDioProvider),
      UplannerConstants.baseUrl: container.read(uplannerDioProvider),
    };

    dios.forEach((baseUrl, dio) {
      expect(dio.options.baseUrl, baseUrl);
    });
  });

  test('session-based sources get their own cookie jar', () {
    final container = createContainer();

    final jars = {
      container.read(siraCookieJarProvider),
      container.read(libraryCookieJarProvider),
      container.read(restaurantCookieJarProvider),
      container.read(courseEvaluationCookieJarProvider),
    };

    expect(jars, hasLength(4));
  });
}
