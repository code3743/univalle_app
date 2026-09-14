import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Same pastel-fill recipe as `StatCard`/`ShortcutCard`, but for static,
/// non-actionable information — no chevron, no tap target.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.accent,
  });

  final String iconAsset;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: colorScheme.surface, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
