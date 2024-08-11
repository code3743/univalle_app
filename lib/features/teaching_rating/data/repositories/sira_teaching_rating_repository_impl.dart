import 'package:univalle_app/features/teaching_rating/domain/datasources/teaching_rating_datasource.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';

class SiraTeachingRatingRepositoryImpl implements TeachingRatingRepository {
  final TeachingRatingDatasource _datasource;

  SiraTeachingRatingRepositoryImpl(this._datasource);

  @override
  Future<ReviewSubject> getReviewSubject(TeachingRating teacher) {
    return _datasource.getReviewSubject(teacher);
  }

  @override
  Future<List<TeachingRating>> getTeachingToRatings(
      String user, String password) {
    return _datasource.getTeachingToRatings(user, password);
  }

  @override
  Future<void> sendTeachingRating(ReviewSubject review) {
    return _datasource.sendTeachingRating(review);
  }
}
