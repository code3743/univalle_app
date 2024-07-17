import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/auth/presentation/screens/login_screen.dart';
import 'package:univalle_app/features/home/presentation/screens/home_screen.dart';
import 'package:univalle_app/features/student_grades/presentation/screens/student_grades_screen.dart';
import 'package:univalle_app/features/student_tabulate/presentation/screens/tabulate_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/tabulate', routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/student-grades',
      name: 'student-grades',
      builder: (context, state) => const StudentGradesScreen(),
    ),
    GoRoute(
        path: '/tabulate',
        name: 'tabulate',
        builder: (context, state) => const TabulateScreen()),
  ]);
});
