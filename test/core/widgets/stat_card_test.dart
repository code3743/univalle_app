import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/asset_paths.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/core/widgets/stat_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label and the value', (tester) async {
    await tester.pumpApp(
      const StatCard(
        iconAsset: AssetPaths.iconStar,
        value: '4.1',
        label: 'Promedio',
        accent: AppColors.univalleRed,
      ),
    );

    expect(find.text('Promedio'), findsOneWidget);
    expect(find.text('4.1'), findsOneWidget);
  });
}
