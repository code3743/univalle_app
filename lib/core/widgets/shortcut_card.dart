import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShortcutCard extends StatelessWidget {
  const ShortcutCard({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: colorScheme.surface, shape: BoxShape.circle),
                    child: Center(
                      child: SvgPicture.asset(
                        iconAsset,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
