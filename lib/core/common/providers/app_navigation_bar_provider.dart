import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/routers/app_router_name.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';

final appNavigationBarProvider =
    StateNotifierProvider<AppNavigationBarNotifier, int>((ref) {
  return AppNavigationBarNotifier(ref.watch(studentUseCasesProvider), ref);
});

class AppNavigationBarNotifier extends StateNotifier<int> {
  final StudentUseCase _useCase;
  final Ref _ref;
  AppNavigationBarNotifier(this._useCase, this._ref) : super(0) {
    init();
  }

  void init() async {
    final isLogged = await _useCase.isLogged();
    if (!isLogged) {
      state = 1;
    }
  }

  void changeIndex(int index) async {
    final isLogged = await _useCase.isLogged();
    switch (index) {
      case 0:
        if (!isLogged) return;
        _ref.read(appRouterProvider).go(AppRouterName.home);
        state = index;
        break;
      case 1:
        _ref.read(appRouterProvider).go(AppRouterName.subjectSearch);
        state = index;
        break;
      case 2:
        break;
    }
  }
}
