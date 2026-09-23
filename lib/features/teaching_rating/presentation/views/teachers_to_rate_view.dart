import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../teaching_rating_strings.dart';
import '../viewmodels/teachers_to_rate_view_model.dart';
import '../widgets/teacher_rating_banner.dart';
import '../widgets/teacher_to_rate_tile.dart';

class TeachersToRateView extends ConsumerWidget {
  const TeachersToRateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersState = ref.watch(teachersToRateViewModelProvider);

    void openReview(TeacherToRate teacher) {
      if (teacher.isQualified) {
        context.showSnack(TeachingRatingStrings.alreadyQualified);
        return;
      }
      if (teacher.novelty != null) {
        context.showSnack(teacher.novelty!);
        return;
      }
      context.push(AppRoutes.teacherReview, extra: teacher);
    }

    return AppScaffold(
      title: TeachingRatingStrings.title,
      body: AsyncValueWidget(
        value: teachersState,
        onRetry: () => ref.invalidate(teachersToRateViewModelProvider),
        data: (teachers) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TeacherRatingBanner(),
              const SizedBox(height: AppSpacing.lg),
              if (teachers.isEmpty)
                Center(
                  child: Text(
                    TeachingRatingStrings.empty,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                for (final (index, teacher) in teachers.indexed) ...[
                  TeacherToRateTile(
                    teacher: teacher,
                    onTap: () => openReview(teacher),
                  ),
                  if (index != teachers.length - 1)
                    const SizedBox(height: AppSpacing.sm),
                ],
            ],
          );
        },
      ),
    );
  }
}
