import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/features/home/presentation/widgets/widgets.dart';
import 'package:univalle_app/features/home/presentation/config/button_services_options.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: false,
          pinned: false,
          actions: [
            AppLogo(padding: EdgeInsets.all(8.0), isHero: false),
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
                              content: Text('Servicio en desarrollo')),
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
    );
  }
}
