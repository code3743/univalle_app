import 'package:flutter/material.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

class DetailSemesterScreen extends StatelessWidget {
  const DetailSemesterScreen({super.key, required this.subjectCycle});
  final SubjectCycle subjectCycle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Semestre ${subjectCycle.semester}'),
        ),
        body: const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomScrollView()));
  }
}
