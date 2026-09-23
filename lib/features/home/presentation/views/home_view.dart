import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/widgets/app_scaffold.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/current_photo_url_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../profile/presentation/viewmodels/profile_view_model.dart';
import '../../../remote_config/presentation/viewmodels/remote_config_view_model.dart';
import '../../../remote_config/presentation/widgets/home_overlays.dart';
import '../../home_strings.dart';
import '../providers/latest_semester_provider.dart';
import '../widgets/home_footer.dart';
import '../widgets/home_greeting.dart';
import '../widgets/home_quick_access.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/program_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final latestSemester = ref.watch(latestSemesterProvider);
    final photoUrl = ref.watch(currentPhotoUrlProvider);
    final configState = ref.watch(remoteConfigViewModelProvider);

    void goToProfile() => context.push(AppRoutes.profile);
    void goToAllShortcuts() => context.push(AppRoutes.allFunctionalities);
    void goToAnnouncements() => context.push(AppRoutes.announcements);

    return AppScaffold(
      body: AsyncValueWidget(
        value: profileState,
        onRetry: () => ref.invalidate(profileViewModelProvider),
        data: (student) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeOverlays(config: configState.value),
            HomeTopBar(
              onNotifications: goToAnnouncements,
              onAvatarTap: goToProfile,
              initial: NameFormatter.initial(student.firstName),
              photoUrl: photoUrl,
            ),
            const SizedBox(height: AppSpacing.lg),
            HomeGreeting(firstName: NameFormatter.firstName(student.firstName)),
            const SizedBox(height: AppSpacing.lg),
            ProgramCard(
              student: student,
              currentSemester:
                  latestSemester ?? HomeStrings.currentSemesterUnknown,
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
            HomeQuickAccess(
              config: configState,
              onViewAll: goToAllShortcuts,
              onRetry: () => ref.invalidate(remoteConfigViewModelProvider),
            ),
            const SizedBox(height: AppSpacing.lg),
            const HomeFooter(),
          ],
        ),
      ),
    );
  }
}
