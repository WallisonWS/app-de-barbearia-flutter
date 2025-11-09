import 'package:flutter/material.dart';
import '../../presentation/screens/auth/login_screen_firebase.dart';
import '../../presentation/screens/auth/role_selection_screen.dart';
import '../../presentation/screens/barber/barber_dashboard_screen.dart';
import '../../presentation/screens/barber/barbershop_profile_screen.dart';
import '../../presentation/screens/barber/edit_barbershop_profile_screen.dart';
import '../../presentation/screens/barber/gallery_management_screen.dart';
import '../../presentation/screens/barber/services_management_screen.dart';
import '../../presentation/screens/barber/promotions_management_screen.dart';
import '../../presentation/screens/barber/schedule_screen_firebase.dart';
import '../../presentation/screens/barber/reviews_screen.dart';
import '../../presentation/screens/client/client_home_screen.dart';

/// Rotas do aplicativo
class AppRoutes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String roleSelection = '/role-selection';

  // Admin
  static const String adminDashboard = '/admin/dashboard';

  // Barber/Barbershop
  static const String barberDashboard = '/barber/dashboard';
  static const String barbershopProfile = '/barber/profile';
  static const String editBarbershopProfile = '/barber/profile/edit';
  static const String galleryManagement = '/barber/gallery';
  static const String servicesManagement = '/barber/services';
  static const String promotionsManagement = '/barber/promotions';
  static const String schedule = '/barber/schedule';
  static const String reviews = '/barber/reviews';

  // Client
  static const String clientHome = '/client/home';
  static const String clientAppointments = '/client/appointments';
  static const String clientProfile = '/client/profile';

  /// Gerar rotas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreenFirebase());

      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());

      // Barber/Barbershop
      case barberDashboard:
        return MaterialPageRoute(builder: (_) => const BarberDashboardScreen());

      case barbershopProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BarbershopProfileScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      case editBarbershopProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditBarbershopProfileScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      case galleryManagement:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => GalleryManagementScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      case servicesManagement:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ServicesManagementScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      case promotionsManagement:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PromotionsManagementScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      case schedule:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ScheduleScreenFirebase(
            barberId: args?['barberId'] as String? ?? '',
          ),
        );

      case reviews:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReviewsScreen(
            barbershopId: args?['barbershopId'] as String? ?? '',
          ),
        );

      // Client
      case clientHome:
        return MaterialPageRoute(builder: (_) => const ClientHomeScreen());

      // Default
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Navegar para rota baseada no role do usuário
  static String getInitialRouteForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return adminDashboard;
      case 'barbershop':
      case 'barber':
        return barberDashboard;
      case 'client':
        return clientHome;
      default:
        return roleSelection;
    }
  }
}
