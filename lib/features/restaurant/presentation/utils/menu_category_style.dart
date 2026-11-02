import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const _accents = [
  AppColors.accentAmber,
  AppColors.accentGreen,
  AppColors.univalleRed,
  AppColors.accentPurple,
  AppColors.accentBlue,
  AppColors.accentPink,
];

Color menuAccentFor(int index) => _accents[index % _accents.length];

/// Matches by keyword because the portal owns the category names; anything
/// it adds later falls back to a generic plate.
IconData menuCategoryIcon(String category) {
  final name = category.toLowerCase();
  if (name.contains('sopa')) return Icons.soup_kitchen_outlined;
  if (name.contains('arroz')) return Icons.rice_bowl_outlined;
  if (name.contains('carne')) return Icons.set_meal_outlined;
  if (name.contains('ensalada')) return Icons.eco_outlined;
  if (name.contains('jugo')) return Icons.local_drink_outlined;
  return Icons.restaurant_outlined;
}
