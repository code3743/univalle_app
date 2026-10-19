import 'package:flutter/material.dart';

extension SnackBarContextX on BuildContext {
  void showSnack(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration ?? const Duration(seconds: 4),
        ),
      );
  }
}
