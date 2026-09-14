import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../teaching_rating_strings.dart';
import '../viewmodels/teacher_review_view_model.dart';
import '../widgets/teacher_review_wizard.dart';

class TeacherReviewView extends ConsumerWidget {
  const TeacherReviewView({super.key, required this.teacher});

  final TeacherToRate teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

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
