import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/lunch_payment.dart';
import '../../restaurant_strings.dart';
import '../utils/lunch_money_formatter.dart';
import '../viewmodels/restaurant_view_model.dart';
import 'lunch_ticket_card/ticket_detail_row.dart';

class PendingPaymentCard extends ConsumerWidget {
  const PendingPaymentCard({super.key, required this.payment});

  final LunchPayment payment;

  Future<void> _goToPay(BuildContext context) async {
    final uri = Uri.tryParse(payment.paymentUrl);
    final launched =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showSnack(RestaurantStrings.cannotOpenPaymentLink);
    }
  }

  Future<void> _confirmPayment(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref
          .read(restaurantViewModelProvider.notifier)
          .confirmPayment();
      if (!context.mounted) return;
      context.showSnack(
        result == PaymentConfirmationResult.confirmed
            ? RestaurantStrings.paymentConfirmed
            : RestaurantStrings.paymentStillPending,
      );
    } catch (e) {
      if (!context.mounted) return;
      context.showSnack(e is Failure ? e.userMessage : AppStrings.genericError);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TicketDetailRow(
            icon: Icons.date_range,
            label: RestaurantStrings.purchaseDateLabel,
            value: payment.purchaseDate,
          ),
          TicketDetailRow(
            icon: Icons.restaurant_rounded,
            label: RestaurantStrings.quantityLabel,
            value: '${payment.quantity}',
          ),
          TicketDetailRow(
            icon: Icons.attach_money,
            label: RestaurantStrings.totalToPayLabel,
            value: LunchMoneyFormatter.format(payment.total),
          ),
          TicketDetailRow(
            icon: Icons.event_busy,
            label: RestaurantStrings.expirationDateLabel,
            value: payment.expirationDate,
          ),
          Spacer(),

          Text(payment.message, textAlign: TextAlign.center),

          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => _goToPay(context),
            child: const Text(RestaurantStrings.goToPayLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () => _confirmPayment(context, ref),
            child: const Text(RestaurantStrings.confirmPaymentLabel),
          ),
        ],
      ),
    );
  }
}
