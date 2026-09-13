import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// The tear line between the ticket's red header and its white body: two
/// circular "punch holes" straddling the card's edges (so the page
/// background shows through where they overlap it) joined by a dashed line.
class TicketPerforation extends StatelessWidget {
  const TicketPerforation({super.key});

  static const _holeDiameter = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _holeDiameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            left: _holeDiameter / 2,
            right: _holeDiameter / 2,
            child: CustomPaint(
              painter: _DashedLinePainter(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          const Positioned(left: -_holeDiameter / 2, child: _Hole()),
          const Positioned(right: -_holeDiameter / 2, child: _Hole()),
        ],
      ),
    );
  }
}

class _Hole extends StatelessWidget {
  const _Hole();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: TicketPerforation._holeDiameter,
      height: TicketPerforation._holeDiameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.pageBackground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  static const _dashWidth = 6.0;
  static const _dashSpace = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + _dashWidth, y), paint);
      x += _dashWidth + _dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
