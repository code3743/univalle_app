import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/widgets/app_scaffold.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/session/current_photo_url_provider.dart';
import '../../../../core/session/current_username_provider.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../../profile/presentation/viewmodels/profile_view_model.dart';
import '../../digital_card_strings.dart';
import '../widgets/student_id_card.dart';

class DigitalCardView extends ConsumerWidget {
  const DigitalCardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final profileState = ref.watch(profileViewModelProvider);
    final studentCode = ref.watch(currentUsernameProvider) ?? '';
    final photoUrl = ref.watch(currentPhotoUrlProvider);

    return AppScaffold(
      title: DigitalCardStrings.title,
      body: AsyncValueWidget(
        value: profileState,
        onRetry: () => ref.invalidate(profileViewModelProvider),
        data: (student) => StudentIdCard(
          student: student,
          studentCode: studentCode,
          photoUrl: photoUrl,
        ),
      ),
    );
  }
}
