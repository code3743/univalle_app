import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/restaurant_account.dart';
import '../../restaurant_strings.dart';
import '../utils/lunch_money_formatter.dart';
import '../viewmodels/buy_lunches_view_model.dart';
import 'confirm_purchase_dialog.dart';
import 'lunch_quantity_field.dart';

class BuyLunchesForm extends ConsumerStatefulWidget {
  const BuyLunchesForm({super.key, required this.account});

  final RestaurantAccount account;

  @override
  ConsumerState<BuyLunchesForm> createState() => _BuyLunchesFormState();
}

class _BuyLunchesFormState extends ConsumerState<BuyLunchesForm> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(
    text: widget.account.minPurchase.toString(),
  );
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.account.minPurchase;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final quantity = int.tryParse(value ?? '');
    if (value == null || value.isEmpty) {
      return RestaurantStrings.quantityRequired;
    }
    if (quantity == null) return RestaurantStrings.quantityInvalid;
    if (quantity < widget.account.minPurchase) {
      return RestaurantStrings.quantityBelowMin(widget.account.minPurchase);
    }
    if (quantity > widget.account.maxPurchase) {
      return RestaurantStrings.quantityAboveMax(widget.account.maxPurchase);
    }
    return null;
  }

  Future<void> _submit(bool isLoading) async {
    if (isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    final total = _quantity * widget.account.lunchPrice;
    final confirmed = await ConfirmPurchaseDialog.show(context, total: total);
    if (!confirmed || !mounted) return;
    await ref
        .read(buyLunchesViewModelProvider.notifier)
        .submit(quantity: _quantity, total: total);
    if (!mounted) return;
    if (ref.read(buyLunchesViewModelProvider).value != null) {
      context.push(AppRoutes.pendingPayment);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(buyLunchesViewModelProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is Failure
              ? error.userMessage
              : AppStrings.genericError;
          context.showSnack(message);
        },
      );
    });

    final isLoading = ref.watch(
      buyLunchesViewModelProvider.select((state) => state.isLoading),
    );
    final total = _quantity * widget.account.lunchPrice;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          LunchQuantityField(
            controller: _controller,
            min: widget.account.minPurchase,
            max: widget.account.maxPurchase,
            validator: _validate,
            onChanged: (value) => setState(
              () =>
                  _quantity = int.tryParse(value) ?? widget.account.minPurchase,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(RestaurantStrings.totalToPayLabel),
              Text(
                LunchMoneyFormatter.format(total),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : () => _submit(isLoading),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(RestaurantStrings.buySubmit),
            ),
          ),
        ],
      ),
    );
  }
}
