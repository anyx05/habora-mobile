import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/auth_provider.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/signup_confirmation_screen.dart';
import '../features/ports/ports_screen.dart';
import '../features/ports/port_detail_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/bookings/booking_detail_screen.dart';
import '../features/bookings/booking_flow/booking_flow_screen.dart';
import '../features/bookings/booking_success_screen.dart';
import '../features/account/account_screen.dart';
import '../features/account/add_vessel_screen.dart';
import '../shared/widgets/bottom_nav_bar.dart';
import '../widget_showcase_screen.dart';

abstract final class Routes {
  static const ports          = '/ports';
  static const portDetail     = '/ports/:id';
  static const bookings       = '/bookings';
  static const bookingDetail  = '/bookings/:id';
  static const bookingNew     = '/booking/new';
  static const bookingSuccess = '/booking/success';
  static const account        = '/account';
  static const addVessel      = '/account/vessels/add';
  static const login          = '/auth/login';
  static const signup         = '/auth/signup';
  static const forgotPassword        = '/auth/forgot-password';
  static const signupConfirmation    = '/auth/signup-confirmation';

  // TEMPORARY — remove before shipping
  static const showcase = '/dev/showcase';
}

bool _requiresAuth(String path) =>
    path.startsWith('/bookings') ||
    path.startsWith('/booking/') ||
    path.startsWith('/account');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: const String.fromEnvironment(
      'INITIAL_ROUTE',
      defaultValue: Routes.ports,
    ),
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull?.session != null;
      final path = state.matchedLocation;

      if (_requiresAuth(path) && !isAuthenticated) {
        final returnTo = Uri.encodeComponent(path);
        return '${Routes.login}?returnTo=$returnTo';
      }
      return null;
    },
    routes: [
      // Shell wraps the three main tabs with the bottom nav bar
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: Routes.ports,
            name: 'ports',
            builder: (context, state) => const PortsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'portDetail',
                builder: (context, state) =>
                    PortDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: Routes.bookings,
            name: 'bookings',
            builder: (context, state) => const BookingsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'bookingDetail',
                builder: (context, state) =>
                    BookingDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: Routes.account,
            name: 'account',
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),

      // Booking flow (outside shell — full screen)
      GoRoute(
        path: Routes.bookingNew,
        name: 'bookingNew',
        builder: (context, state) {
          final p = state.uri.queryParameters;
          return BookingFlowScreen(
            berthId:            p['berthId']  ?? '',
            portId:             p['portId']   ?? '',
            berthName:          p['berthName'] ?? '',
            portName:           p['portName']  ?? '',
            berthPricePerNight: double.tryParse(p['berthPrice'] ?? '') ?? 0,
            arrivalDate:   p['arrival']   != null
                ? DateTime.tryParse(p['arrival']!)
                : null,
            departureDate: p['departure'] != null
                ? DateTime.tryParse(p['departure']!)
                : null,
          );
        },
      ),

      // Booking success (outside shell — full screen)
      GoRoute(
        path: Routes.bookingSuccess,
        name: 'bookingSuccess',
        builder: (context, state) {
          final p = state.uri.queryParameters;
          return BookingSuccessScreen(
            bookingId:        p['bookingId'] ?? '',
            confirmationCode: p['code']      ?? '',
            portName:         p['port']      ?? '',
            berthName:        p['berth']     ?? '',
            arrivalDate:   p['arrival']   != null
                ? DateTime.tryParse(p['arrival']!)
                : null,
            departureDate: p['departure'] != null
                ? DateTime.tryParse(p['departure']!)
                : null,
            totalPrice:    double.tryParse(p['total'] ?? '') ?? 0,
            customerEmail: p['email'] ?? '',
          );
        },
      ),

      GoRoute(
        path: Routes.addVessel,
        name: 'addVessel',
        builder: (context, state) => const AddVesselScreen(),
      ),

      // Auth routes (outside shell)
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        name: 'signup',
        builder: (context, state) => const AuthScreen(initialSignUp: true),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.signupConfirmation,
        name: 'signupConfirmation',
        builder: (context, state) => SignupConfirmationScreen(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),

      // TEMPORARY — remove before shipping
      GoRoute(
        path: Routes.showcase,
        name: 'showcase',
        builder: (context, state) => const WidgetShowcaseScreen(),
      ),
    ],
  );
});

class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  static const _tabs = [Routes.ports, Routes.bookings, Routes.account];

  int _indexForLocation(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _indexForLocation(location),
        onTap: (i) => context.go(_tabs[i]),
      ),
    );
  }
}
