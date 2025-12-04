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
  // Creamos un Notifier que escuche los cambios del authProvider
  final listenable = ValueNotifier<AuthState>(ref.read(authProvider));

  // Actualizamos el notifier cuando cambia el estado de Riverpod
  ref.listen(authProvider, (_, next) {
    listenable.value = next;
  });

  // Definimos las rutas que requieren autenticación
  final protectedRoutes = ['/','/newstore', '/profile'];

  return GoRouter(
    // refreshListenable hará que el router vuelva a ejecutar 'redirect' cuando cambie el authState
    refreshListenable: listenable,
    initialLocation: '/map',
    routes: routes,
    redirect: (context, state) {
      // Usamos read porque refreshListenable ya se encarga de reaccionar a los cambios
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
        
        if (isGoingTo == '/login' || isGoingTo == '/register' ) {
          return '/';
        }
        
        // Si intenta ir a cualquier otra ruta (incluyendo las protegidas), lo dejamos pasar
        return null;
      }

      return null;
    },
  );
});

// final appRouterProvider = Provider<GoRouter>((ref) {
//   final listenable = ValueNotifier<AuthState>(ref.read(authProvider));

//   ref.listen(authProvider, (_, next) {
//     listenable.value = next;
//   });

//   final protectedRoutes = ['/newstore', '/profile', '/dashboard'];

//   return GoRouter(
//     refreshListenable: listenable,
//     initialLocation: '/',
//     routes: routes,
//     redirect: (context, state) {
//       final authState = ref.read(authProvider);
//       final authStatus = authState.authStatus;
//       final isGoingTo = state.uri.path;

//       if (authStatus == AuthStatus.checking) return null;

//       final isProtected = protectedRoutes.any(
//         (route) => isGoingTo.startsWith(route),
//       );

//       if (authStatus == AuthStatus.notAuthenticated) {
//         if (isProtected) {
//           return '/login?from=$isGoingTo';
//         }

//         return null; 
//       }

//       if (authStatus == AuthStatus.authenticated) {
//         // Si entra a login/register, enviarlo al dashboard SIN perder stack
//         if (isGoingTo == '/login' || isGoingTo == '/register') {
//           return '/dashboard';
//         }

//         return null;
//       }

//       return null;
//     },
//   );
// });
