import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
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
  late String _sessionId;
  late StudentUseCase studentUseCase;

  void getTeachingRating() async {
    try {
      _sessionId = await studentUseCase.executeSessionEvaluationTeaching();
      state = await studentUseCase.getTeachingToRatings(_sessionId);
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBArError(e.toString());
      _ref.read(appRouterProvider).pop();
    }
  }
}
