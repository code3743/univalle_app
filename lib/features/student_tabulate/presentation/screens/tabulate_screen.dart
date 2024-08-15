import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/student_tabulate_provider.dart';

class TabulateScreen extends StatelessWidget {
  const TabulateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tabulado'),
        ),
        body: Consumer(
            builder: (_, ref, __) => FutureBuilder(
                future: ref.watch(studentTabulateProvider.future),
                builder: (_, AsyncSnapshot<WebViewController> snapshot) {
                  if (snapshot.hasError) {
                    //TODO: Show error message
                  }

                  if (!snapshot.hasData) {
                    //TODO: Show loading
                    return const SizedBox();
                  }
                  return WebViewWidget(
                    controller: snapshot.data!,
                  );
                })));
  }
}
