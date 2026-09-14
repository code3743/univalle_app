import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/tabulate.dart';
import '../../student_tabulate_strings.dart';
import '../viewmodels/tabulate_view_model.dart';

class TabulateView extends ConsumerStatefulWidget {
  const TabulateView({super.key});

  @override
  ConsumerState<TabulateView> createState() => _TabulateViewState();
}

class _TabulateViewState extends ConsumerState<TabulateView> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  double? _contentHeight;
  String? _loadedHtml;

  void _loadIfNeeded(Tabulate tabulate) {
    if (_loadedHtml == tabulate.html) return;
    _loadedHtml = tabulate.html;
    _contentHeight = null;
    _controller
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (_) => _measureContentHeight()),
      )
      ..loadHtmlString(tabulate.html, baseUrl: tabulate.baseUrl.toString());
  }

  // The document has no intrinsic height in Flutter's layout (it's a native
  // WebView), so we ask the page itself how tall it rendered and resize the
  // widget to match, letting the surrounding scroll view reach the full
  // document instead of clipping it to one screen.
  Future<void> _measureContentHeight() async {
    final result = await _controller.runJavaScriptReturningResult(
      'document.documentElement.scrollHeight',
    );
    final height = double.tryParse(result.toString().replaceAll('"', ''));
    if (mounted && height != null) setState(() => _contentHeight = height);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final tabulateState = ref.watch(tabulateViewModelProvider);
    ref.listen<AsyncValue<Tabulate>>(tabulateViewModelProvider, (
      previous,
      next,
    ) {
      next.whenData(_loadIfNeeded);
    });

    return AppScaffold(
      title: StudentTabulateStrings.title,
      padding: EdgeInsets.zero,
      body: AsyncValueWidget(
        value: tabulateState,
        onRetry: () => ref.invalidate(tabulateViewModelProvider),
        data: (tabulate) {
          _loadIfNeeded(tabulate);
          return SizedBox(
            height: _contentHeight ?? MediaQuery.sizeOf(context).height,
            child: WebViewWidget(controller: _controller),
          );
        },
      ),
    );
  }
}
