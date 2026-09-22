import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/welcome_banner.dart' as domain;
import '../../remote_config_strings.dart';

/// The image is the point of this dialog, so it takes the full width up
/// top; text and actions follow below. Shown with the image missing (rather
/// than skipped) when `imageUrl` is null.
class WelcomeBannerDialog extends StatelessWidget {
  const WelcomeBannerDialog({super.key, required this.banner});

  final domain.WelcomeBanner banner;

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.tryParse(banner.linkUrl ?? '');
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
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (banner.imageUrl != null)
            Image.network(
              banner.imageUrl!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(height: 0),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  banner.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (banner.linkUrl != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _openLink(context),
                      child: const Text(
                        RemoteConfigStrings.welcomeDialogOpenLink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(RemoteConfigStrings.welcomeDialogClose),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
