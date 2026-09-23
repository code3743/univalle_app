import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/profile/presentation/widgets/profile_skeleton.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders without overflow at phone size', (tester) async {
    await tester.pumpApp(const SingleChildScrollView(child: ProfileSkeleton()));

    expect(tester.takeException(), isNull);
    expect(find.byType(ProfileSkeleton), findsOneWidget);
  });
}
