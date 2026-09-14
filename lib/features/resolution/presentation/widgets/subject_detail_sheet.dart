import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/curriculum.dart';
import '../../domain/entities/curriculum_subject.dart';
import '../../resolution_strings.dart';
import '../utils/subject_area_style.dart';
import 'relation_section.dart';
import 'subject_type_badge.dart';

/// Opens [subject]'s detail. Tapping a related subject inside the sheet
/// closes it and reopens this same sheet for that subject, letting the user
/// walk the prerequisite chain one hop at a time instead of rendering the
/// whole dependency graph at once.
void showSubjectDetail(
  BuildContext context,
  Curriculum curriculum,
  CurriculumSubject subject,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => SubjectDetailSheet(
      curriculum: curriculum,
      subject: subject,
      onSelectRelated: (related) {
        Navigator.of(sheetContext).pop();
        showSubjectDetail(context, curriculum, related);
      },
    ),
  );
}

class SubjectDetailSheet extends StatelessWidget {
  const SubjectDetailSheet({
    super.key,
    required this.curriculum,
    required this.subject,
    required this.onSelectRelated,
  });

  final Curriculum curriculum;
  final CurriculumSubject subject;
  final ValueChanged<CurriculumSubject> onSelectRelated;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final areaStyle = SubjectAreaStyle.from(subject.subjectType);
    final prerequisites = curriculum.prerequisitesOf(subject);
    final unlocks = curriculum.unlockedBy(subject);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                subject.name,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${subject.code} · ${ResolutionStrings.creditsValue(subject.credits)} · '
                '${ResolutionStrings.semesterTitle(subject.semester)}',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              SubjectTypeBadge(areaStyle: areaStyle),
              const SizedBox(height: AppSpacing.lg),
              RelationSection(
                title: ResolutionStrings.prerequisitesSectionTitle,
                subjects: prerequisites,
                emptyMessage: ResolutionStrings.noPrerequisites,
                emptyIcon: Icons.check_circle_outline,
                directionIcon: Icons.arrow_upward,
                onTap: onSelectRelated,
              ),
              const SizedBox(height: AppSpacing.lg),
              RelationSection(
                title: ResolutionStrings.unlocksSectionTitle,
                subjects: unlocks,
                emptyMessage: ResolutionStrings.noUnlocks,
                emptyIcon: Icons.flag_outlined,
                directionIcon: Icons.arrow_downward,
                onTap: onSelectRelated,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
