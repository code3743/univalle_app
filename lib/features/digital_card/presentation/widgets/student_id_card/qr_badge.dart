import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class QrBadge extends StatelessWidget {
  const QrBadge({super.key, required this.data});

  final String data;

  static const _size = 132.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.qrBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarcodeWidget(
        data: data,
        barcode: Barcode.qrCode(),
        color: AppColors.qrForeground,
        drawText: false,
      ),
    );
  }
}
