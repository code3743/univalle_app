import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../domain/entities/app_config.dart';
import '../../remote_config_strings.dart';
import '../widgets/blocking_message_view.dart';

class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key, required this.update});

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
    return BlockingMessageView(
      icon: Icons.system_update_outlined,
      title: RemoteConfigStrings.updateRequiredTitle,
      message: update.message.isNotEmpty
          ? update.message
          : RemoteConfigStrings.updateRequiredMessageFallback,
      actionLabel: RemoteConfigStrings.updateButton,
      onAction: () => _openStore(context),
    );
  }
}
