import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/info_card.dart';
import '../../domain/entities/library_loan.dart';
import '../../domain/entities/library_loan_record.dart';
import '../../library_strings.dart';
import '../viewmodels/library_view_model.dart';
import '../widgets/library_empty_state.dart';
import '../widgets/library_loan_tile.dart';
import '../widgets/library_record_tile.dart';
import '../widgets/library_skeleton.dart';
import '../widgets/library_tab_bar.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(libraryViewModelProvider);

    return AppScaffold(
      title: LibraryStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: accountState,
        onRetry: () => ref.invalidate(libraryViewModelProvider),
        skeleton: const LibrarySkeleton(),
        data: (account) => DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                iconAsset: AssetPaths.iconFine,
                label: LibraryStrings.currentFineLabel,
                value: account.currentFine,
                accent: AppColors.accentPink,
              ),
              const SizedBox(height: AppSpacing.lg),
              const LibraryTabBar(),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: TabBarView(
                  children: [
                    _LoanList(account.currentLoans),
                    _RecordList(
                      records: account.history,
                      emptyIcon: Icons.menu_book_outlined,
                      emptyMessage: LibraryStrings.emptyHistory,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordList extends StatelessWidget {
  const _RecordList({
    required this.records,
    required this.emptyIcon,
    required this.emptyMessage,
  });

  final List<LibraryLoanRecord> records;
  final IconData emptyIcon;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return LibraryEmptyState(icon: emptyIcon, message: emptyMessage);
    }
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) =>
          LibraryRecordTile(record: records[index]),
    );
  }
}

class _LoanList extends ConsumerWidget {
  const _LoanList(this.loans);

  final List<LibraryLoan> loans;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (loans.isEmpty) {
      return const LibraryEmptyState(
        icon: Icons.check_circle_outline,
        message: LibraryStrings.emptyLoans,
      );
    }
    return ListView.separated(
      itemCount: loans.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final loan = loans[index];
        return LibraryLoanTile(
          loan: loan,
          onRenew: () async {
            final result = await ref
                .read(libraryViewModelProvider.notifier)
                .renewLoan(loan.code);
            if (!context.mounted) return;
            context.showSnack(
              result.fold(
                onError: (failure) => failure.userMessage,
                onSuccess: (dueDate) =>
                    '${LibraryStrings.renewSuccess} $dueDate',
              ),
            );
          },
        );
      },
    );
  }
}
