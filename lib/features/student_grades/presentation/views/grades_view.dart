import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../student_grades_strings.dart';
import '../viewmodels/grades_view_model.dart';
import '../widgets/grades_summary.dart';
import '../widgets/period_grades_section.dart';

class GradesView extends ConsumerWidget {
  const GradesView({super.key});

  static const _periodAccents = [
    AppColors.univalleRed,
    AppColors.accentPurple,
    AppColors.accentGreen,
    AppColors.accentBlue,
    AppColors.accentAmber,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final gradesState = ref.watch(gradesViewModelProvider);

    return AppScaffold(
      title: StudentGradesStrings.title,
      body: AsyncValueWidget(
        value: gradesState,
        onRetry: () => ref.invalidate(gradesViewModelProvider),
        data: (periods) {
          if (periods.isEmpty) {
            return Center(
              child: Text(
                StudentGradesStrings.empty,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradesSummary(periods: periods),
              const SizedBox(height: AppSpacing.lg),
              for (final (index, period) in periods.indexed) ...[
                PeriodGradesSection(
                  grades: period,
                  accent: _periodAccents[index % _periodAccents.length],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          );
        },
      ),
    );
  }
}
