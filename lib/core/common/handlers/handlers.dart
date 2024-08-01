import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

final dialogHandlerProvider = Provider.autoDispose<DialogHandler>((ref) {
  final context =
      ref.watch(appRouterProvider).configuration.navigatorKey.currentContext!;
  return DialogHandler(context);
});

final snackBarHandlerProvider = Provider.autoDispose<SnackBarHandler>((ref) {
  final context =
      ref.watch(appRouterProvider).configuration.navigatorKey.currentContext!;
  return SnackBarHandler(context);
});

class DialogHandler {
  final BuildContext context;

  DialogHandler(this.context);

  void showAlertDialog(String title, Widget content, {TextStyle? textStyle}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              textAlign: TextAlign.center,
              style: textStyle ??
                  const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          clipBehavior: Clip.antiAlias,
          content: content,
        );
      },
    );
  }
}

class SnackBarHandler {
  final BuildContext context;

  SnackBarHandler(this.context);

  void showSnackBar(String message,
      [Color? backgroundColor, TextStyle? textStyle]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        animation: AnimationController(
          vsync: ScaffoldMessenger.of(context),
          duration: const Duration(seconds: 3),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
