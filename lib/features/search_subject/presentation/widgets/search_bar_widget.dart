import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/selected_campus_provider.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/search_subject/presentation/delegates/search_subject_delegate.dart';
import 'package:univalle_app/features/search_subject/presentation/providers/subject_search_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchText = ValueNotifier<String?>(null);

    return Center(
      child: FractionallySizedBox(
        widthFactor: .85,
        child: Consumer(builder: (context, ref, _) {
          return GestureDetector(
            onTap: () async {
              final campus =
                  ref.read(selectedCampusProvider.notifier).getCampusId();
              final resul = await showSearch(
                  context: context, delegate: SearchSubjectDelegate(campus));
              searchText.value = resul?.query;
              ref
                  .read(subjectSearchProvider.notifier)
                  .searchSubjects(resul, campus);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: searchText,
                          builder: (_, value, __) {
                            return Text(
                              value ?? 'Buscar Asignatura...',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              textScaler: TextScaler.noScaling,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
