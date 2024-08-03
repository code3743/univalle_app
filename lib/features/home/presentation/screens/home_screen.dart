import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/utils/svg_paths.dart';
import 'package:univalle_app/features/home/presentation/config/button_services_options.dart';
import 'package:univalle_app/features/home/presentation/view/home_drawer.dart';
import 'package:univalle_app/core/common/widgets/custom_navigation_bar.dart';
import 'package:univalle_app/features/home/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      bottomNavigationBar: const CustomNavigationBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            backgroundColor: AppColors.primaryRed,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(SvgPaths.logo, height: 35),
              ),
            ],
          ),
          const SliverToBoxAdapter(child: StudentProfileInfo()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: (MediaQuery.sizeOf(context).width - 320) / 2,
                vertical: 10),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = servicesOptions[index];
                    return ItemService(
                      title: service.title,
                      onTap: () {
                        if (service.isUnderDevelopment) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Servicio en desarrollo'),
                            ),
                          );
                          return;
                        }
                        context.push(service.route);
                      },
                      icon: service.icon,
                      primaryColor: service.primaryColor,
                    );
                  },
                  childCount: servicesOptions.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                    crossAxisCount: 2)),
          ),
        ],
      ),
    );
  }
}
