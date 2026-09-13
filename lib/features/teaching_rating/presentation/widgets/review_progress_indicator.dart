import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/review_question.dart';
import '../../teaching_rating_strings.dart';

class ReviewProgressIndicator extends StatelessWidget {
  const ReviewProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.category,
  });

  final int current;
  final int total;
  final QuestionCategory category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TeachingRatingStrings.questionCounter(current, total),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          category.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
