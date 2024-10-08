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

  void showAlertDialog(
      {required String title,
      required Widget content,
      TextStyle? textStyle,
      bool barrierDismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
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
      {Color? backgroundColor, TextStyle? textStyle, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        animation: AnimationController(
          vsync: ScaffoldMessenger.of(context),
          duration: duration ?? const Duration(seconds: 3),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showSnackBarError(String message) {
    showSnackBar(message, backgroundColor: AppColors.error);
  }

  void showSnackBarSuccess(String message) {
    showSnackBar(message, backgroundColor: AppColors.success);
  }

  void showSnackBarInfo(String message) {
    showSnackBar(message,
        backgroundColor: AppColors.info, duration: const Duration(seconds: 5));
  }

  void showSnackBarWarning(String message) {
    showSnackBar(message, backgroundColor: AppColors.warning);
  }
}
