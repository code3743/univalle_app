import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/program_resolution/presentation/providers/program_resolution_provider.dart';
import 'package:univalle_app/features/program_resolution/presentation/widgets/semester_list.dart';

class ResolutionScreen extends StatelessWidget {
  const ResolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Resolución')),
        body: CustomScrollView(slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          Consumer(builder: (context, ref, _) {
            return FutureBuilder(
                future: ref.watch(programResolutionProvider.future),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // TODO: Implement error widget
                    return SliverFillRemaining(
                        child: Center(child: Text(snapshot.error.toString())));
                  }
                  if (!snapshot.hasData) {
                    //TODO: Implement loading widget
                    return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return SemesterList(subjectCycles: snapshot.data!);
                });
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ]));
  }
}
