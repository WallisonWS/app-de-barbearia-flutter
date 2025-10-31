# Especificações Técnicas - App Barbearia

## Estrutura do Projeto Flutter

O projeto seguirá a arquitetura **Clean Architecture** combinada com **MVVM (Model-View-ViewModel)**, garantindo separação de responsabilidades, testabilidade e manutenibilidade do código.

### Organização de Pastas

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_formatter.dart
│   │   └── currency_formatter.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_indicator.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── barber_model.dart
│   │   ├── appointment_model.dart
│   │   └── ...
│   ├── repositories/
│   │   ├── auth_repository_impl.dart
│   │   ├── barber_repository_impl.dart
│   │   └── ...
│   └── datasources/
│       ├── firebase_auth_datasource.dart
│       ├── firestore_datasource.dart
│       └── mercadopago_datasource.dart
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── barber.dart
│   │   ├── appointment.dart
│   │   └── ...
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── barber_repository.dart
│   │   └── ...
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── register_usecase.dart
│       │   └── logout_usecase.dart
│       ├── appointments/
│       │   ├── create_appointment_usecase.dart
│       │   ├── get_appointments_usecase.dart
│       │   └── cancel_appointment_usecase.dart
│       └── ...
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── barber_provider.dart
│   │   └── ...
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── role_selection_screen.dart
│   │   ├── admin/
│   │   │   ├── admin_dashboard_screen.dart
│   │   │   ├── manage_barbers_screen.dart
│   │   │   └── financial_reports_screen.dart
│   │   ├── barber/
│   │   │   ├── barber_dashboard_screen.dart
│   │   │   ├── clients_list_screen.dart
│   │   │   ├── schedule_screen.dart
│   │   │   ├── services_management_screen.dart
│   │   │   └── promotions_screen.dart
│   │   ├── client/
│   │   │   ├── client_home_screen.dart
│   │   │   ├── barber_search_screen.dart
│   │   │   ├── booking_screen.dart
│   │   │   └── appointments_history_screen.dart
│   │   └── shared/
│   │       ├── profile_screen.dart
│   │       └── notifications_screen.dart
│   └── widgets/
│       ├── appointment_card.dart
│       ├── barber_card.dart
│       └── ...
└── main.dart
```

## Dependências Principais (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_messaging: ^14.7.10
  
  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Utils
  intl: ^0.19.0
  url_launcher: ^6.2.3
  image_picker: ^1.0.7
  permission_handler: ^11.2.0
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Payment
  mercadopago_sdk: ^1.0.0
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # Forms & Validation
  mask_text_input_formatter: ^2.7.0
  
  # Date & Time
  table_calendar: ^3.0.9
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
  build_runner: ^2.4.8
  hive_generator: ^2.0.1
```

## Configurações Firebase

### Android (android/app/google-services.json)
Arquivo de configuração baixado do Firebase Console após criar o projeto.

### iOS (ios/Runner/GoogleService-Info.plist)
Arquivo de configuração baixado do Firebase Console.

### Regras de Segurança Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isBarber() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'barber';
    }
    
    function isClient() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'client';
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Barbers collection
    match /barbers/{barberId} {
      allow read: if isAuthenticated();
      allow create: if isBarber() && isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Clients collection
    match /clients/{clientId} {
      allow read: if isAuthenticated() && 
                     (isOwner(resource.data.userId) || 
                      isOwner(resource.data.barberId) || 
                      isAdmin());
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.userId) || 
                       isOwner(resource.data.barberId) || 
                       isAdmin();
      allow delete: if isAdmin();
    }
    
    // Appointments collection
    match /appointments/{appointmentId} {
      allow read: if isAuthenticated() && 
                     (isOwner(resource.data.clientId) || 
                      isOwner(resource.data.barberId) || 
                      isAdmin());
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.clientId) || 
                       isOwner(resource.data.barberId) || 
                       isAdmin();
      allow delete: if isAdmin();
    }
    
    // Services collection
    match /services/{serviceId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(resource.data.barberId) || isAdmin();
    }
    
    // Promotions collection
    match /promotions/{promotionId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(resource.data.barberId) || isAdmin();
    }
    
    // Subscriptions collection
    match /subscriptions/{subscriptionId} {
      allow read: if isOwner(resource.data.barberId) || isAdmin();
      allow write: if isAdmin();
    }
    
    // Payments collection
    match /payments/{paymentId} {
      allow read: if isOwner(resource.data.barberId) || isAdmin();
      allow write: if isAdmin();
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isAdmin();
    }
    
    // Admin settings
    match /admin_settings/{document=**} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
  }
}
```

## Integração Mercado Pago

### Configuração

O Mercado Pago será integrado para processar pagamentos de assinatura dos barbeiros. Utilizaremos o modelo de **assinaturas recorrentes**.

### Fluxo de Pagamento

1. **Criação de Preferência de Pagamento**
```dart
Future<String> createSubscriptionPreference(String barberId, double amount) async {
  final response = await dio.post(
    'https://api.mercadopago.com/preapproval',
    options: Options(
      headers: {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        'Content-Type': 'application/json',
      },
    ),
    data: {
      'reason': 'Assinatura Mensal - App Barbearia',
      'auto_recurring': {
        'frequency': 1,
        'frequency_type': 'months',
        'transaction_amount': amount,
        'currency_id': 'BRL',
      },
      'back_url': 'https://yourapp.com/payment/success',
      'payer_email': 'barber@email.com',
      'external_reference': barberId,
    },
  );
  
  return response.data['init_point'];
}
```

2. **Webhook para Notificações**
```dart
// Cloud Function para receber webhooks do Mercado Pago
exports.mercadoPagoWebhook = functions.https.onRequest(async (req, res) => {
  const { type, data } = req.body;
  
  if (type === 'payment') {
    const paymentId = data.id;
    
    // Consultar detalhes do pagamento
    const paymentInfo = await getMercadoPagoPayment(paymentId);
    
    // Atualizar Firestore
    await admin.firestore().collection('payments').add({
      mercadoPagoId: paymentId,
      status: paymentInfo.status,
      amount: paymentInfo.transaction_amount,
      barberId: paymentInfo.external_reference,
      paidAt: new Date(),
      createdAt: new Date(),
    });
    
    // Atualizar assinatura do barbeiro
    if (paymentInfo.status === 'approved') {
      await updateBarberSubscription(paymentInfo.external_reference);
    }
  }
  
  res.status(200).send('OK');
});
```

## Integração WhatsApp

A integração com WhatsApp será feita através do **URL Scheme**, permitindo que o barbeiro abra uma conversa diretamente com o cliente.

```dart
Future<void> openWhatsApp(String phoneNumber, String message) async {
  final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  final encodedMessage = Uri.encodeComponent(message);
  final url = 'whatsapp://send?phone=+55$cleanPhone&text=$encodedMessage';
  
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Não foi possível abrir o WhatsApp';
  }
}
```

## Sistema de Notificações Push

### Configuração Firebase Cloud Messaging

```dart
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // Solicitar permissão
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Obter token FCM
    String? token = await _messaging.getToken();
    await saveTokenToFirestore(token);
    
    // Configurar handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }
  
  Future<void> sendNotificationToUser(String userId, String title, String body) async {
    // Implementar via Cloud Function
  }
}
```

### Cloud Function para Envio de Notificações

```javascript
exports.sendNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const userId = notification.userId;
    
    // Buscar token FCM do usuário
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    const fcmToken = userDoc.data().fcmToken;
    
    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: notification.title,
          body: notification.message,
        },
        data: notification.data,
      });
    }
  });
```

## Temas e Design System

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B4513), // Marrom barbearia
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B4513),
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}
```

## Navegação com GoRouter

```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'barbers',
          builder: (context, state) => const ManageBarbersScreen(),
        ),
        GoRoute(
          path: 'reports',
          builder: (context, state) => const FinancialReportsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/barber',
      builder: (context, state) => const BarberDashboardScreen(),
      routes: [
        GoRoute(
          path: 'clients',
          builder: (context, state) => const ClientsListScreen(),
        ),
        GoRoute(
          path: 'schedule',
          builder: (context, state) => const ScheduleScreen(),
        ),
        GoRoute(
          path: 'services',
          builder: (context, state) => const ServicesManagementScreen(),
        ),
        GoRoute(
          path: 'promotions',
          builder: (context, state) => const PromotionsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientHomeScreen(),
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) => const BarberSearchScreen(),
        ),
        GoRoute(
          path: 'booking/:barberId',
          builder: (context, state) => BookingScreen(
            barberId: state.pathParameters['barberId']!,
          ),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const AppointmentsHistoryScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // Implementar lógica de redirecionamento baseada em autenticação
  },
);
```

## Testes

### Estrutura de Testes

```
test/
├── unit/
│   ├── usecases/
│   ├── repositories/
│   └── models/
├── widget/
│   └── screens/
└── integration/
    └── flows/
```

### Exemplo de Teste Unitário

```dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });
    
    test('should return User when login is successful', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tUser));
      
      // Act
      final result = await useCase(LoginParams(
        email: 'test@test.com',
        password: 'password123',
      ));
      
      // Assert
      expect(result, Right(tUser));
      verify(mockRepository.login('test@test.com', 'password123'));
    });
  });
}
```

## Considerações de Performance

### Otimizações Implementadas

1. **Lazy Loading**: Carregar dados sob demanda
2. **Pagination**: Limitar queries do Firestore
3. **Cache**: Usar Hive para cache local
4. **Image Optimization**: Usar cached_network_image
5. **Debouncing**: Em campos de busca
6. **Índices Firestore**: Criar índices compostos para queries complexas

### Monitoramento

Utilizar **Firebase Performance Monitoring** para identificar gargalos e otimizar o app.

## Próximos Passos de Implementação

1. Configurar projeto Flutter e Firebase
2. Implementar camada de domínio (entities, repositories, usecases)
3. Implementar camada de dados (models, datasources, repositories)
4. Implementar camada de apresentação (providers, screens, widgets)
5. Integrar Mercado Pago
6. Implementar notificações push
7. Testes e refinamentos
8. Deploy nas lojas
