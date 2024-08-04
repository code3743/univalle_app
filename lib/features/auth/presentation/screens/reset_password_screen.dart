import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/core/utils/validate.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer contraseña'),
      ),
      backgroundColor: AppColors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: 80),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: .8,
              child: Consumer(builder: (context, ref, _) {
                final authNotifier = ref.read(authProvider.notifier);
                final auth = ref.watch(authProvider);
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Ingresa tu usuario del SIRA para restablecer tu contraseña',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: authNotifier.code,
                        enabled: !auth,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.person_rounded),
                        suffixIcon: const SizedBox(),
                        hintText: 'Usuario',
                        validator: Validate.validateStudentCode,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: 'Recuperar',
                          onPressed: auth
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  try {
                                    await authNotifier.resetPassword();
                                    ref
                                        .read(snackBarHandlerProvider)
                                        .showSnackBarSuccess(
                                            'Se ha enviado un correo a tu cuenta institucional');
                                    ref.read(appRouterProvider).pop();
                                  } catch (e) {
                                    ref
                                        .read(snackBarHandlerProvider)
                                        .showSnackBArError(e.toString());
                                  }
                                }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
