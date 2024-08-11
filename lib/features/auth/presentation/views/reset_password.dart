import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/custom_button.dart';
import 'package:univalle_app/core/common/widgets/custom_text_form_field.dart';
import 'package:univalle_app/core/utils/validate.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_provider.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        width: size.width,
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: .8,
            child: Consumer(builder: (context, ref, _) {
              final authNotifier = ref.watch(authProvider.notifier);
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
                      'Recuperar contraseña',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue),
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
                        backgroundColor: AppColors.primaryBlue,
                        onPressed: auth
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                try {
                                  await authNotifier.resetPassword();
                                  ref.read(appRouterProvider).pop();
                                  ref
                                      .read(snackBarHandlerProvider)
                                      .showSnackBarInfo(
                                          'Se ha enviado un correo a tu cuenta institucional');
                                } catch (e) {
                                  ref
                                      .read(snackBarHandlerProvider)
                                      .showSnackBarError(e.toString());
                                }
                              }),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
