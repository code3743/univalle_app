import 'package:flutter/material.dart';

import '../utils/subject_area_style.dart';

class SubjectTypeBadge extends StatelessWidget {
  const SubjectTypeBadge({super.key, required this.areaStyle});

  final SubjectAreaStyle areaStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: areaStyle.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: areaStyle.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            areaStyle.label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: areaStyle.color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
