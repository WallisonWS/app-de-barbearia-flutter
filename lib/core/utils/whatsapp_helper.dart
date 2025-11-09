import 'package:url_launcher/url_launcher.dart';

/// Helper para integração com WhatsApp
/// Permite abrir conversas diretas com números de telefone
class WhatsAppHelper {
  /// Abre o WhatsApp com um número de telefone e mensagem opcional
  /// 
  /// [phone] deve estar no formato internacional sem símbolos (ex: 5511999999999)
  /// [message] é a mensagem pré-preenchida (opcional)
  static Future<bool> openWhatsApp({
    required String phone,
    String? message,
  }) async {
    try {
      // Remove caracteres não numéricos do telefone
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
      
      // Garante que o número tem o código do país
      final formattedPhone = cleanPhone.startsWith('55') 
          ? cleanPhone 
          : '55$cleanPhone';
      
      // Codifica a mensagem para URL
      final encodedMessage = message != null 
          ? Uri.encodeComponent(message) 
          : '';
      
      // Monta a URL do WhatsApp
      final url = 'whatsapp://send?phone=$formattedPhone${message != null ? '&text=$encodedMessage' : ''}';
      
      final uri = Uri.parse(url);
      
      // Verifica se pode abrir o WhatsApp
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Tenta abrir via web se o app não estiver instalado
        final webUrl = Uri.parse(
          'https://wa.me/$formattedPhone${message != null ? '?text=$encodedMessage' : ''}',
        );
        return await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      return false;
    }
  }
  
  /// Abre WhatsApp para contato com barbearia
  static Future<bool> contactBarbershop({
    required String phone,
    required String barbershopName,
  }) async {
    final message = 'Olá $barbershopName! Gostaria de mais informações sobre os serviços.';
    return await openWhatsApp(phone: phone, message: message);
  }
  
  /// Abre WhatsApp para contato com cliente
  static Future<bool> contactClient({
    required String phone,
    required String clientName,
    String? customMessage,
  }) async {
    final message = customMessage ?? 
        'Olá $clientName! Aqui é da barbearia. Como posso ajudar?';
    return await openWhatsApp(phone: phone, message: message);
  }
  
  /// Abre WhatsApp para confirmar agendamento
  static Future<bool> confirmAppointment({
    required String phone,
    required String clientName,
    required String service,
    required String date,
    required String time,
  }) async {
    final message = '''
Olá $clientName! 

Seu agendamento foi confirmado:
📅 Data: $date
🕐 Horário: $time
✂️ Serviço: $service

Aguardamos você!
''';
    return await openWhatsApp(phone: phone, message: message);
  }
  
  /// Abre WhatsApp para lembrar agendamento
  static Future<bool> remindAppointment({
    required String phone,
    required String clientName,
    required String service,
    required String time,
  }) async {
    final message = '''
Olá $clientName! 

Lembrete: Você tem um agendamento hoje às $time.
✂️ Serviço: $service

Até logo!
''';
    return await openWhatsApp(phone: phone, message: message);
  }
  
  /// Abre WhatsApp para compartilhar promoção
  static Future<bool> sharePromotion({
    required String phone,
    required String clientName,
    required String promotionTitle,
    required String promotionDescription,
    required int discount,
  }) async {
    final message = '''
Olá $clientName! 🎉

Temos uma promoção especial para você:

$promotionTitle
$discount% de desconto!

$promotionDescription

Agende já!
''';
    return await openWhatsApp(phone: phone, message: message);
  }
  
  /// Formata número de telefone para exibição
  /// Converte 5511999999999 para (11) 99999-9999
  static String formatPhoneForDisplay(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length == 13 && cleanPhone.startsWith('55')) {
      // Formato: 5511999999999
      final ddd = cleanPhone.substring(2, 4);
      final firstPart = cleanPhone.substring(4, 9);
      final secondPart = cleanPhone.substring(9);
      return '($ddd) $firstPart-$secondPart';
    } else if (cleanPhone.length == 11) {
      // Formato: 11999999999
      final ddd = cleanPhone.substring(0, 2);
      final firstPart = cleanPhone.substring(2, 7);
      final secondPart = cleanPhone.substring(7);
      return '($ddd) $firstPart-$secondPart';
    } else if (cleanPhone.length == 10) {
      // Formato: 1199999999 (número fixo)
      final ddd = cleanPhone.substring(0, 2);
      final firstPart = cleanPhone.substring(2, 6);
      final secondPart = cleanPhone.substring(6);
      return '($ddd) $firstPart-$secondPart';
    }
    
    return phone; // Retorna original se não conseguir formatar
  }
  
  /// Valida se o número de telefone é válido
  static bool isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Aceita formatos:
    // 11 dígitos: 11999999999
    // 10 dígitos: 1199999999
    // 13 dígitos: 5511999999999
    return cleanPhone.length == 10 || 
           cleanPhone.length == 11 || 
           cleanPhone.length == 13;
  }
}
