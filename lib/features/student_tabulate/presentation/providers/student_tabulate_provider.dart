import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';

final studentTabulateProvider = FutureProvider<WebViewController>((ref) async {
  final studentUseCase = ref.watch(studentUseCasesProvider);

  try {
    final controller = WebViewController();
    await controller.enableZoom(true);
    final tabulate = await studentUseCase.getTabulate();
    await controller.loadHtmlString(tabulate.content);
    return controller;
  } catch (e) {
    ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
    rethrow;
  }
});
