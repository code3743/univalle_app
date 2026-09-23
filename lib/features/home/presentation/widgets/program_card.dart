import 'package:flutter/material.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../profile/domain/entities/student.dart';
import '../../home_strings.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.student,
    required this.currentSemester,
    required this.onTap,
  });

  final Student student;
  final String currentSemester;
  final VoidCallback onTap;

  static const _imageWidth = 150.0;
  static const _cardHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,

          constraints: const BoxConstraints(minHeight: _cardHeight),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.univalleRed, AppColors.univalleRedDark],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                bottom: -10,
                right: 0,
                width: _imageWidth,
                child: Opacity(
                  opacity: .7,
                  child: Image.asset(
                    AssetPaths.univalleMascot,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  _imageWidth * 0.6,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.programName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(
                        student.campus,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${HomeStrings.currentSemesterLabel} $currentSemester',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
