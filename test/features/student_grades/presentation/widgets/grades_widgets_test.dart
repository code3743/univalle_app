import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/equivalence_tile.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/equivalences_summary.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_summary.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_section.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/subject_tile.dart';
import 'package:univalle_app/features/student_grades/student_grades_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../grades_fixtures.dart';

void main() {
  testWidgets('SubjectTile shows the subject details and grade', (
    tester,
  ) async {
    await tester.pumpApp(SubjectTile(subject: subject()));

    expect(find.text('CÁLCULO I'), findsOneWidget);
    expect(
      find.textContaining('${StudentGradesStrings.groupLabel} 01'),
      findsOneWidget,
    );
    expect(find.text('4.2'), findsOneWidget);
    expect(
      find.textContaining(StudentGradesStrings.canceledLabel),
      findsNothing,
    );
  });

  testWidgets('SubjectTile strikes through a canceled subject', (tester) async {
    await tester.pumpApp(
      SubjectTile(subject: subject(isCanceled: true, grade: '')),
    );

    expect(
      find.textContaining(StudentGradesStrings.canceledLabel),
      findsOneWidget,
    );
    final title = tester.widget<Text>(find.text('CÁLCULO I'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('EquivalenceTile shows code, credits, typology and grade', (
    tester,
  ) async {
    await tester.pumpApp(const EquivalenceTile(equivalence: equivalence));

    expect(find.text('CÁLCULO MONOVARIABLE'), findsOneWidget);
    expect(
      find.textContaining(
        '111021C · 3 ${StudentGradesStrings.creditsUnit} · AB',
      ),
      findsOneWidget,
    );
    expect(find.text('3.6'), findsOneWidget);
  });

  testWidgets('EquivalencesSummary totals the subjects and credits', (
    tester,
  ) async {
    await tester.pumpApp(
      const EquivalencesSummary(equivalences: [equivalence, equivalence]),
    );

    expect(find.text('2'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('GradesSummary shows the period count and the best semester', (
    tester,
  ) async {
    await tester.pumpApp(
      GradesSummary(
        periods: [
          period(average: 3.2),
          period(period: 'AGOSTO/2024 - DICIEMBRE/2024', average: 4.6),
        ],
      ),
    );

    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining('4.6'), findsOneWidget);
  });

  testWidgets('PeriodGradesSection lists subjects and the period stats', (
    tester,
  ) async {
    await tester.pumpApp(
      SingleChildScrollView(
        child: PeriodGradesSection(
          grades: period(
            subjects: [
              subject(),
              subject(name: 'FÍSICA I'),
            ],
          ),
          accent: AppColors.accentBlue,
        ),
      ),
    );

    expect(find.text('CÁLCULO I'), findsOneWidget);
    expect(find.text('FÍSICA I'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.byIcon(Icons.workspace_premium), findsNothing);
  });

  testWidgets('PeriodGradesSection marks academic merit with a tooltip', (
    tester,
  ) async {
    await tester.pumpApp(
      SingleChildScrollView(
        child: PeriodGradesSection(
          grades: period(hasAcademicMerit: true),
          accent: AppColors.accentBlue,
        ),
      ),
    );

    expect(find.byIcon(Icons.workspace_premium), findsOneWidget);

    await tester.tap(find.byIcon(Icons.workspace_premium));
    await tester.pump();

    expect(
      find.text(StudentGradesStrings.academicMeritTooltip),
      findsOneWidget,
    );
  });
}
