import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../home_strings.dart';
import '../providers/app_version_provider.dart';

class HomeFooter extends ConsumerWidget {
  const HomeFooter({super.key});

  Future<void> _openRepository(BuildContext context) async {
    final uri = Uri.parse(HomeStrings.repositoryUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showSnack(HomeStrings.cannotOpenRepositoryLink);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final mutedStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: colorScheme.onSurfaceVariant);
    final version = ref.watch(appVersionProvider).value;

    return Center(
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _openRepository(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AssetPaths.iconGithub,
                    width: 15,
                    height: 15,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(HomeStrings.repositoryLabel, style: mutedStyle),
                ],
              ),
            ),
          ),
          if (version != null) Text('v$version', style: mutedStyle),
        ],
      ),
    );
  }
}
