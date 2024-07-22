import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';

final studentTabulateProvider = FutureProvider<WebViewController>((ref) async {
  final studentUseCase = ref.watch(studentUseCasesProvider);
  final controller = WebViewController();
  await controller.enableZoom(true);
  final tabulate = await studentUseCase.getTabulate();
  await controller.loadHtmlString(tabulate.content);
  return controller;
});
