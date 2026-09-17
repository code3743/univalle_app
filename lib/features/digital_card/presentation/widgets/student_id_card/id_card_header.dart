import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_logo.dart';
import '../../../../../core/widgets/user_avatar.dart';
import '../../../../profile/domain/entities/student.dart';
import '../../../digital_card_strings.dart';
import 'header_shine.dart';

class IdCardHeader extends StatelessWidget {
  const IdCardHeader({
    super.key,
    required this.student,
    required this.initials,
    required this.fullName,
    this.photoUrl,
  });

  final Student student;
  final String initials;
  final String fullName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.univalleRed, AppColors.univalleRedDark],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: HeaderShine()),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg + 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppLogo(size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        DigitalCardStrings.studentBadge,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: UserAvatar(
                    radius: 52,
                    initials: initials,
                    photoUrl: photoUrl,
                    backgroundColor: colorScheme.surface,
                    textStyle: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    student.programName,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
