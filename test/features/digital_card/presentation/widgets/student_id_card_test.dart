import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/digital_card/digital_card_strings.dart';
import 'package:univalle_app/features/digital_card/presentation/widgets/student_id_card/header_shine.dart';
import 'package:univalle_app/features/digital_card/presentation/widgets/student_id_card/student_id_card.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, {String? photoUrl}) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      SingleChildScrollView(
        child: StudentIdCard(
          student: fakeStudent(),
          studentCode: '202012345',
          photoUrl: photoUrl,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('shows the student identity and card fields', (tester) async {
    await pumpCard(tester);

    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
    expect(find.text('202012345'), findsOneWidget);
    expect(find.text('1234567'), findsOneWidget);
    expect(find.text('Meléndez'), findsOneWidget);
    expect(find.text(DigitalCardStrings.studentBadge), findsOneWidget);
    expect(find.text(DigitalCardStrings.disclaimer), findsOneWidget);
  });

  testWidgets('falls back to both initials without a photo', (tester) async {
    await pumpCard(tester);

    expect(find.text('JP'), findsOneWidget);
  });

  testWidgets('encodes the verification payload and the code barcode', (
    tester,
  ) async {
    await pumpCard(tester);

    final codes = tester
        .widgetList<BarcodeWidget>(find.byType(BarcodeWidget))
        .toList();
    final data = codes.map((c) => utf8.decode(c.data as List<int>)).toList();
    expect(data, contains('202012345|Juan Pérez|1234567'));
    expect(data, contains('202012345'));
    expect(find.byType(HeaderShine), findsOneWidget);
  });
}
