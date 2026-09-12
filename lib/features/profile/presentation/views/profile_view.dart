import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/widgets/app_scaffold.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/current_photo_url_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/student.dart';
import '../../profile_strings.dart';
import '../viewmodels/profile_view_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

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
    final photoUrl = ref.watch(currentPhotoUrlProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: ProfileStrings.title,
      body: SafeArea(
        child: AsyncValueWidget(
          value: profileState,
          onRetry: () => ref.invalidate(profileViewModelProvider),
          data: (student) => Column(
            children: [
              _Avatar(student: student, photoUrl: photoUrl),
              const SizedBox(height: AppSpacing.lg),
              _InfoTile(
                iconAsset: AssetPaths.iconUser,
                label: ProfileStrings.fullNameLabel,
                value: '${student.firstName} ${student.lastName}',
              ),
              _InfoTile(
                iconAsset: AssetPaths.iconMail,
                label: ProfileStrings.emailLabel,
                value: student.email,
              ),
              _InfoTile(
                iconAsset: AssetPaths.iconIdCard,
                label: ProfileStrings.documentLabel,
                value: student.documentId,
              ),
              _InfoTile(
                iconAsset: AssetPaths.iconGraduationCap,
                label: ProfileStrings.programLabel,
                value: student.programName,
              ),
              _InfoTile(
                iconAsset: AssetPaths.iconMapPin,
                label: ProfileStrings.campusLabel,
                value: student.campus,
              ),
              const Divider(height: AppSpacing.lg * 2),
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
                title: Text(
                  ProfileStrings.logout,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => ref.read(authViewModelProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.student, this.photoUrl});

  final Student student;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial = student.firstName.isNotEmpty ? student.firstName[0] : '?';
    return Center(
      child: UserAvatar(
        radius: 56,
        initials: initial,
        photoUrl: photoUrl,
        backgroundColor: AppColors.univalleRed,
        textStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.iconAsset,
    required this.label,
    required this.value,
  });

  final String iconAsset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: SvgPicture.asset(
        iconAsset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          colorScheme.onSurfaceVariant,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
