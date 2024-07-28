import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

abstract class TeachingRatingDatasource {
  Future<String> authenticateSession(String user, String password);
  Future<List<TeachingRating>> getTeachingQualifications(String sessionId);
  Future<void> sendTeachingQualification(
      TeachingRating teacher, String sessionId);
}
