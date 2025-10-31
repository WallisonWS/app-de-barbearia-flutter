class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  static const String forgotPassword = '/forgot-password';
  
  // Admin
  static const String adminDashboard = '/admin';
  static const String manageBarbers = '/admin/barbers';
  static const String barberDetails = '/admin/barbers/:id';
  static const String financialReports = '/admin/reports';
  static const String systemSettings = '/admin/settings';
  
  // Barber
  static const String barberDashboard = '/barber';
  static const String clientsList = '/barber/clients';
  static const String clientDetails = '/barber/clients/:id';
  static const String schedule = '/barber/schedule';
  static const String servicesManagement = '/barber/services';
  static const String addService = '/barber/services/add';
  static const String editService = '/barber/services/:id/edit';
  static const String promotions = '/barber/promotions';
  static const String createPromotion = '/barber/promotions/create';
  static const String barberProfile = '/barber/profile';
  static const String subscriptionDetails = '/barber/subscription';
  
  // Client
  static const String clientHome = '/client';
  static const String barberSearch = '/client/search';
  static const String barberProfile = '/client/barber/:id';
  static const String booking = '/client/booking/:barberId';
  static const String appointmentsHistory = '/client/appointments';
  static const String appointmentDetails = '/client/appointments/:id';
  static const String clientProfile = '/client/profile';
  
  // Shared
  static const String notifications = '/notifications';
  static const String chat = '/chat/:userId';
}
