import 'package:flutter/material.dart';
import 'package:univalle_app/core/common/widgets/app_drawer.dart';
import 'package:univalle_app/core/common/widgets/app_navigation_bar.dart';
import 'package:univalle_app/features/home/presentation/screens/home_screen.dart';
import 'package:univalle_app/features/search_subject/presentation/screens/search_subject_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, this.hasAuth});
  final bool? hasAuth;
  @override
  Widget build(BuildContext context) {
    final initialIndex = hasAuth ?? false ? 0 : 1;
    final currentIndex = ValueNotifier<int>(initialIndex);
    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: AppNavigationBar(
          initialIndex: initialIndex,
          onIndexChange: (index) {
            currentIndex.value = index;
          }),
      body: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (_, value, __) {
            return currentScreen(value);
          }),
    );
  }

  Widget currentScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SubjectSearchScreen();
      case 2:
      default:
        return Container();
    }
  }
}
