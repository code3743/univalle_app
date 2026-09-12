import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
  final _boundaryKey = GlobalKey();
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  bool _isSaving = false;
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
  // widget to match. Once the widget's height equals the full document, there
  // is nothing left off-screen, which is also what makes a full-page
  // RepaintBoundary capture possible below.
  Future<void> _measureContentHeight() async {
    final result = await _controller.runJavaScriptReturningResult(
      'document.documentElement.scrollHeight',
    );
    final height = double.tryParse(result.toString().replaceAll('"', ''));
    if (mounted && height != null) setState(() => _contentHeight = height);
  }

  Future<void> _saveAsImage() async {
    setState(() => _isSaving = true);
    try {
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      final image = await boundary?.toImage(pixelRatio: 2.5);
      final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('empty tabulado snapshot');

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/tabulado.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: StudentTabulateStrings.shareText,
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text(StudentTabulateStrings.saveError)),
          );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
      actions: [
        IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download_outlined),
          tooltip: StudentTabulateStrings.saveAsImage,
          onPressed: _isSaving ? null : _saveAsImage,
        ),
      ],
      body: AsyncValueWidget(
        value: tabulateState,
        onRetry: () => ref.invalidate(tabulateViewModelProvider),
        data: (tabulate) {
          _loadIfNeeded(tabulate);
          return SizedBox(
            height: _contentHeight ?? MediaQuery.sizeOf(context).height,
            child: RepaintBoundary(
              key: _boundaryKey,
              child: WebViewWidget(controller: _controller),
            ),
          );
        },
      ),
    );
  }
}
