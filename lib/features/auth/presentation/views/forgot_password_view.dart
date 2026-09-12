import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../auth_strings.dart';
import '../viewmodels/reset_password_view_model.dart';
import '../widgets/reset_password_success_dialog.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _goBackToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _submit(bool isLoading) {
    if (isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ref
        .read(resetPasswordViewModelProvider.notifier)
        .resetPassword(username: _usernameController.text.trim());
  }

  Future<void> _showSuccessDialog(String email) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResetPasswordSuccessDialog(email: email),
    );
    if (mounted) _goBackToLogin();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String?>>(resetPasswordViewModelProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (email) {
          if (email != null) _showSuccessDialog(email);
        },
        error: (error, _) {
          final message = error is Failure
              ? error.userMessage
              : AppStrings.genericError;
          context.showSnack(message);
        },
      );
    });

    final state = ref.watch(resetPasswordViewModelProvider);
    final isLoading = state.isLoading;

    return AppScaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: AppLogo(size: 72)),
              const SizedBox(height: 24),
              Text(
                AuthStrings.resetPasswordTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AuthStrings.resetPasswordSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: AuthStrings.usernameLabel,
                  hintText: AuthStrings.usernameHint,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(isLoading),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? AuthStrings.usernameRequired
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isLoading ? null : () => _submit(isLoading),
                child: isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text(AuthStrings.resetPasswordSubmit),
                        ],
                      )
                    : const Text(AuthStrings.resetPasswordSubmit),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: isLoading ? null : _goBackToLogin,
                child: const Text(AuthStrings.backToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
