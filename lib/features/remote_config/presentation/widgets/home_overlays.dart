import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_config.dart';
import '../viewmodels/home_overlays_view_model.dart';
import 'update_available_sheet.dart';
import 'welcome_banner_dialog.dart';

/// Mounted inside Home; on first build with a resolved [AppConfig] it shows
/// at most one overlay, in priority order: a bottom sheet for an optional
/// app update, or (if none, or already dismissed) a dialog for the welcome
/// banner. The two never stack.
class HomeOverlays extends ConsumerStatefulWidget {
  const HomeOverlays({super.key, required this.config});

  final AppConfig? config;

  @override
  ConsumerState<HomeOverlays> createState() => _HomeOverlaysState();
}

class _HomeOverlaysState extends ConsumerState<HomeOverlays> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    _maybeScheduleShow();
  }

  // `config` typically arrives via a rebuild (the async config fetch
  // resolving after Home first mounts), not at construction time, so this
  // has to be checked again on every widget update, not just in initState.
  @override
  void didUpdateWidget(covariant HomeOverlays oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeScheduleShow();
  }

  void _maybeScheduleShow() {
    final config = widget.config;
    if (_shown || config == null) return;
    _shown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShow(config));
  }

  Future<void> _maybeShow(AppConfig config) async {
    if (!mounted) return;
    final overlays = ref.read(homeOverlaysViewModelProvider.notifier);

    final update = config.update;
    if (await overlays.shouldShowUpdateSheet(update)) {
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => UpdateAvailableSheet(update: update),
      );
      await overlays.dismissUpdate(update.latestVersion);
      return;
    }

    final welcome = config.welcome;
    if (await overlays.shouldShowWelcomeBanner(welcome)) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => WelcomeBannerDialog(banner: welcome),
      );
      await overlays.markWelcomeSeen(welcome);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
