import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../domain/entities/curriculum.dart';
import '../../domain/entities/curriculum_subject.dart';
import '../../resolution_strings.dart';
import '../utils/subject_area_style.dart';
import 'subject_detail_sheet.dart';

/// Same pastel full-fill recipe as `StatCard`/`ShortcutCard`: accent-tinted
/// background, icon in a contrast circle, chevron top-right.
class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.curriculum,
    required this.subject,
  });

  final Curriculum curriculum;
  final CurriculumSubject subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final areaStyle = SubjectAreaStyle.from(subject.subjectType);
    final prerequisiteCount = subject.prerequisiteCodes.length;

    return Material(
      color: Colors.white,
      borderOnForeground: true,
      shadowColor: areaStyle.color,
      borderRadius: BorderRadius.circular(20),
      elevation: .1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showSubjectDetail(context, curriculum, subject),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 18,
                    color: areaStyle.color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.code} · ${ResolutionStrings.creditsValue(subject.credits)}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    if (prerequisiteCount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AssetPaths.iconLink,
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              areaStyle.color,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ResolutionStrings.prerequisitesChip(
                              prerequisiteCount,
                            ),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: areaStyle.color,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
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
