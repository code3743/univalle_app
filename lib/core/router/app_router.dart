import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/digital_card/presentation/views/digital_card_view.dart';
import '../../features/home/presentation/views/all_shortcuts_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/library/presentation/views/library_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/resolution/presentation/views/resolution_view.dart';
import '../../features/restaurant/presentation/views/pending_payment_view.dart';
import '../../features/restaurant/presentation/views/restaurant_view.dart';
import '../../features/schedule/presentation/views/schedule_view.dart';
import '../../features/student_grades/presentation/views/grades_view.dart';
import '../../features/student_tabulate/presentation/views/tabulate_view.dart';
import '../../features/teaching_rating/domain/entities/teacher_to_rate.dart';
import '../../features/teaching_rating/presentation/views/teacher_review_view.dart';
import '../../features/teaching_rating/presentation/views/teachers_to_rate_view.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.grades,
        builder: (context, state) => const GradesView(),
      ),
      GoRoute(
        path: AppRoutes.digitalCard,
        builder: (context, state) => const DigitalCardView(),
      ),
      GoRoute(
        path: AppRoutes.tabulate,
        builder: (context, state) => const TabulateView(),
      ),
      GoRoute(
        path: AppRoutes.resolution,
        builder: (context, state) => const ResolutionView(),
      ),
      GoRoute(
        path: AppRoutes.teacherRating,
        builder: (context, state) => const TeachersToRateView(),
      ),
      GoRoute(
        path: AppRoutes.teacherReview,
        builder: (context, state) =>
            TeacherReviewView(teacher: state.extra! as TeacherToRate),
      ),
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) => const ScheduleView(),
      ),
      GoRoute(
        path: AppRoutes.restaurant,
        builder: (context, state) => const RestaurantView(),
      ),
      GoRoute(
        path: AppRoutes.pendingPayment,
        builder: (context, state) => const PendingPaymentView(),
      ),
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const LibraryView(),
      ),
      GoRoute(
        path: AppRoutes.allFunctionalities,
        builder: (context, state) => const AllShortcutsView(),
      ),
    ],
  );
}
