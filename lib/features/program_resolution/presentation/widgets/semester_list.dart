import 'package:flutter/material.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/program_resolution/presentation/widgets/semester_widget.dart';

class SemesterList extends StatelessWidget {
  const SemesterList({
    super.key,
    required this.subjectCycles,
  });
  final List<SubjectCycle> subjectCycles;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SemesterWidget(
            subjectCycle: subjectCycles[index],
          ),
        );
      },
      childCount: subjectCycles.length,
    ));
  }
}
