import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/user_avatar.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the initials when there is no photo url', (tester) async {
    await tester.pumpApp(const UserAvatar(radius: 24, initials: 'JP'));

    expect(find.text('JP'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('uses the given background color for the initials badge', (
    tester,
  ) async {
    await tester.pumpApp(
      const UserAvatar(
        radius: 24,
        initials: 'JP',
        backgroundColor: Colors.purple,
      ),
    );

    expect(
      tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor,
      Colors.purple,
    );
  });

  testWidgets(
    'builds a network image sized to the radius when a url is given',
    (tester) async {
      await tester.pumpApp(
        const UserAvatar(
          radius: 20,
          initials: 'JP',
          photoUrl: 'https://photos.example/jperez.jpg',
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.cover);
      expect(
        tester.getSize(
          find
              .descendant(
                of: find.byType(ClipOval),
                matching: find.byType(SizedBox),
              )
              .first,
        ),
        const Size(40, 40),
      );
    },
  );

  testWidgets('falls back to the initials while loading and on error', (
    tester,
  ) async {
    await tester.pumpApp(
      const UserAvatar(
        radius: 20,
        initials: 'JP',
        photoUrl: 'https://photos.example/jperez.jpg',
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final context = tester.element(find.byType(Image));

    final loading = image.frameBuilder!(context, const SizedBox(), null, false);
    final loaded = image.frameBuilder!(
      context,
      const SizedBox(key: Key('done')),
      0,
      false,
    );
    final errored = image.errorBuilder!(context, Exception('x'), null);

    expect(loading, isA<CircleAvatar>());
    expect(loaded.key, const Key('done'));
    expect(errored, isA<CircleAvatar>());
  });
}
