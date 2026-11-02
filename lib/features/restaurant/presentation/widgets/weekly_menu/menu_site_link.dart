import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/restaurant_constants.dart';
import '../../../../../core/extensions/snackbar_extension.dart';
import '../../../restaurant_strings.dart';

/// Always shown under the menu: the menu is scraped, so when the portal's
/// markup changes this is the user's way out.
class MenuSiteLink extends StatelessWidget {
  const MenuSiteLink({super.key});

  Future<void> _open(BuildContext context) async {
    final launched = await launchUrl(
      Uri.parse(RestaurantConstants.menuUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      context.showSnack(RestaurantStrings.cannotOpenMenuSite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.open_in_new, size: 16),
      label: const Text(RestaurantStrings.menuSiteLabel),
    );
  }
}
