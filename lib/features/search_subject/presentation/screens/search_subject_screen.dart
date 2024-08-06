import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';

class SearchSubjectScreen extends StatelessWidget {
  const SearchSubjectScreen({super.key});
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
          SliverToBoxAdapter(
              child: Container(
            height: 120,
            width: double.infinity,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: .85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Buscar Asignatura por nombre por codigo por todo ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textScaler: TextScaler.noScaling,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      iconColor: Colors.white,
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(
                        'Buscar por sugerencias',
                        style: TextStyle(height: 1),
                      ),
                      subtitle: Text(
                        'Sede',
                        style: TextStyle(height: 1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
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
