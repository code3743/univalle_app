import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: AppStrings.loading,
      child: animate
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  final dx = bounds.width * (2 * _controller.value - 1);
                  return const LinearGradient(
                    colors: [
                      AppColors.shimmerBase,
                      AppColors.shimmerHighlight,
                      AppColors.shimmerBase,
                    ],
                    stops: [0.35, 0.5, 0.65],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds.shift(Offset(dx, 0)));
                },
                child: child,
              ),
              child: widget.child,
            )
          : widget.child,
    );
  }
}
