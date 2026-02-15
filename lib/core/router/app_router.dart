import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/features/auth/presentation/screens/role_select_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/tailor_list_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/tailor_profile_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/place_order_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/order_history_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/chat_screen.dart';
import 'package:tailor_app/features/customer/presentation/screens/measurement_profiles_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_home_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_orders_screen.dart';
import 'package:tailor_app/features/tailor/presentation/screens/tailor_chat_screen.dart';

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
  static const String tailorHome = '/tailor';
  static const String tailorOrders = '/tailor/orders';
  static const String tailorChat = '/tailor/chat/:chatId';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: AppRoutes.roleSelect,
    redirect: (context, state) {
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
        builder: (_, __) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tailorList,
        builder: (_, __) => const TailorListScreen(),
      ),
      GoRoute(
        path: '/customer/tailor/:tailorId',
        builder: (_, state) {
          final tailorId = state.pathParameters['tailorId']!;
          return TailorProfileScreen(tailorId: tailorId);
        },
      ),
      GoRoute(
        path: '/customer/place-order/:tailorId',
        builder: (_, state) {
          final tailorId = state.pathParameters['tailorId']!;
          return PlaceOrderScreen(tailorId: tailorId);
        },
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        builder: (_, __) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/customer/chat/:chatId',
        builder: (_, state) {
          final chatId = state.pathParameters['chatId']!;
          return ChatScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: AppRoutes.measurementProfiles,
        builder: (_, __) => const MeasurementProfilesScreen(),
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
