import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';

final authProvider =
    StateNotifierProvider.autoDispose<AuthProvider, bool>((ref) {
  final studentUse = ref.watch(studentUseCasesProvider);
  return AuthProvider(studentUse);
});

class AuthProvider extends StateNotifier<bool> {
  AuthProvider(this._studentUseCase) : super(false);
  final StudentUseCase _studentUseCase;
  final TextEditingController code = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      state = true;
      await _studentUseCase.login(code.text, pass.text);
    } catch (e) {
      state = false;
      rethrow;
    }
  }
}
