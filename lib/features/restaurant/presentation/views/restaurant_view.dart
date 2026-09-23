import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../restaurant_strings.dart';
import '../viewmodels/restaurant_view_model.dart';
import '../widgets/buy_lunches_form.dart';
import '../widgets/lunch_ticket_card/lunch_ticket_card.dart';
import '../widgets/restaurant_skeleton.dart';

class RestaurantView extends ConsumerWidget {
  const RestaurantView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(restaurantViewModelProvider);

    return AppScaffold(
      title: RestaurantStrings.title,
      body: AsyncValueWidget(
        value: accountState,
        onRetry: () => ref.invalidate(restaurantViewModelProvider),
        skeleton: const RestaurantSkeleton(),
        data: (account) => Column(
          children: [
            Text(
              RestaurantStrings.cafeteriaOnlyNotice,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            LunchTicketCard(account: account),
            const SizedBox(height: AppSpacing.lg),
            account.pendingPayment == null
                ? BuyLunchesForm(account: account)
                : _ConfirmPaymentCta(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              RestaurantStrings.noPaymentDisclaimer,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmPaymentCta extends StatelessWidget {
  const _ConfirmPaymentCta();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ShortcutCard(
        iconAsset: AssetPaths.iconUtensils,
        label: RestaurantStrings.pendingPaymentTitle,
        accent: AppColors.accentPink,
        onTap: () => context.push(AppRoutes.pendingPayment),
      ),
    );
  }
}
