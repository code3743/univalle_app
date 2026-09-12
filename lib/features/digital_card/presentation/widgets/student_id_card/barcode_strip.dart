import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class BarcodeStrip extends StatelessWidget {
  const BarcodeStrip({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.qrBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarcodeWidget(
        data: data,
        barcode: Barcode.code128(),
        color: AppColors.qrForeground,
        drawText: false,
      ),
    );
  }
}
