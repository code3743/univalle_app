import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/routers/app_router.dart';

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

  void showAlertDialog(String title, Widget content) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('OK'))
          ],
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
          duration: const Duration(milliseconds: 500),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
