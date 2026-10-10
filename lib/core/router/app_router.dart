import 'package:go_router/go_router.dart';
import 'package:pf_systech_frontend/presentation/screens/client_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientScreen(),
    ),
  ],
);
