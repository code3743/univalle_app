import 'package:flutter/material.dart';
import 'package:univalle_app/core/theme/app_colors.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/name_formatter.dart';
import '../../../../profile/domain/entities/student.dart';
import '../../../digital_card_strings.dart';
import 'barcode_strip.dart';
import 'id_card_header.dart';
import 'id_field.dart';
import 'qr_badge.dart';

class StudentIdCard extends StatelessWidget {
  const StudentIdCard({
    super.key,
    required this.student,
    required this.studentCode,
    this.photoUrl,
  });

  final Student student;
  final String studentCode;
  final String? photoUrl;

  String get _fullName => '${student.firstName} ${student.lastName}';

  String get _initials =>
      '${NameFormatter.initial(student.firstName, fallback: '')}'
      '${NameFormatter.initial(student.lastName, fallback: '')}';

  // Verification payload a scanner/gate reader would read back.
  String get _qrData => '$studentCode|$_fullName|${student.documentId}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 24),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            IdCardHeader(
              student: student,
              initials: _initials,
              fullName: _fullName,
              photoUrl: photoUrl,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IdField(
                          label: DigitalCardStrings.codeLabel,
                          value: studentCode,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        IdField(
                          label: DigitalCardStrings.documentLabel,
                          value: student.documentId,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        IdField(
                          label: DigitalCardStrings.campusLabel,
                          value: student.campus,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  QrBadge(data: _qrData),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: BarcodeStrip(data: studentCode),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Text(
                DigitalCardStrings.disclaimer,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
