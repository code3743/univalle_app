import 'package:flutter/material.dart';

/// Diagonal glint that periodically sweeps across the header, evoking the
/// holographic strip on a physical card. Idles off-screen most of the time
/// (see the [Interval]) so it reads as an occasional glint, not a scan line.
class HeaderShine extends StatefulWidget {
  const HeaderShine({super.key});

  @override
  State<HeaderShine> createState() => _HeaderShineState();
}

class _HeaderShineState extends State<HeaderShine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = Curves.easeInOut.transform(
            const Interval(0.55, 1.0).transform(_controller.value),
          );
          return Align(
            alignment: Alignment(-1.6 + 3.2 * progress, 0),
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 60,
                height: 320,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      colorScheme.onPrimary.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
