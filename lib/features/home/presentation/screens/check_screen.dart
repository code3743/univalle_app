import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/core/utils/svg_paths.dart';

class CheckScreen extends ConsumerWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
          future: ref.watch(studentUseCasesProvider).isLogged(),
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              Future.microtask(
                  () => context.go(snapshot.data! ? '/home' : '/login'));
            }
            if (snapshot.hasError) {
              Future.microtask(() => context.go('/login'));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'uv_logo',
                  child: SizedBox(
                    height: 80,
                    child: SvgPicture.asset(SvgPaths.logo),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.primaryRed,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                ),
              ],
            );
          }),
    )));
  }
}
