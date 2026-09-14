import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../library_strings.dart';

enum LibraryTab { loans, history }

class LibraryTabSelector extends StatelessWidget {
  const LibraryTabSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final LibraryTab selected;
  final ValueChanged<LibraryTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabSegment(
              label: LibraryStrings.loansTab,
              isSelected: selected == LibraryTab.loans,
              onTap: () => onSelected(LibraryTab.loans),
            ),
          ),
          Expanded(
            child: _TabSegment(
              label: LibraryStrings.historyTab,
              isSelected: selected == LibraryTab.history,
              onTap: () => onSelected(LibraryTab.history),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isSelected ? colorScheme.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 1 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.univalleRed
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
