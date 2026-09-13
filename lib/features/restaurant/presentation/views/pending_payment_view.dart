import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/restaurant_account.dart';
import '../../restaurant_strings.dart';
import '../viewmodels/restaurant_view_model.dart';
import '../widgets/pending_payment_card.dart';

class PendingPaymentView extends ConsumerWidget {
  const PendingPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<RestaurantAccount>>(restaurantViewModelProvider, (
      previous,
      next,
    ) {
      next.whenData((account) {
        if (account.pendingPayment == null && context.mounted) {
          context.pop();
        }
      });
    });

    final accountState = ref.watch(restaurantViewModelProvider);

    return AppScaffold(
      title: RestaurantStrings.pendingPaymentTitle,
      scrollable: false,
      body: AsyncValueWidget(
        value: accountState,
        onRetry: () => ref.invalidate(restaurantViewModelProvider),
        data: (account) => account.pendingPayment == null
            ? const SizedBox.shrink()
            : PendingPaymentCard(payment: account.pendingPayment!),
      ),
    );
  }
}
