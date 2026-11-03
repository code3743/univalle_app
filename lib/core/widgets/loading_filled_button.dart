import 'package:flutter/material.dart';

/// A [FilledButton] that swaps its label for a spinner while [isLoading].
///
/// When [loadingLabel] is given the spinner is shown next to it; otherwise the
/// spinner replaces the label entirely.
class LoadingFilledButton extends StatelessWidget {
  const LoadingFilledButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.loadingLabel,
  });

  final String label;
  final String? loadingLabel;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const spinner = SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
    return FilledButton(
      onPressed: onPressed,
      child: !isLoading
          ? Text(label)
          : loadingLabel == null
          ? spinner
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                spinner,
                const SizedBox(width: 12),
                Text(loadingLabel!),
              ],
            ),
    );
  }
}
