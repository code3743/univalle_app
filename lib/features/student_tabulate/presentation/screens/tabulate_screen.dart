import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/widgets/loading.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/student_tabulate_provider.dart';

class TabulateScreen extends StatelessWidget {
  const TabulateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tabulado'),
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Consumer(
                builder: (_, ref, __) => FutureBuilder(
                    future: ref.watch(studentTabulateProvider.future),
                    builder: (_, AsyncSnapshot<WebViewController> snapshot) {
                      if (snapshot.hasData) {
                        return WebViewWidget(
                          controller: snapshot.data!,
                        );
                      }
                      return const Loading(text: 'Cargando tabulado...');
                    }))));
  }
}
