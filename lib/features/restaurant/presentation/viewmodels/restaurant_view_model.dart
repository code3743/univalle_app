import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/restaurant_account.dart';
import '../providers/restaurant_providers.dart';

part 'restaurant_view_model.g.dart';

enum PaymentConfirmationResult { confirmed, stillPending }

@riverpod
class RestaurantViewModel extends _$RestaurantViewModel {
  @override
  Future<RestaurantAccount> build() async {
    final result = await ref.read(getRestaurantAccountUseCaseProvider).call();
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (account) => account,
    );
  }

  /// Re-fetches the account and compares the accumulated-lunches count
  /// against what was showing before, since the payment portal is external
  /// and this is the only way the app has to tell whether a payment landed.
  /// Throws the [Failure] on error rather than touching [state], so a
  /// transient failure here doesn't blow away the account already on
  /// screen.
  Future<PaymentConfirmationResult> confirmPayment() async {
    final previousCount = state.value?.accumulatedLunches ?? 0;
    final result = await ref.read(getRestaurantAccountUseCaseProvider).call();
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (account) {
        state = AsyncData(account);
        return account.accumulatedLunches > previousCount
            ? PaymentConfirmationResult.confirmed
            : PaymentConfirmationResult.stillPending;
      },
    );
  }
}
