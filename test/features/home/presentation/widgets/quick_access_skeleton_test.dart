import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/shimmer/shimmer_box.dart';
import 'package:univalle_app/features/home/presentation/widgets/quick_access_skeleton.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders itemCount boxes without overflow', (tester) async {
    await tester.pumpApp(const QuickAccessSkeleton());

    expect(tester.takeException(), isNull);
    expect(find.byType(ShimmerBox), findsNWidgets(6));
  });
}
