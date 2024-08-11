import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

abstract class TeachingRatingDatasource {
  Future<List<TeachingRating>> getTeachingToRatings(
      String user, String password);
  Future<ReviewSubject> getReviewSubject(TeachingRating teacher);
  Future<void> sendTeachingRating(ReviewSubject review);
}
