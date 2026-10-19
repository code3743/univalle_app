import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/library_loan.dart';
import '../../library_strings.dart';

class LibraryLoanTile extends StatefulWidget {
  const LibraryLoanTile({super.key, required this.loan, required this.onRenew});

  final LibraryLoan loan;
  final Future<void> Function() onRenew;

  @override
  State<LibraryLoanTile> createState() => _LibraryLoanTileState();
}

class _LibraryLoanTileState extends State<LibraryLoanTile> {
  bool _renewing = false;

  Future<void> _renew() async {
    setState(() => _renewing = true);
    try {
      await widget.onRenew();
    } finally {
      if (mounted) setState(() => _renewing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loan = widget.loan;
    final mutedStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );
    return Material(
      color: AppColors.white,
      shadowColor: AppColors.accentBlue,
      borderRadius: BorderRadius.circular(20),
      elevation: .1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: AppColors.accentBlue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loan.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mutedStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${LibraryStrings.dueDateLabel}: ${loan.dueDate}',
                    style: mutedStyle,
                  ),
                  if (loan.hasFine) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${LibraryStrings.fineLabel}: \$${loan.fine}',
                      style: mutedStyle?.copyWith(color: colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _renewing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton.icon(
                            onPressed: _renew,
                            icon: const Icon(Icons.autorenew, size: 18),
                            label: const Text(LibraryStrings.renewAction),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
