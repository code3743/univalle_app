import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/lunch_payment.dart';
import '../providers/restaurant_providers.dart';
import 'restaurant_view_model.dart';

part 'buy_lunches_view_model.g.dart';

@riverpod
class BuyLunchesViewModel extends _$BuyLunchesViewModel {
  @override
  Future<LunchPayment?> build() async => null;

  Future<void> submit({required int quantity, required double total}) async {
    state = const AsyncLoading();
    final result = await ref
        .read(buyLunchesUseCaseProvider)
        .call(quantity: quantity, total: total);
    state = result.fold(
      onError: (failure) => AsyncError(failure, StackTrace.current),
      onSuccess: (payment) {
        ref.invalidate(restaurantViewModelProvider);
        return AsyncData(payment);
      },
    );
  }
}
