import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/tabulate.dart';
import '../../student_tabulate_strings.dart';
import '../services/tabulate_image_saver.dart';
import '../viewmodels/tabulate_view_model.dart';
import '../widgets/tabulate_navigation_policy.dart';

class TabulateView extends ConsumerStatefulWidget {
  const TabulateView({super.key});

  @override
  ConsumerState<TabulateView> createState() => _TabulateViewState();
}

class _TabulateViewState extends ConsumerState<TabulateView> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(onNavigationRequest: tabulateNavigationDecision),
    )
    .._fitWideContentToScreen();

  final _imageSaver = const TabulateImageSaver();
  String? _loadedHtml;

  Future<void> _saveAsImage() async {
    final platform = _controller.platform;
    if (platform is! AndroidWebViewController) return;
    try {
      await _imageSaver.save(webViewIdentifier: platform.webViewIdentifier);
      if (mounted) context.showSnack(StudentTabulateStrings.saved);
    } on Object {
      if (mounted) context.showSnack(StudentTabulateStrings.saveFailed);
    }
  }

  void _loadIfNeeded(Tabulate tabulate) {
    if (_loadedHtml == tabulate.html) return;
    _loadedHtml = tabulate.html;
    _controller.loadHtmlString(tabulate.html);
  }

  @override
  Widget build(BuildContext context) {
    final tabulateState = ref.watch(tabulateViewModelProvider);
    ref.listen<AsyncValue<Tabulate>>(tabulateViewModelProvider, (
      previous,
      next,
    ) {
      next.whenData(_loadIfNeeded);
    });

    return AppScaffold(
      title: StudentTabulateStrings.title,
      actions: [
        if (tabulateState.hasValue)
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: StudentTabulateStrings.saveTooltip,
            onPressed: _saveAsImage,
          ),
      ],
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
