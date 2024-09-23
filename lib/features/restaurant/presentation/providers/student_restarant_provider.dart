import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';

final studentRestaurantProvider =
    StateNotifierProvider.autoDispose<StudentRestaurantNotifier, dynamic>(
        (ref) {
  final studentUseCase = ref.read(studentUseCasesProvider);

  return StudentRestaurantNotifier(ref, studentUseCase);
});

class StudentRestaurantNotifier extends StateNotifier {
  StudentRestaurantNotifier(this._ref, this.studentUseCase) : super(null);

  final Ref _ref;
  final StudentUseCase studentUseCase;

  Future<StudentRestaurant> getStudentRestaurant() async {
    try {
      return await studentUseCase.getStudentRestaurant();
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      rethrow;
    }
  }

  Future<PaymentProcess> setPaymentProcess(int amount, double total) async {
    try {
      return await studentUseCase.buyLunches(amount, total);
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      rethrow;
    }
  }
}
