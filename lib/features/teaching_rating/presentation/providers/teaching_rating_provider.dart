import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

final teachingRatingProvider = StateNotifierProvider.autoDispose<
    TeachingRatingNotifier, List<TeachingRating>?>((ref) {
  return TeachingRatingNotifier(ref);
});

class TeachingRatingNotifier extends StateNotifier<List<TeachingRating>?> {
  TeachingRatingNotifier(this._ref) : super(null) {
    studentUseCase = _ref.read(studentUseCasesProvider);
  }

  final Ref _ref;
  late StudentUseCase studentUseCase;

  void getTeachingRating() async {
    try {
      state = await studentUseCase.getTeachingToRatings();
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      _ref.read(appRouterProvider).pop();
    }
  }

  Future<ReviewSubject> getReviewSubject(int index) async {
    try {
      final result = await studentUseCase.getReviewSubject(state![index]);
      return result;
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      _ref.read(appRouterProvider).pop();
      rethrow;
    }
  }

  Future<void> setRating(ReviewSubject review) async {
    try {
      await studentUseCase.sendTeachingRating(review);
      state = null;
      _ref
          .read(snackBarHandlerProvider)
          .showSnackBarSuccess('Calificación enviada correctamente');
      getTeachingRating();
      _ref.read(appRouterProvider).pop();
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      _ref.read(appRouterProvider).pop();
    }
  }
}
