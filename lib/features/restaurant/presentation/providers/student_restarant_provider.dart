import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';

final studentRestaurantProvider =
    FutureProvider.autoDispose<StudentRestaurant>((ref) async {
  try {
    final studentUseCase = ref.read(studentUseCasesProvider);
    return studentUseCase.getStudentRestaurant();
  } catch (e) {
    rethrow;
  }
});

final paymentProcessProvider = StateNotifierProvider.autoDispose<
    StudentRestaurantNotifier, StudentRestaurantStatus>((ref) {
  return StudentRestaurantNotifier(ref);
});

class StudentRestaurantNotifier extends StateNotifier<StudentRestaurantStatus> {
  StudentRestaurantNotifier(this._ref)
      : super(StudentRestaurantStatus.initial) {
    studentUseCase = _ref.read(studentUseCasesProvider);
  }

  final Ref _ref;
  late final StudentUseCase studentUseCase;

  Future<void> setPaymentProcess(int amount, double total) async {
    try {
      state = StudentRestaurantStatus.loading;
      await studentUseCase.buyLunches(amount, total);
      state = StudentRestaurantStatus.loaded;
    } catch (e) {
      state = StudentRestaurantStatus.error;
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      rethrow;
    }
  }
}

enum StudentRestaurantStatus { initial, loading, loaded, error }
