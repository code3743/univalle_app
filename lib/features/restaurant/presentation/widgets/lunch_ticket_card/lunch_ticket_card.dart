import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/restaurant_account.dart';
import '../../../restaurant_strings.dart';
import '../../utils/lunch_money_formatter.dart';
import 'ticket_detail_row.dart';
import 'ticket_perforation.dart';

class LunchTicketCard extends StatelessWidget {
  const LunchTicketCard({super.key, required this.account});

  final RestaurantAccount account;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.univalleRed, AppColors.univalleRedDark],
              ),
            ),
            child: Column(
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: account.accumulatedLunches),
                  duration: const Duration(milliseconds: 600),
                  builder: (_, value, _) => Text(
                    '$value',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  RestaurantStrings.accumulatedLunches,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const TicketPerforation(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              children: [
                TicketDetailRow(
                  icon: Icons.badge_outlined,
                  label: RestaurantStrings.membershipTypeLabel,
                  value: account.membershipType,
                ),
                TicketDetailRow(
                  icon: Icons.restaurant_rounded,
                  label: RestaurantStrings.lunchPriceLabel,
                  value: LunchMoneyFormatter.format(account.lunchPrice),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
