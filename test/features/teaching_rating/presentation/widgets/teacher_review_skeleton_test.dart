import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_review_skeleton.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders without overflow at phone size', (tester) async {
    await tester.pumpApp(const TeacherReviewSkeleton());

    expect(tester.takeException(), isNull);
    expect(find.byType(TeacherReviewSkeleton), findsOneWidget);
  });
}
