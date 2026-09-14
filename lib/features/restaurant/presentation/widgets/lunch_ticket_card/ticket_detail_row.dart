import 'package:flutter/material.dart';
import 'package:univalle_app/core/theme/app_colors.dart';

class TicketDetailRow extends StatelessWidget {
  const TicketDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.univalleRed.withValues(alpha: .8)),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
