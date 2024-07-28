import 'package:univalle_app/features/teaching_rating/domain/datasources/teaching_rating_datasource.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';

class SiraTeachingRatingRepositoryImpl implements TeachingRatingRepository {
  final TeachingRatingDatasource _datasource;

  SiraTeachingRatingRepositoryImpl(this._datasource);

  @override
  Future<String> authenticateSession(String user, String password) {
    return _datasource.authenticateSession(user, password);
  }

  @override
  Future<List<TeachingRating>> getTeachingQualifications(String sessionId) {
    return _datasource.getTeachingQualifications(sessionId);
  }

  @override
  Future<void> sendTeachingQualification(
      TeachingRating teacher, String sessionId) {
    return _datasource.sendTeachingQualification(teacher, sessionId);
  }
}
