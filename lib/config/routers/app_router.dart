import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/auth/presentation/screens/login_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    )
  ]);
});
