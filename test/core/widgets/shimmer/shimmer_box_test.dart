import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/shimmer/shimmer_box.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders a rounded rectangle at the given size', (tester) async {
    await tester.pumpApp(const ShimmerBox(width: 100, height: 40, radius: 6));

    final decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
            as BoxDecoration;
    expect(decoration.shape, BoxShape.rectangle);
    expect(decoration.borderRadius, BorderRadius.circular(6));

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).last);
    expect(sizedBox.width, 100);
    expect(sizedBox.height, 40);
  });

  testWidgets('ShimmerBox.circle renders a circle at the given size', (
    tester,
  ) async {
    await tester.pumpApp(const ShimmerBox.circle(48));

    final decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
            as BoxDecoration;
    expect(decoration.shape, BoxShape.circle);

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).last);
    expect(sizedBox.width, 48);
    expect(sizedBox.height, 48);
  });
}
