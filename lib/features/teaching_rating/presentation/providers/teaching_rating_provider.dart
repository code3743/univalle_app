import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

final teachingRatingProvider =
    StateNotifierProvider<TeachingRatingNotifier, List<TeachingRating>?>((ref) {
  return TeachingRatingNotifier(ref);
});

class TeachingRatingNotifier extends StateNotifier<List<TeachingRating>?> {
  TeachingRatingNotifier(this._ref) : super(null) {
    studentUseCase = _ref.read(studentUseCasesProvider);
  }

  final Ref _ref;
  late String _sesssionId;
  late StudentUseCase studentUseCase;

  void getTeachingRating() async {
    try {
      _sesssionId = await studentUseCase.executeSessionEvaluationTeaching();
      state = await studentUseCase.getTeachingRating(_sesssionId);
    } catch (e) {
      _ref
          .read(snackBarHandlerProvider)
          .showSnackBar(e.toString(), AppColors.error);
      _ref.read(appRouterProvider).pop();
    }
  }
}
