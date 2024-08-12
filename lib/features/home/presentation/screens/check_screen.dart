import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/selected_campus_provider.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/routers/app_router_name.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';

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
              Future.microtask(() {
                if (snapshot.data!) {
                  final campus =
                      ref.read(studentUseCasesProvider).getStudent().campus;
                  ref
                      .read(selectedCampusProvider.notifier)
                      .changeCampusById(campus);
                  ref
                      .read(appRouterProvider)
                      .go(AppRouterName.main, extra: true);
                  return;
                }
                ref
                    .read(selectedCampusProvider.notifier)
                    .changeCampusById('00');
                ref.read(appRouterProvider).go(AppRouterName.login);
              });
            }
            if (snapshot.hasError) {
              Future.microtask(() {
                ref
                    .read(selectedCampusProvider.notifier)
                    .changeCampusById('00');
                ref
                    .read(snackBarHandlerProvider)
                    .showSnackBarError(snapshot.error.toString());
                ref.read(appRouterProvider).go(AppRouterName.login);
              });
            }
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(
                  size: 80,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator.adaptive(
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
