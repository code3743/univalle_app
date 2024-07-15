import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryRed,
        onPressed: () {},
        child: const Icon(
          Icons.notifications_rounded,
          color: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  height: 80,
                ),
                const SizedBox(height: 20),
                const _AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomTextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Icons.person_rounded),
              suffixIcon: SizedBox(),
              hintText: 'Usuario',
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: isObscure,
              builder: (_, value, __) {
                return CustomTextFormField(
                  textAlign: TextAlign.center,
                  prefixIcon: const Icon(Icons.lock_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(!value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                    onPressed: () => isObscure.value = !value,
                  ),
                  hintText: 'Contraseña',
                  obscureText: value,
                );
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Iniciar sesión',
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Invitado',
              onPressed: () {},
              backgroundColor: AppColors.white,
              borderColor: AppColors.primaryRed,
              borderWidth: 2,
              textColor: AppColors.primaryRed,
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.primaryRed),
                )),
          ],
        ),
      ),
    );
  }
}
