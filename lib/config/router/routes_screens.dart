import 'package:candy_tracker/features/store/presentation/screens/candy_location_form_screen.dart';
import 'package:candy_tracker/features/store/presentation/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:candy_tracker/features/auth/presentation/screens/screens.dart';
import 'package:candy_tracker/features/map/presentation/screens/screens.dart';

final routes = [
  GoRoute(path: '/map', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(path: '/auth', builder: (context, state) => const AuntScreen()),
  GoRoute(
    path: '/',
    builder: (context, state) => const DashboardScreen(),
  ),
  GoRoute(
    path: '/candy-location/:id',
    builder: (context, state) => CandyLocationFormScreen(
      id: int.parse(state.pathParameters['id'] ?? '-1'),
    ),
  ),
];
