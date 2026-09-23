import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/shimmer/shimmer_box.dart';
import 'package:univalle_app/core/widgets/shimmer/skeleton_list.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders itemCount boxes', (tester) async {
    await tester.pumpApp(const SkeletonList(itemCount: 4));

    expect(find.byType(ShimmerBox), findsNWidgets(4));
  });

  testWidgets('defaults to 6 items', (tester) async {
    await tester.pumpApp(const SkeletonList());

    expect(find.byType(ShimmerBox), findsNWidgets(6));
  });
}
