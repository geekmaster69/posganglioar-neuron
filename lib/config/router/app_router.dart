// import 'package:candy_tracker/config/router/routes_screens.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';

import 'package:candy_tracker/config/router/routes_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = ValueNotifier<AuthState>(ref.read(authProvider));

  ref.listen(authProvider, (_, next) {
    listenable.value = next;
  });

  final protectedRoutes = ['/', '/newstore', '/profile'];

  return GoRouter(
    refreshListenable: listenable,
    initialLocation: '/map',
    routes: routes,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final authStatus = authState.authStatus;
      final isGoingTo = state.uri.path;

      if (authStatus == AuthStatus.checking) return null;

      final isProtected = protectedRoutes.contains(isGoingTo);

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isProtected) {
          return '/login';
        }
        return null;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return '/';
        }

        return null;
      }

      return null;
    },
  );
});
