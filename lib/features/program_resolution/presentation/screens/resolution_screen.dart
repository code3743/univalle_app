import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/widgets/loading.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/program_resolution/presentation/providers/program_resolution_provider.dart';
import 'package:univalle_app/features/program_resolution/presentation/widgets/semester_widget.dart';

class ResolutionScreen extends StatelessWidget {
  const ResolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Resolución'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomScrollView(slivers: [
            const SliverToBoxAdapter(
                child: SizedBox(
              height: 20,
            )),
            Consumer(builder: (context, ref, _) {
              final subjectCycles = ref.watch(programResolutionProvider);
              if (subjectCycles == null) {
                return SliverToBoxAdapter(
                    child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        child: const Loading(text: 'Consultando resolución')));
              }
              return SemesterList(
                subjectCycles: subjectCycles,
              );
            }),
            const SliverToBoxAdapter(
                child: SizedBox(
              height: 20,
            )),
          ]),
        ));
  }
}

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
