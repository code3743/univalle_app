import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

abstract class TeachingRatingRepository {
  Future<String> authenticateSession(String user, String password);
  Future<List<TeachingRating>> getTeachingToRatings(String sessionId);
  Future<void> sendTeachingRating(String sessionId, ReviewSubject review);
  Future<List<QuestionsSubject>> getQuestionsSubject(
      String sessionId, TeachingRating teacher);
}
