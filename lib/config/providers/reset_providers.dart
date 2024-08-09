import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/profile_picture_provider.dart';
import 'package:univalle_app/config/providers/selected_campus_provider.dart';
import 'package:univalle_app/config/providers/shared_preferences_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/student_grades_provider.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/student_tabulate_provider.dart';

final resetProvider = FutureProvider.autoDispose<void>((ref) async {
  ref.read(profilePictureProvider.notifier).removeImage();
  await ref.read(sharedUtilityProvider).clearStudentData();
  ref.invalidate(selectedCampusProvider);
  ref.invalidate(studentGradesProvider);
  ref.invalidate(studentTabulateProvider);
  return;
});
