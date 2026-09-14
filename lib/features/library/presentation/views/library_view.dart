import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/library_loan_record.dart';
import '../../library_strings.dart';
import '../viewmodels/library_view_model.dart';
import '../widgets/library_empty_state.dart';
import '../widgets/library_record_tile.dart';
import '../widgets/library_tab_bar.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final accountState = ref.watch(libraryViewModelProvider);

    return AppScaffold(
      title: LibraryStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: accountState,
        onRetry: () => ref.invalidate(libraryViewModelProvider),
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
                    _RecordList(
                      records: account.currentLoans,
                      emptyIcon: Icons.check_circle_outline,
                      emptyMessage: LibraryStrings.emptyLoans,
                    ),
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
