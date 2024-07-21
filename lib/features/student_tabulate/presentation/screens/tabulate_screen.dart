import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/student_tabulate_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabulateScreen extends StatelessWidget {
  const TabulateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();
    controller.enableZoom(true);

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
                    builder: (_, AsyncSnapshot<Tabulate> snapshot) {
                      if (snapshot.hasData) {
                        controller.loadHtmlString(snapshot.data!.content);
                        return WebViewWidget(
                          controller: controller,
                        );
                      }

                      if (snapshot.hasError) {
                        ref
                            .read(snackBarHandlerProvider)
                            .showSnackBar(snapshot.error.toString());
                        Future.microtask(() => context.pop());
                      }
                      return const Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryRed)),
                          SizedBox(height: 10),
                          Text(
                            'Consultando tabulado...',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed),
                          )
                        ],
                      ));
                    }))));
  }
}
