import 'package:flutter/material.dart'
    show FormState, GlobalKey, NavigatorState;
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:univalle_app/features/digital_card/presentation/screens/digital_card_screen.dart';
import 'package:univalle_app/features/home/presentation/screens/check_screen.dart';
import 'package:univalle_app/features/auth/presentation/screens/login_screen.dart';
import 'package:univalle_app/features/home/presentation/screens/main_screen.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/student_tabulate/presentation/screens/tabulate_screen.dart';
import 'package:univalle_app/features/program_resolution/presentation/screens/resolution_screen.dart';
import 'package:univalle_app/features/student_grades/presentation/screens/student_grades_screen.dart';
import 'package:univalle_app/features/program_resolution/presentation/screens/detail_semester_screen.dart';
import 'package:univalle_app/features/teaching_rating/presentation/screens/teaching_rating_details.dart';
import 'package:univalle_app/features/teaching_rating/presentation/screens/teaching_rating_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/check',
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      GoRoute(
        path: '/check',
        name: 'check',
        builder: (context, state) => const CheckScreen(),
      ),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            final GlobalKey<FormState> formKey = GlobalKey<FormState>();
            return LoginScreen(formKey: formKey);
          },
          routes: [
            GoRoute(
              path: 'reset-password',
              name: 'reset-password',
              builder: (context, state) {
                final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                return ResetPasswordScreen(formKey: formKey);
              },
            )
          ]),
      GoRoute(
          path: '/main',
          name: 'main',
          builder: (context, state) {
            final hasAuth = state.extra as bool?;
            return MainScreen(hasAuth: hasAuth);
          },
          routes: [
            GoRoute(
              path: 'student-grades',
              name: 'student-grades',
              builder: (context, state) => const StudentGradesScreen(),
            ),
            GoRoute(
                path: 'tabulate',
                name: 'tabulate',
                builder: (context, state) => const TabulateScreen()),
            GoRoute(
                path: 'resolution',
                name: 'resolution',
                builder: (context, state) => const ResolutionScreen(),
                routes: [
                  GoRoute(
                      path: 'detail-semester',
                      name: 'detail-semester',
                      builder: (context, state) {
                        final SubjectCycle subjectCycle =
                            state.extra as SubjectCycle;
                        return DetailSemesterScreen(subjectCycle: subjectCycle);
                      })
                ]),
            GoRoute(
              path: 'digital-card',
              name: 'digital-card',
              builder: (context, state) => const DigitalCardScreen(),
            ),
            GoRoute(
                path: 'teaching-rating',
                name: 'teaching-rating',
                builder: (context, state) => const TeachingRatingScreen(),
                routes: [
                  GoRoute(
                    path: 'teaching-rating-details',
                    name: 'teaching-rating-details',
                    builder: (context, state) {
                      final int index = state.extra as int;
                      return TeachingRatingDetails(index: index);
                    },
                  )
                ])
          ])
    ],
  );
});
