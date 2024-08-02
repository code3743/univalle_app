import 'package:univalle_app/features/teaching_rating/domain/datasources/teaching_rating_datasource.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
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
  Future<List<QuestionsSubject>> getQuestionsSubject(
      String sessionId, TeachingRating teacher) {
    return _datasource.getQuestionsSubject(sessionId, teacher);
  }

  @override
  Future<List<TeachingRating>> getTeachingToRatings(String sessionId) {
    return _datasource.getTeachingToRatings(sessionId);
  }

  @override
  Future<void> sendTeachingRating(String sessionId, ReviewSubject review) {
    return _datasource.sendTeachingRating(sessionId, review);
  }
}
