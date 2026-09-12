import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../error/failures.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  String get _message {
    final err = error;
    if (err is Failure) return err.userMessage;
    return AppStrings.genericError;
  }

  /// A [BusinessFailure] marked non-retryable describes a settled outcome
  /// (e.g. "this has no survey configured"), not a technical failure a
  /// retry could fix — shown with an informational look and no button.
  bool get _isInformational {
    final err = error;
    return err is BusinessFailure && !err.retryable;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInformational = _isInformational;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isInformational ? Icons.info_outline : Icons.error_outline,
              size: 40,
              color: isInformational
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null && !isInformational) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
