import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/asset_paths.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/core/widgets/info_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label and value without any tap target', (
    tester,
  ) async {
    await tester.pumpApp(
      const InfoCard(
        iconAsset: AssetPaths.iconStar,
        label: 'Campus',
        value: 'Meléndez',
        accent: AppColors.univalleRed,
      ),
    );

    expect(find.text('Campus'), findsOneWidget);
    expect(find.text('Meléndez'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('truncates a long value to two lines', (tester) async {
    await tester.pumpApp(
      InfoCard(
        iconAsset: AssetPaths.iconStar,
        label: 'Programa',
        value: List.filled(40, 'Ingeniería').join(' '),
        accent: AppColors.univalleRed,
      ),
    );

    final value = tester.widget<Text>(find.textContaining('Ingeniería'));
    expect(value.maxLines, 2);
    expect(value.overflow, TextOverflow.ellipsis);
  });
}
