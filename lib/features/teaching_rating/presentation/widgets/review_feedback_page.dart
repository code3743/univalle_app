import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../teaching_rating_strings.dart';

class ReviewFeedbackPage extends StatelessWidget {
  const ReviewFeedbackPage({
    super.key,
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TeachingRatingStrings.feedbackTitle,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          TeachingRatingStrings.feedbackSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: controller,
          maxLines: 6,
          enabled: !isSubmitting,
          decoration: const InputDecoration(
            hintText: TeachingRatingStrings.feedbackHint,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: isSubmitting ? null : onSubmit,
          child: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(TeachingRatingStrings.submitLabel),
        ),
      ],
    );
  }
}
