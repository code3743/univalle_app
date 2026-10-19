import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_grades/domain/entities/academic_history.dart';
import 'package:univalle_app/features/student_grades/domain/entities/equivalence.dart';
import 'package:univalle_app/features/student_grades/presentation/viewmodels/grades_view_model.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/equivalences_shortcut.dart';

import '../../../../helpers/pump_app.dart';

const _items = [
  Equivalence(
    code: '111021C',
    name: 'CÁLCULO MONOVARIABLE',
    grade: '3.6',
    typology: 'AB',
    component: 'SIN',
    credits: 3,
  ),
  Equivalence(
    code: '701001C',
    name: 'INSERCIÓN A LA VIDA UNIVERSITARIA',
    grade: '4.8',
    typology: 'AB',
    component: 'EVS',
    credits: 2,
  ),
];

class _FakeGradesViewModel extends GradesViewModel {
  _FakeGradesViewModel(this._items);

  final List<Equivalence> _items;

  @override
  Future<AcademicHistory> build() async =>
      AcademicHistory(periods: const [], equivalences: _items);
}

void main() {
  Future<void> pump(WidgetTester tester, List<Equivalence> items) async {
    final overrides = <Override>[
      gradesViewModelProvider.overrideWith(() => _FakeGradesViewModel(items)),
    ];
    await tester.pumpApp(const EquivalencesShortcut(), overrides: overrides);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'shows the subject and credit totals when there are equivalences',
    (tester) async {
      await pump(tester, _items);

      expect(
        find.text('Equivalencias · 2 materias · 5 créditos'),
        findsOneWidget,
      );
    },
  );

  testWidgets('renders nothing when the student has no equivalences', (
    tester,
  ) async {
    await pump(tester, const []);

    expect(find.byType(InkWell), findsNothing);
  });
}
