import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/features/search_subject/presentation/providers/subject_search_provider.dart';
import 'package:univalle_app/features/search_subject/presentation/widgets/widgets.dart';

class SubjectSearchScreen extends StatelessWidget {
  const SubjectSearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppNavigationBar(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: false,
            pinned: false,
            centerTitle: true,
            actions: [
              AppLogo(padding: EdgeInsets.all(8.0), isHero: false),
            ],
            title: Text('Buscar Asignatura'),
          ),
          const SliverToBoxAdapter(child: SubjectSearchBar()),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          Consumer(builder: (context, ref, __) {
            final subjectSearch = ref.watch(subjectSearchProvider);

            if (subjectSearch == SubjectSearchStatus.loading) {
              //TODO: Add shimmer effect
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (subjectSearch == SubjectSearchStatus.error) {
              //TODO: Add error message
              return const SliverFillRemaining(
                child: Center(
                  child: Text('Error'),
                ),
              );
            }
            if (subjectSearch == SubjectSearchStatus.initial) {
              //TODO: Add initial message
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Busca una asignatura',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            }
            final result = ref.read(subjectSearchProvider.notifier).result;
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0) {
                  return SubjectInfoCard(
                    subjectName: result.name,
                    subjectCode: result.code,
                    subjectCredits: result.credits,
                  );
                }
                final subjectResult = result.results[index - 1];
                return SubjectResultItem(subjectResult: subjectResult);
              }, childCount: result.results.length + 1),
            );
          })
        ],
      ),
    );
  }
}
