import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/teacher_review.dart';
import '../../teaching_rating_strings.dart';
import '../viewmodels/submit_teacher_review_view_model.dart';
import '../viewmodels/teachers_to_rate_view_model.dart';
import 'review_feedback_page.dart';
import 'review_progress_indicator.dart';
import 'review_question_page.dart';

class TeacherReviewWizard extends ConsumerStatefulWidget {
  const TeacherReviewWizard({super.key, required this.review});

  final TeacherReview review;

  @override
  ConsumerState<TeacherReviewWizard> createState() =>
      _TeacherReviewWizardState();
}

class _TeacherReviewWizardState extends ConsumerState<TeacherReviewWizard> {
  final _pageController = PageController();
  final _feedbackController = TextEditingController();
  final _answers = <String, RatingOption>{};
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _advanceAfterAnswering() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _goToPreviousQuestion() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submit() {
    ref
        .read(submitTeacherReviewViewModelProvider.notifier)
        .submit(
          review: widget.review,
          answers: _answers,
          feedback: _feedbackController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool?>>(submitTeacherReviewViewModelProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (submitted) {
          if (submitted == true) {
            ref.invalidate(teachersToRateViewModelProvider);
            context.showSnack(TeachingRatingStrings.submitSuccess);
            context.pop();
          }
        },
        error: (error, _) {
          final message = error is Failure
              ? error.userMessage
              : AppStrings.genericError;
          context.showSnack(message);
        },
      );
    });

    final isSubmitting = ref
        .watch(submitTeacherReviewViewModelProvider)
        .isLoading;
    final questions = widget.review.questions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.review.teacherName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          widget.review.subjectName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_currentPage < questions.length)
          ReviewProgressIndicator(
            current: _currentPage + 1,
            total: questions.length,
            category: questions[_currentPage].category,
          ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: questions.length + 1,
            itemBuilder: (context, index) {
              if (index == questions.length) {
                return ReviewFeedbackPage(
                  controller: _feedbackController,
                  isSubmitting: isSubmitting,
                  onSubmit: _submit,
                );
              }
              final question = questions[index];
              return ReviewQuestionPage(
                question: question,
                selected: _answers[question.id],
                onSelected: (rating) {
                  setState(() => _answers[question.id] = rating);
                  _advanceAfterAnswering();
                },
                onPrevious: index == 0 ? null : _goToPreviousQuestion,
              );
            },
          ),
        ),
      ],
    );
  }
}
