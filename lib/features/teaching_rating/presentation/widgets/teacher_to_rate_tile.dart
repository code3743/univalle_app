import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/teacher_to_rate.dart';

/// Same white-card layout as `SubjectCard`: icon in a contrast circle,
/// chevron top-right — kept even for the already-rated/novelty rows, whose
/// `onTap` still gives snackbar feedback instead of navigating.
class TeacherToRateTile extends StatelessWidget {
  const TeacherToRateTile({super.key, required this.teacher, this.onTap});

  final TeacherToRate teacher;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const accent = AppColors.accentPink;

    return Material(
      color: AppColors.white,
      shadowColor: accent,
      borderRadius: BorderRadius.circular(20),
      elevation: .1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.pastelPink,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    teacher.isQualified
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 18,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.teacherName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher.subjectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
