import 'package:flutter/material.dart';
import 'package:univalle_app/core/theme/app_colors.dart';

import '../theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.appBar,
    this.actions,
    required this.body,
    this.padding = AppSpacing.screenPadding,
    this.scrollable = true,
  });

  final String? title;
  final PreferredSizeWidget? appBar;
  final List<Widget>? actions;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final resolvedAppBar =
        appBar ??
        (title != null
            ? AppBar(
                title: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                actions: actions,
                surfaceTintColor: AppColors.white,
              )
            : null);
    final content = Padding(padding: padding, child: body);

    return Scaffold(
      appBar: resolvedAppBar,
      body: SafeArea(
        child: scrollable
            ? LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: content,
                  ),
                ),
              )
            : content,
      ),
    );
  }
}
