import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/digital_card/presentation/views/digital_card_view.dart';
import '../../features/home/presentation/views/all_shortcuts_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/library/presentation/views/library_view.dart';
import '../../features/news/presentation/views/news_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/remote_config/presentation/views/announcements_view.dart';
import '../../features/remote_config/presentation/viewmodels/remote_config_view_model.dart';
import '../../features/resolution/presentation/views/resolution_view.dart';
import '../../features/restaurant/presentation/views/pending_payment_view.dart';
import '../../features/restaurant/presentation/views/restaurant_view.dart';
import '../../features/schedule/presentation/views/schedule_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/student_grades/presentation/views/grades_view.dart';
import '../../features/student_tabulate/presentation/views/tabulate_view.dart';
import '../../features/teaching_rating/domain/entities/teacher_to_rate.dart';
import '../../features/teaching_rating/presentation/views/teacher_review_view.dart';
import '../../features/teaching_rating/presentation/views/teachers_to_rate_view.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

/// The single place that decides where the app is allowed to be: waits on
/// `/splash` until the restored session and the remote config both settle,
/// then sends the user to Home or Login; everywhere else, bounces to Login
/// when there's no session and bounces away from Login when there is one.
/// Replaces the `ref.listen(authViewModelProvider, ...)` block every
/// protected view used to duplicate.
@visibleForTesting
String? appRouterRedirect(Ref ref, GoRouterState state) {
  final location = state.matchedLocation;
  final authState = ref.read(authViewModelProvider);

  if (location == AppRoutes.splash) {
    if (authState.isLoading ||
        ref.read(remoteConfigViewModelProvider).isLoading) {
      return null;
    }
    return (authState.value ?? false) ? AppRoutes.home : AppRoutes.login;
  }

  // While auth is mid-transition (the initial restore, or an in-flight
  // login()/logout()) nothing is forced — e.g. this keeps Home from being
  // yanked out from under the user the instant logout() flips the state to
  // AsyncLoading, before it's known whether the logout even succeeded.
  if (authState.isLoading) return null;

  final isLoggedIn = authState.value ?? false;
  final isPublicRoute =
      location == AppRoutes.login || location == AppRoutes.forgotPassword;

  if (!isLoggedIn && !isPublicRoute) return AppRoutes.login;
  if (isLoggedIn && location == AppRoutes.login) return AppRoutes.home;
  return null;
}

/// Tells [GoRouter] to re-run [appRouterRedirect] whenever the session or
/// the remote config changes, so e.g. a logout triggers a redirect on its
/// own instead of needing every view to react to it individually.
@visibleForTesting
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Ref ref) {
    ref.listen(authViewModelProvider, (_, _) => notifyListeners());
    ref.listen(remoteConfigViewModelProvider, (_, _) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => appRouterRedirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
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
        path: AppRoutes.news,
        builder: (context, state) => const NewsView(),
      ),
      GoRoute(
        path: AppRoutes.allFunctionalities,
        builder: (context, state) => const AllShortcutsView(),
      ),
      GoRoute(
        path: AppRoutes.announcements,
        builder: (context, state) => const AnnouncementsView(),
      ),
    ],
  );
}
