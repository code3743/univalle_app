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
import '../viewmodels/reset_password_cooldown_view_model.dart';
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
  void initState() {
    super.initState();
    _usernameController.addListener(() => setState(() {}));
  }

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

  void _submit(bool isBlocked) {
    if (isBlocked) return;
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
    final cooldown = ref.watch(
      resetPasswordCooldownViewModelProvider(_usernameController.text.trim()),
    );
    final isBlocked = isLoading || cooldown > 0;

    return AppScaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: AuthStrings.resetPasswordTitle,
                subtitle: AuthStrings.resetPasswordSubtitle,
              ),
              TextFormField(
                controller: _usernameController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: AuthStrings.usernameLabel,
                  hintText: AuthStrings.usernameHint,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(isBlocked),
                validator: validateUsername,
              ),
              const SizedBox(height: 24),
              LoadingFilledButton(
                label: cooldown > 0
                    ? AuthStrings.resetPasswordRetryIn(cooldown)
                    : AuthStrings.resetPasswordSubmit,
                loadingLabel: AuthStrings.resetPasswordSubmit,
                isLoading: isLoading,
                onPressed: isBlocked ? null : () => _submit(isBlocked),
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
