import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../teaching_rating_strings.dart';
import '../viewmodels/teacher_review_view_model.dart';
import '../widgets/teacher_review_wizard.dart';

class TeacherReviewView extends ConsumerWidget {
  const TeacherReviewView({super.key, required this.teacher});

  final TeacherToRate teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(teacherReviewViewModelProvider(teacher));

    return AppScaffold(
      title: TeachingRatingStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: reviewState,
        onRetry: () => ref.invalidate(teacherReviewViewModelProvider(teacher)),
        data: (review) => TeacherReviewWizard(review: review),
      ),
    );
  }
}
