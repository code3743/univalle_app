import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    .._fitWideContentToScreen();

  String? _loadedHtml;

  void _loadIfNeeded(Tabulate tabulate) {
    if (_loadedHtml == tabulate.html) return;
    _loadedHtml = tabulate.html;
    _controller.loadHtmlString(tabulate.html);
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
      scrollable: false,
      body: AsyncValueWidget(
        value: tabulateState,
        onRetry: () => ref.invalidate(tabulateViewModelProvider),

        data: (tabulate) {
          _loadIfNeeded(tabulate);
          return SizedBox(child: WebViewWidget(controller: _controller));
        },
      ),
    );
  }
}

extension on WebViewController {
  // The tabulado is a fixed-width (765px) print layout, wider than any
  // phone screen. iOS's WKWebView already auto-scales content like that to
  // fit, like Safari does — but Android's WebView defaults to
  // useWideViewPort=false, which makes it render at 1:1 scale and show only
  // a cropped slice instead of the whole page shrunk to fit.
  void _fitWideContentToScreen() {
    final platform = this.platform;
    if (platform is AndroidWebViewController) {
      platform.setUseWideViewPort(true);
    }
  }
}
