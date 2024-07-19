import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/home/presentation/screens/home_screen.dart';
import 'package:univalle_app/features/auth/presentation/screens/login_screen.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/student_tabulate/presentation/screens/tabulate_screen.dart';
import 'package:univalle_app/features/program_resolution/presentation/screens/resolution_screen.dart';
import 'package:univalle_app/features/student_grades/presentation/screens/student_grades_screen.dart';
import 'package:univalle_app/features/program_resolution/presentation/screens/detail_semester_screen.dart';

final GlobalKey<NavigatorState> _globalKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home/resolution',
    navigatorKey: _globalKey,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
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
          ]),
    ],
  );
});
