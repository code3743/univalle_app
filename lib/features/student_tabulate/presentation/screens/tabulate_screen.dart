import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabulateScreen extends StatelessWidget {
  const TabulateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();
    controller.loadHtmlString('<html><body><h1>Hola Mundo</h1></body></html>');
    controller.enableZoom(true);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tabulado'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: WebViewWidget(
            controller: controller,
          ),
        ));
  }
}
