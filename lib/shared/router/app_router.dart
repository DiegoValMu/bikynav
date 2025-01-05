import 'dart:convert';

import 'package:bikynav/features/route/presentation/screens/route_screen.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/features/users/presentation/screens/perfil_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/screens/screens.dart';

import 'package:bikynav/features/users/presentation/screens/screens.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.uri.toString() == '/';

    if (user != null && loggingIn) {
      final userServices = Provider.of<UserServices>(context, listen: false);

      String? idToken = await user.getIdToken();

      final res = await userServices.authFireInMongo(idToken);

      final Map<String, dynamic> usr = json.decode(res);

      userServices.userData(usr['_id']);
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
    GoRoute(
      path: '/route',
      builder: (context, state) => const RouteScreen(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const PerfilScreen(),
    ),

  ],
);
