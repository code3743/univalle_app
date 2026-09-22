import 'package:flutter/material.dart';

import '../../home_strings.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HomeStrings.greeting,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '$firstName 👋',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          HomeStrings.tagline,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
