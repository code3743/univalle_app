import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/presentation/viewmodels/review_answers_view_model.dart';

import '../../../../helpers/container.dart';

void main() {
  test('build starts with no answers', () {
    final container = createContainer();

    expect(container.read(reviewAnswersViewModelProvider), isEmpty);
  });

  test(
    'answer records the rating for a question without disturbing others',
    () {
      final container = createContainer();
      final notifier = container.read(reviewAnswersViewModelProvider.notifier);

      notifier.answer('q1', RatingOption.agree);
      notifier.answer('q2', RatingOption.totallyAgree);

      expect(container.read(reviewAnswersViewModelProvider), {
        'q1': RatingOption.agree,
        'q2': RatingOption.totallyAgree,
      });
    },
  );

  test('answer overwrites a previous rating for the same question', () {
    final container = createContainer();
    final notifier = container.read(reviewAnswersViewModelProvider.notifier);

    notifier.answer('q1', RatingOption.disagree);
    notifier.answer('q1', RatingOption.totallyAgree);

    expect(container.read(reviewAnswersViewModelProvider), {
      'q1': RatingOption.totallyAgree,
    });
  });
}
