import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_skeleton.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders without overflow at phone size', (tester) async {
    await tester.pumpApp(const LibrarySkeleton());

    expect(tester.takeException(), isNull);
    expect(find.byType(LibrarySkeleton), findsOneWidget);
  });
}
