import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../restaurant_strings.dart';
import '../utils/lunch_money_formatter.dart';

class ConfirmPurchaseDialog extends StatelessWidget {
  const ConfirmPurchaseDialog({super.key, required this.total});

  final double total;

  static Future<bool> show(
    BuildContext context, {
    required double total,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmPurchaseDialog(total: total),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: const Text(RestaurantStrings.confirmPurchaseTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(RestaurantStrings.confirmPurchaseBody),
          const SizedBox(height: AppSpacing.md),
          Text.rich(
            TextSpan(
              text: '${RestaurantStrings.totalToPayLabel}: ',
              children: [
                TextSpan(
                  text: LunchMoneyFormatter.format(total),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(RestaurantStrings.cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(RestaurantStrings.confirmLabel),
        ),
      ],
    );
  }
}
