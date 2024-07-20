import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';
import 'package:univalle_app/core/utils/validate.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_provider.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: Consumer(builder: (context, ref, _) {
        return FloatingActionButton(
          backgroundColor: AppColors.primaryRed,
          onPressed: () {
            ref.read(dialogHandlerProvider).showAlertDialog(
                '¿Cómo ingresar?',
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                      'Utiliza tu código de estudiante y contraseña para acceder a todas las funcionalidades que tenemos para ti.',
                      textAlign: TextAlign.center),
                  const Text(
                      'Si prefieres, puedes ingresar como invitado y explorar nuestra aplicación.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 200,
                      child: Image.asset('assets/img/uv_ardilla.png'))
                ]));
          },
          child: const Icon(
            Icons.notifications_rounded,
            color: AppColors.white,
          ),
        );
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'uv_logo',
                  child: SvgPicture.asset(
                    'assets/svg/logo.svg',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 20),
                _AuthForm(
                  _formKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm(this.formKey);
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Form(
        key: formKey,
        child: Consumer(builder: (context, ref, _) {
          final auth = ref.watch(authProvider);
          final authNotifier = ref.watch(authProvider.notifier);
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: isObscure,
                    builder: (_, value, __) {
                      return CustomTextFormField(
                        enabled: !auth,
                        controller: authNotifier.pass,
                        textAlign: TextAlign.center,
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(!value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                          onPressed: () => isObscure.value = !value,
                        ),
                        hintText: 'Contraseña',
                        validator: Validate.validatePassword,
                        obscureText: value,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Iniciar sesión',
                    onPressed: !auth
                        ? () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            try {
                              await authNotifier.login();
                            } catch (e) {
                              ref.read(snackBarHandlerProvider).showSnackBar(
                                    e.toString(),
                                  );
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Invitado',
                    onPressed: !auth ? () {} : null,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.primaryRed,
                    borderWidth: 2,
                    textColor: AppColors.primaryRed,
                  ),
                  TextButton(
                      onPressed: !auth ? () {} : null,
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryRed,
                            color: AppColors.primaryRed),
                      )),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
