import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/custom_button.dart';
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
                      if (snapshot.hasError) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Aun no tienes un tabulado registrado',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                              SizedBox(
                                height: 300,
                                child: Image.asset('assets/img/uv_ardilla.png'),
                              ),
                              const SizedBox(height: 10),
                              FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: CustomButton(
                                    text: 'Volver a consultar',
                                    onPressed: () {
                                      ref.invalidate(studentTabulateProvider);
                                    },
                                  ))
                            ]);
                      }
                      return const Loading(text: 'Cargando tabulado...');
                    }))));
  }
}
