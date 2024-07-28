import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

class DetailSemesterScreen extends StatelessWidget {
  const DetailSemesterScreen({super.key, required this.subjectCycle});
  final SubjectCycle subjectCycle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del semestre'),
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                    child: SizedBox(
                  height: 20,
                )),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: AppColors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Column(
                                children: [
                                  const Text('Créditos'),
                                  Text(subjectCycle.subjects[index].credits,
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                              textColor: AppColors.grey,
                              title: Text(subjectCycle.subjects[index].name),
                              subtitle: Text(subjectCycle.subjects[index].code),
                            ),
                            Container(
                              width: double.infinity,
                              color: AppColors.primaryBlue,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  if (i == 0) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Prerrequisitos',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: AppColors.green,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .75,
                                          child: Text(
                                            subjectCycle.subjects[index]
                                                .prerequisites[i - 1],
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12,
                                            ),
                                            maxLines: 5,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: subjectCycle.subjects[index]
                                        .prerequisites.isNotEmpty
                                    ? subjectCycle.subjects[index].prerequisites
                                            .length +
                                        1
                                    : 0,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: subjectCycle.subjects.length,
                )),
                const SliverToBoxAdapter(
                    child: SizedBox(
                  height: 20,
                )),
              ],
            )));
  }
}
