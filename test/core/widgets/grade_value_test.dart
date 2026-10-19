import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/core/widgets/grade_value.dart';

import '../../helpers/pump_app.dart';

Color? _colorOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style?.color;

void main() {
  testWidgets('colors a failing grade with the error color', (tester) async {
    await tester.pumpApp(const GradeValue(rawGrade: '2.5'));

    final error = Theme.of(tester.element(find.byType(GradeValue)))
        .colorScheme
        .error;
    expect(_colorOf(tester, '2.5'), error);
  });

  testWidgets('colors a regular grade amber', (tester) async {
    await tester.pumpApp(const GradeValue(rawGrade: '3.5'));

    expect(_colorOf(tester, '3.5'), AppColors.accentAmber);
  });

  testWidgets('colors an outstanding grade green', (tester) async {
    await tester.pumpApp(const GradeValue(rawGrade: '4.5'));

    expect(_colorOf(tester, '4.5'), AppColors.accentGreen);
  });

  testWidgets('shows non-numeric text as-is in a neutral color', (
    tester,
  ) async {
    await tester.pumpApp(const GradeValue(rawGrade: 'Cancelada'));

    final neutral = Theme.of(tester.element(find.byType(GradeValue)))
        .colorScheme
        .onSurfaceVariant;
    expect(_colorOf(tester, 'Cancelada'), neutral);
  });

  testWidgets('treats an out-of-range number as non-numeric', (tester) async {
    await tester.pumpApp(const GradeValue(rawGrade: '7'));

    final neutral = Theme.of(tester.element(find.byType(GradeValue)))
        .colorScheme
        .onSurfaceVariant;
    expect(_colorOf(tester, '7'), neutral);
  });

  testWidgets('shows a placeholder for an empty grade', (tester) async {
    await tester.pumpApp(const GradeValue(rawGrade: ''));

    expect(find.text(AppStrings.noGradeValue), findsOneWidget);
  });
}
