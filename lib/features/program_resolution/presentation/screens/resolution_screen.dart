import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/loading.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/program_resolution/presentation/providers/program_resolution_provider.dart';
import 'package:univalle_app/features/program_resolution/presentation/widgets/about_item_resolution.dart';
import 'package:univalle_app/features/program_resolution/presentation/widgets/semester_list.dart';

class ResolutionScreen extends ConsumerWidget {
  const ResolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectCycles = ref.watch(programResolutionProvider);
    final studentCredits =
        ref.watch(studentUseCasesProvider).getStudent().accumulatedCredits;
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
            SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      clipBehavior: Clip.antiAlias,
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2))
                          ]),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppColors.primaryRed,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Créditos',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AboutItemResolution(
                                      title: 'Resolución',
                                      value: subjectCycles
                                              ?.map((e) => e.totalCredits)
                                              .reduce((value, element) =>
                                                  value + element)
                                              .toInt() ??
                                          0,
                                    ),
                                    AboutItemResolution(
                                        title: 'Acumulados',
                                        value: subjectCycles != null
                                            ? studentCredits
                                            : 0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Los créditos de la resolución no incluyen las asignaturas electivas. Los créditos acumulados del estudiante se calculan sumando todas las asignaturas aprobadas.',
                              style: TextStyle(
                                  fontSize: 12,
                                  height: 1,
                                  color: AppColors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ))),
            subjectCycles == null
                ? const SliverToBoxAdapter(
                    child: Loading(text: 'Consultando resolución'))
                : SemesterList(
                    subjectCycles: subjectCycles,
                  ),
            const SliverToBoxAdapter(
                child: SizedBox(
              height: 20,
            )),
          ]),
        ));
  }
}
