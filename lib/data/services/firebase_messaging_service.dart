import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço de notificações push com Firebase Cloud Messaging
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // ==================== INICIALIZAÇÃO ====================

  /// Inicializar serviço de notificações
  Future<void> initialize() async {
    try {
      // Solicitar permissão
      await _requestPermission();

      // Configurar notificações locais
      await _setupLocalNotifications();

      // Configurar handlers
      _setupMessageHandlers();

      // Obter token
      final token = await getToken();
      print('📱 FCM Token: $token');
    } catch (e) {
      print('❌ Erro ao inicializar notificações: $e');
    }
  }

  /// Solicitar permissão para notificações
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Permissão de notificações concedida');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️  Permissão de notificações provisória');
    } else {
      print('❌ Permissão de notificações negada');
    }
  }

  /// Configurar notificações locais
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Criar canal de notificação para Android
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notificações Importantes',
      description: 'Canal para notificações importantes do app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Configurar handlers de mensagens
  void _setupMessageHandlers() {
    // Mensagem recebida quando app está em foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Mensagem clicada quando app está em background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);

    // Verificar se app foi aberto por uma notificação
    _checkInitialMessage();
  }

  // ==================== HANDLERS ====================

  /// Handler para mensagem em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Mensagem recebida em foreground: ${message.messageId}');

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      // Mostrar notificação local
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notificações Importantes',
            channelDescription: 'Canal para notificações importantes do app',
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Handler para tap em notificação em background
  void _handleBackgroundMessageTap(RemoteMessage message) {
    print('🔔 Notificação clicada (background): ${message.messageId}');
    _handleNotificationData(message.data);
  }

  /// Handler para tap em notificação local
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notificação local clicada: ${response.payload}');
    // TODO: Implementar navegação baseada no payload
  }

  /// Verificar mensagem inicial (app aberto por notificação)
  Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      print('🚀 App aberto por notificação: ${message.messageId}');
      _handleNotificationData(message.data);
    }
  }

  /// Processar dados da notificação
  void _handleNotificationData(Map<String, dynamic> data) {
    print('📦 Dados da notificação: $data');

    final type = data['type'] as String?;
    final id = data['id'] as String?;

    switch (type) {
      case 'appointment_confirmed':
        print('✅ Agendamento confirmado: $id');
        // TODO: Navegar para tela de agendamento
        break;

      case 'appointment_cancelled':
        print('❌ Agendamento cancelado: $id');
        // TODO: Navegar para tela de agendamentos
        break;

      case 'appointment_reminder':
        print('⏰ Lembrete de agendamento: $id');
        // TODO: Navegar para tela de agendamento
        break;

      case 'promotion':
        print('🎁 Nova promoção: $id');
        // TODO: Navegar para tela de promoções
        break;

      default:
        print('❓ Tipo de notificação desconhecido: $type');
    }
  }

  // ==================== TOKEN ====================

  /// Obter token FCM
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      print('❌ Erro ao obter token: $e');
      return null;
    }
  }

  /// Atualizar token no servidor
  Future<void> updateToken(String userId) async {
    try {
      final token = await getToken();
      if (token != null) {
        // TODO: Salvar token no Firestore
        print('💾 Token salvo para usuário: $userId');
      }
    } catch (e) {
      print('❌ Erro ao atualizar token: $e');
    }
  }

  /// Deletar token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('🗑️  Token deletado');
    } catch (e) {
      print('❌ Erro ao deletar token: $e');
    }
  }

  // ==================== TÓPICOS ====================

  /// Inscrever em tópico
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Inscrito no tópico: $topic');
    } catch (e) {
      print('❌ Erro ao inscrever em tópico: $e');
    }
  }

  /// Desinscrever de tópico
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('❌ Desinscrito do tópico: $topic');
    } catch (e) {
      print('❌ Erro ao desinscrever de tópico: $e');
    }
  }

  // ==================== NOTIFICAÇÕES LOCAIS ====================

  /// Agendar notificação local
  Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notificações Importantes',
            channelDescription: 'Canal para notificações importantes do app',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: data?.toString(),
      );

      print('⏰ Notificação agendada para: $scheduledDate');
    } catch (e) {
      print('❌ Erro ao agendar notificação: $e');
    }
  }

  /// Cancelar notificação local
  Future<void> cancelLocalNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      print('❌ Notificação cancelada: $id');
    } catch (e) {
      print('❌ Erro ao cancelar notificação: $e');
    }
  }

  /// Cancelar todas as notificações locais
  Future<void> cancelAllLocalNotifications() async {
    try {
      await _localNotifications.cancelAll();
      print('❌ Todas as notificações canceladas');
    } catch (e) {
      print('❌ Erro ao cancelar notificações: $e');
    }
  }

  // ==================== HELPERS ====================

  /// Verificar se notificações estão habilitadas
  Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Abrir configurações de notificações
  Future<void> openNotificationSettings() async {
    // TODO: Implementar abertura de configurações do sistema
    print('⚙️  Abrir configurações de notificações');
  }
}

// ==================== HANDLER GLOBAL ====================

/// Handler para mensagens em background (função top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 Mensagem recebida em background: ${message.messageId}');
  // Processar mensagem em background
}
