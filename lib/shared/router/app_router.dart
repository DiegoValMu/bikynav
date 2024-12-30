import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/screens/screens.dart';

import 'package:bikynav/features/users/presentation/screens/screens.dart';

final appRouter = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.uri.toString() == '/login';


    if (user != null && loggingIn) {
      // Si está autenticado y está en /login, redirige a la pantalla principal
      return '/nav';
    }

    return null; // No redirige si no es necesario
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/new-user',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/nav',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/gps-access',
      builder: (context, state) => const GpsAccessScreen(),
    ),

  ],
);
