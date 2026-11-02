import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/loading_filled_button.dart';
import '../../auth_strings.dart';
import '../utils/username_validator.dart';
import '../widgets/auth_header.dart';
import '../viewmodels/auth_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(bool isLoading) async {
    if (isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authViewModelProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _goToForgotPassword() {
    FocusScope.of(context).unfocus();
    context.push(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is Failure
              ? error.userMessage
              : AppStrings.genericError;
          context.showSnack(message);
        },
      );
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return AppScaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: AuthStrings.title,
                subtitle: AuthStrings.subtitle,
              ),
              TextFormField(
                controller: _usernameController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: AuthStrings.usernameLabel,
                  hintText: AuthStrings.usernameHint,
                ),
                textInputAction: TextInputAction.next,
                validator: validateUsername,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                enabled: !isLoading,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: AuthStrings.passwordLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: isLoading
                        ? null
                        : () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(isLoading),
                validator: (value) => (value == null || value.isEmpty)
                    ? AuthStrings.passwordRequired
                    : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading ? null : _goToForgotPassword,
                  child: const Text(AuthStrings.forgotPassword),
                ),
              ),
              const SizedBox(height: 8),
              LoadingFilledButton(
                label: AuthStrings.submit,
                loadingLabel: AuthStrings.loggingIn,
                isLoading: isLoading,
                onPressed: isLoading ? null : () => _submit(isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
