import 'package:flutter/material.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/features/search_subject/presentation/widgets/subject_search_bar.dart';

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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            }, childCount: 20),
          )
        ],
      ),
    );
  }
}
