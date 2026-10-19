import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/announcement_card.dart';

import '../../../../helpers/pump_app.dart';
import '../remote_config_fixtures.dart';

void main() {
  testWidgets('shows the title and description without an image', (
    tester,
  ) async {
    await tester.pumpApp(AnnouncementCard(announcement: announcement(1)));

    expect(find.text('Título 1'), findsOneWidget);
    expect(find.text('Descripción 1'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows a thumbnail with a placeholder fallback on error', (
    tester,
  ) async {
    await tester.pumpApp(
      AnnouncementCard(
        announcement: announcement(1, imageUrl: 'https://img.example/a.png'),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final context = tester.element(find.byType(Image));
    final fallback = image.errorBuilder!(context, Exception('x'), null);

    expect(fallback, isA<Widget>());
    await tester.pumpWidget(MaterialApp(home: fallback));
    expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
  });
}
