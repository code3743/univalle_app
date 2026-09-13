import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/rating_option.dart';

part 'review_answers_view_model.g.dart';

/// The in-progress answers for the review wizard currently on screen, keyed
/// by [ReviewQuestion.id].
@riverpod
class ReviewAnswersViewModel extends _$ReviewAnswersViewModel {
  @override
  Map<String, RatingOption> build() => {};

  void answer(String questionId, RatingOption rating) {
    state = {...state, questionId: rating};
  }
}
