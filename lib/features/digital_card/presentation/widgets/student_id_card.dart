import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../profile/domain/entities/student.dart';
import '../../digital_card_strings.dart';

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

  String get _initials {
    final first = student.firstName.isNotEmpty ? student.firstName[0] : '';
    final last = student.lastName.isNotEmpty ? student.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

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
          color: colorScheme.surface,
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
            _Header(
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
                        _IdField(
                          label: DigitalCardStrings.codeLabel,
                          value: studentCode,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _IdField(
                          label: DigitalCardStrings.documentLabel,
                          value: student.documentId,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _IdField(
                          label: DigitalCardStrings.campusLabel,
                          value: student.campus,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _QrBadge(data: _qrData),
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
              child: _BarcodeStrip(data: studentCode),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.student,
    required this.initials,
    required this.fullName,
    this.photoUrl,
  });

  final Student student;
  final String initials;
  final String fullName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.univalleRed, AppColors.univalleRedDark],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _HeaderShine()),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg + 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppLogo(size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        DigitalCardStrings.studentBadge,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: UserAvatar(
                    radius: 52,
                    initials: initials,
                    photoUrl: photoUrl,
                    backgroundColor: colorScheme.surface,
                    textStyle: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.programName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdField extends StatelessWidget {
  const _IdField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _QrBadge extends StatelessWidget {
  const _QrBadge({required this.data});

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

class _BarcodeStrip extends StatelessWidget {
  const _BarcodeStrip({required this.data});

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

/// Diagonal glint that periodically sweeps across the header, evoking the
/// holographic strip on a physical card. Idles off-screen most of the time
/// (see the [Interval]) so it reads as an occasional glint, not a scan line.
class _HeaderShine extends StatefulWidget {
  const _HeaderShine();

  @override
  State<_HeaderShine> createState() => _HeaderShineState();
}

class _HeaderShineState extends State<_HeaderShine>
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
