import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/widgets/app_scaffold.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/current_photo_url_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../../core/utils/sira_period_formatter.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../../student_grades/domain/entities/grades.dart';
import '../../../student_grades/presentation/viewmodels/grades_view_model.dart';
import '../../../profile/presentation/viewmodels/profile_view_model.dart';
import '../../home_strings.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/program_card.dart';
import '../widgets/quick_access_items.dart';

/// Number of quick-access shortcuts shown on Home; the rest are only
/// reachable from the "Ver todos" screen.
const _homeQuickAccessCount = 6;

/// Latest (highest year-semester) period among the fetched grades, e.g.
/// "2026-1". Falls back to null while grades are loading, on error, or when
/// there's no academic history yet.
String? _latestSemester(List<Grades>? periods) {
  if (periods == null || periods.isEmpty) return null;
  return periods
      .map((period) => SiraPeriodFormatter.shortCode(period.period))
      .reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final profileState = ref.watch(profileViewModelProvider);
    final gradesState = ref.watch(gradesViewModelProvider);
    final photoUrl = ref.watch(currentPhotoUrlProvider);
    final colorScheme = Theme.of(context).colorScheme;

    void showComingSoon() => context.showSnack(HomeStrings.comingSoon);

    void goToProfile() => context.push(AppRoutes.profile);
    void goToAllShortcuts() => context.push(AppRoutes.allFunctionalities);

    return AppScaffold(
      body: AsyncValueWidget(
        value: profileState,
        onRetry: () => ref.invalidate(profileViewModelProvider),
        data: (student) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeTopBar(
              onNotifications: showComingSoon,
              onAvatarTap: goToProfile,
              initial: NameFormatter.initial(student.firstName),
              photoUrl: photoUrl,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              HomeStrings.greeting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${NameFormatter.firstName(student.firstName)} 👋',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              HomeStrings.tagline,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            ProgramCard(
              student: student,
              currentSemester:
                  _latestSemester(gradesState.value) ??
                  HomeStrings.currentSemesterUnknown,
              onTap: goToProfile,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    iconAsset: AssetPaths.iconGraduationCap,
                    value: student.average.toStringAsFixed(1),
                    label: HomeStrings.averageLabel,
                    accent: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    iconAsset: AssetPaths.iconLayers,
                    value: '${student.accumulatedCredits}',
                    label: HomeStrings.creditsLabel,
                    accent: AppColors.accentBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  HomeStrings.quickAccess,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: goToAllShortcuts,
                  child: Row(
                    children: [
                      Text(HomeStrings.viewAll),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
              children: quickAccessItems(context)
                  .take(_homeQuickAccessCount)
                  .map(
                    (item) => ShortcutCard(
                      iconAsset: item.iconAsset,
                      label: item.label,
                      accent: item.accent,
                      onTap: item.onTap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
