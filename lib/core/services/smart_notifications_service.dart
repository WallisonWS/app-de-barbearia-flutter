import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço de Notificações Inteligentes
/// 
/// Diferencial competitivo: Envia notificações apenas em horários adequados
/// - Nunca à noite (22h-8h)
/// - Lembretes 24h antes do agendamento
/// - Confirmação automática 2h antes
/// - Promoções apenas em horário comercial
class SmartNotificationsService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Horários permitidos para notificações
  static const int _minHour = 8; // 8h da manhã
  static const int _maxHour = 22; // 22h da noite
  
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
  }
  
  /// Agenda lembrete de agendamento (24h antes)
  /// Ajusta para horário adequado se necessário
  Future<void> scheduleBookingReminder({
    required int id,
    required String barbershopName,
    required String serviceName,
    required DateTime bookingTime,
  }) async {
    // Calcular 24h antes
    DateTime reminderTime = bookingTime.subtract(const Duration(hours: 24));
    
    // Ajustar para horário permitido
    reminderTime = _adjustToAllowedTime(reminderTime);
    
    const androidDetails = AndroidNotificationDetails(
      'booking_reminders',
      'Lembretes de Agendamento',
      channelDescription: 'Lembretes dos seus agendamentos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id,
      '⏰ Lembrete: Agendamento Amanhã',
      'Você tem um agendamento em $barbershopName amanhã às ${_formatTime(bookingTime)} - $serviceName',
      _convertToTZDateTime(reminderTime),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  /// Agenda confirmação de agendamento (2h antes)
  Future<void> scheduleBookingConfirmation({
    required int id,
    required String barbershopName,
    required DateTime bookingTime,
  }) async {
    // Calcular 2h antes
    DateTime confirmationTime = bookingTime.subtract(const Duration(hours: 2));
    
    // Não ajustar horário - se agendamento é cedo, avisa mesmo que seja fora do horário
    
    const androidDetails = AndroidNotificationDetails(
      'booking_confirmations',
      'Confirmações de Agendamento',
      channelDescription: 'Confirmações dos seus agendamentos',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id + 10000, // ID diferente para não conflitar
      '✂️ Seu agendamento é daqui a 2 horas!',
      '$barbershopName te espera às ${_formatTime(bookingTime)}. Não se atrase!',
      _convertToTZDateTime(confirmationTime),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  /// Envia notificação de promoção (apenas em horário comercial)
  Future<void> sendPromotionNotification({
    required int id,
    required String title,
    required String message,
    DateTime? scheduledTime,
  }) async {
    DateTime notificationTime = scheduledTime ?? DateTime.now();
    
    // SEMPRE ajustar para horário permitido
    notificationTime = _adjustToAllowedTime(notificationTime);
    
    const androidDetails = AndroidNotificationDetails(
      'promotions',
      'Promoções',
      channelDescription: 'Promoções e ofertas especiais',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    if (scheduledTime != null) {
      await _notifications.zonedSchedule(
        id,
        title,
        message,
        _convertToTZDateTime(notificationTime),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      // Se é para enviar agora, verificar se está em horário permitido
      if (_isAllowedTime(DateTime.now())) {
        await _notifications.show(id, title, message, details);
      } else {
        // Agendar para próximo horário permitido
        await _notifications.zonedSchedule(
          id,
          title,
          message,
          _convertToTZDateTime(notificationTime),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }
  
  /// Envia notificação instantânea (para eventos importantes)
  Future<void> sendInstantNotification({
    required int id,
    required String title,
    required String message,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant',
      'Notificações Instantâneas',
      channelDescription: 'Notificações importantes e urgentes',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, message, details);
  }
  
  /// Cancela notificação específica
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  // ========== MÉTODOS AUXILIARES ==========
  
  /// Verifica se o horário está dentro do permitido
  bool _isAllowedTime(DateTime time) {
    return time.hour >= _minHour && time.hour < _maxHour;
  }
  
  /// Ajusta horário para o próximo horário permitido
  DateTime _adjustToAllowedTime(DateTime time) {
    if (_isAllowedTime(time)) {
      return time;
    }
    
    // Se for muito cedo (antes das 8h), agendar para 8h do mesmo dia
    if (time.hour < _minHour) {
      return DateTime(time.year, time.month, time.day, _minHour, 0);
    }
    
    // Se for muito tarde (depois das 22h), agendar para 8h do próximo dia
    return DateTime(time.year, time.month, time.day + 1, _minHour, 0);
  }
  
  /// Formata horário para exibição
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  /// Converte DateTime para TZDateTime (necessário para agendamento)
  /// Nota: Em produção, usar timezone package
  dynamic _convertToTZDateTime(DateTime dateTime) {
    // Por enquanto, retorna o DateTime direto
    // Em produção, converter para TZDateTime usando timezone package
    return dateTime;
  }
}
