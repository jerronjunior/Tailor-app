import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/features/auth/presentation/screens/role_select_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/customer/presentation/screens/home_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/discover_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/profile_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/order_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/track_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/chat_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/measurements_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_home_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_orders_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_chat_screen.dart';
import 'package:tailor_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'dart:async';

/// Route names
class AppRoutes {
  static const String roleSelect = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String customerHome = '/customer';
  static const String tailorList = '/customer/tailors';
  static const String tailorProfile = '/customer/tailor/:tailorId';
  static const String placeOrder = '/customer/place-order/:tailorId';
  static const String orderHistory = '/customer/orders';
  static const String customerChat = '/customer/chat/:chatId';
  static const String measurementProfiles = '/customer/measurements';
  static const String editProfile = '/profile/edit';
  static const String tailorHome = '/tailor';
  static const String tailorOrders = '/tailor/orders';
  static const String tailorChat = '/tailor/chat/:chatId';
}

/// A [ChangeNotifier] that informs [GoRouter] when to refresh its routes
/// based on a [Stream].
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateProvider.stream);
  return GoRouter(
    initialLocation: AppRoutes.roleSelect,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.valueOrNull != null;
      final userProfile = authState.valueOrNull;
      final isAuthRoute = state.matchedLocation == AppRoutes.roleSelect ||
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation == AppRoutes.forgotPassword;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.roleSelect;
      }
      if (isLoggedIn && userProfile != null && isAuthRoute) {
        if (userProfile.isCustomer) return AppRoutes.customerHome;
        return AppRoutes.tailorHome;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.roleSelect,
        builder: (_, __) => const RoleSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) {
          final role = state.uri.queryParameters['role'] ?? AppConstants.roleCustomer;
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, state) {
          final role = state.uri.queryParameters['role'] ?? AppConstants.roleCustomer;
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      // Customer routes
      GoRoute(
        path: AppRoutes.customerHome,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tailorList,
        builder: (_, __) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/customer/tailor/:tailorId',
        builder: (_, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/customer/place-order/:tailorId',
        builder: (_, state) {
          return const OrderScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        builder: (_, __) => const TrackScreen(),
      ),
      GoRoute(
        path: '/customer/chat/:chatId',
        builder: (_, state) {
          return const ChatScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.measurementProfiles,
        builder: (_, __) => const MeasurementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),
      // Tailor routes
      GoRoute(
        path: AppRoutes.tailorHome,
        builder: (_, __) => const TailorHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tailorOrders,
        builder: (_, __) => const TailorOrdersScreen(),
      ),
      GoRoute(
        path: '/tailor/chat/:chatId',
        builder: (_, state) {
          final chatId = state.pathParameters['chatId']!;
          return TailorChatScreen(chatId: chatId);
        },
      ),
    ],
  );
});
