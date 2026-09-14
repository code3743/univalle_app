import 'package:flutter/material.dart';

import '../../domain/entities/rating_option.dart';

class RatingOptionsList extends StatelessWidget {
  const RatingOptionsList({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RatingOption? selected;
  final ValueChanged<RatingOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<RatingOption>(
      groupValue: selected,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in RatingOption.values)
            RadioListTile<RatingOption>(
              value: option,
              title: Text(option.label),
            ),
        ],
      ),
    );
  }
}
