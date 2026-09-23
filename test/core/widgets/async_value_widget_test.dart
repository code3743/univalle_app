import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/app_error_view.dart';
import 'package:univalle_app/core/widgets/async_value_widget.dart';
import 'package:univalle_app/core/widgets/shimmer/shimmer_box.dart';
import 'package:univalle_app/core/widgets/shimmer/skeleton_list.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the data widget when loaded', (tester) async {
    await tester.pumpApp(
      AsyncValueWidget<int>(
        value: const AsyncData(1),
        data: (value) => Text('value: $value'),
      ),
    );

    expect(find.text('value: 1'), findsOneWidget);
  });

  testWidgets('shows a SkeletonList while loading by default', (tester) async {
    await tester.pumpApp(
      AsyncValueWidget<int>(
        value: const AsyncLoading(),
        data: (value) => Text('value: $value'),
      ),
    );
    await tester.pump();

    expect(find.byType(SkeletonList), findsOneWidget);
  });

  testWidgets('shows the given skeleton while loading', (tester) async {
    await tester.pumpApp(
      AsyncValueWidget<int>(
        value: const AsyncLoading(),
        data: (value) => Text('value: $value'),
        skeleton: const ShimmerBox(height: 40),
      ),
    );
    await tester.pump();

    expect(find.byType(SkeletonList), findsNothing);
    expect(find.byType(ShimmerBox), findsOneWidget);
  });

  testWidgets('shows AppErrorView on error', (tester) async {
    await tester.pumpApp(
      AsyncValueWidget<int>(
        value: AsyncError(Exception('boom'), StackTrace.empty),
        data: (value) => Text('value: $value'),
      ),
    );

    expect(find.byType(AppErrorView), findsOneWidget);
  });
}
