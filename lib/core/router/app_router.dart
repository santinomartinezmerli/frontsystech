import 'package:go_router/go_router.dart';
import 'package:pf_systech_frontend/presentation/screens/client_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/configuration_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/listas_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/login_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/secrets_screen.dart';
import 'package:pf_systech_frontend/presentation/screens/tokens_screen.dart';
import 'package:pf_systech_frontend/presentation/widgets/main_layout.dart';
import 'package:pf_systech_frontend/presentation/screens/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Pantalla fuera del layout (Login no tiene sidebar)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Cáscara común con Sidebar para todas las pantallas del sistema
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/client',
          builder: (context, state) => const ClientScreen(),
        ),
        GoRoute(
          path: '/configuration',
          builder: (context, state) => const ConfigurationScreen(),
        ),
        GoRoute(
          path: '/list',
          builder: (context, state) => const ListScreen(),
        ),
        GoRoute(
          path: '/secrets',
          builder: (context, state) => const SecretsScreen(),
        ),
        GoRoute(
          path: '/tokens',
          builder: (context, state) => const TokensScreen(),
        ),
      ],
    ),
  ],
);