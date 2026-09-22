import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/app_config.dart';
import '../../remote_config_strings.dart';

class UpdateAvailableSheet extends StatelessWidget {
  const UpdateAvailableSheet({super.key, required this.update});

  final UpdateStatus update;

  Future<void> _openStore(BuildContext context) async {
    final uri = Uri.tryParse(update.storeUrl);
    final launched =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showSnack(RemoteConfigStrings.cannotOpenStoreLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.system_update_outlined,
                  color: AppColors.accentBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    RemoteConfigStrings.updateAvailableTitle,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              update.message.isNotEmpty
                  ? update.message
                  : RemoteConfigStrings.updateAvailableMessageFallback,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _openStore(context),
                child: const Text(RemoteConfigStrings.updateButton),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(RemoteConfigStrings.updateAvailableLater),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
