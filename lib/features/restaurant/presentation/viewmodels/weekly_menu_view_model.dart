import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/weekly_menu.dart';
import '../../di/restaurant_providers.dart';

part 'weekly_menu_view_model.g.dart';

@riverpod
class WeeklyMenuViewModel extends _$WeeklyMenuViewModel {
  @override
  Future<WeeklyMenu> build() async {
    final result = await ref.read(getWeeklyMenuUseCaseProvider).call();
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (menu) => menu,
    );
  }
}
