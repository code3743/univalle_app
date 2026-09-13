import 'package:flutter/material.dart';

abstract final class AppColors {
  static const univalleRed = Color(0xFFFF0000);
  static const univalleRedDark = Color(0xFFB30000);
  static const pageBackground = Color(0xFFF7F7F9);
  static const inputFill = Color(0xFFF0F1F3);
  static const white = Color(0xFFFFFFFF);

  static const accentBlue = Color(0xFF2563EB);
  static const accentGreen = Color(0xFF16A34A);
  static const accentAmber = Color(0xFFD97706);
  static const accentPurple = Color(0xFF7C3AED);
  static const accentPink = Color(0xFFDB2777);

  // Pastel fill to pair with an `accent*` color for a tinted icon circle on
  // an otherwise white card (see TeacherToRateTile).
  static const pastelPink = Color(0xFFF3DDE5);

  // QR codes need fixed, near-max contrast to stay scannable, so these two
  // don't come from the theme's ColorScheme like everything else.
  static const qrBackground = Color(0xFFFFFFFF);
  static const qrForeground = Color(0xFF000000);
}
