import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/review_question.dart';
import '../../teaching_rating_strings.dart';
import 'rating_options_list.dart';

class ReviewQuestionPage extends StatelessWidget {
  const ReviewQuestionPage({
    super.key,
    required this.question,
    required this.selected,
    required this.onSelected,
    required this.onPrevious,
  });

  final ReviewQuestion question;
  final RatingOption? selected;
  final ValueChanged<RatingOption> onSelected;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            question.question,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: RatingOptionsList(selected: selected, onChanged: onSelected),
          ),
        ),
        if (onPrevious != null)
          TextButton(
            onPressed: onPrevious,
            child: const Text(TeachingRatingStrings.previousLabel),
          ),
      ],
    );
  }
}
