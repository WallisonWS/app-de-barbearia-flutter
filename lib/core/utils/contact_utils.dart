import 'package:url_launcher/url_launcher.dart';

/// Utilitários para contato com clientes via WhatsApp e telefone
class ContactUtils {
  /// Abre o WhatsApp com o número fornecido
  /// 
  /// [phoneNumber] deve estar no formato: +5511999999999
  /// [message] é a mensagem pré-preenchida (opcional)
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    // Remove caracteres especiais e espaços
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Garante que tem o código do país (+55 para Brasil)
    final formattedNumber = cleanNumber.startsWith('+') 
        ? cleanNumber 
        : '+55$cleanNumber';
    
    // Codifica a mensagem para URL
    final encodedMessage = message != null 
        ? Uri.encodeComponent(message)
        : '';
    
    // Monta a URL do WhatsApp
    final whatsappUrl = message != null
        ? 'https://wa.me/$formattedNumber?text=$encodedMessage'
        : 'https://wa.me/$formattedNumber';
    
    final uri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao abrir WhatsApp: $e');
      return false;
    }
  }
  
  /// Faz uma ligação telefônica
  /// 
  /// [phoneNumber] pode estar em qualquer formato
  static Future<bool> makePhoneCall(String phoneNumber) async {
    // Remove caracteres especiais exceto +
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    final uri = Uri.parse('tel:$cleanNumber');
    
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao fazer ligação: $e');
      return false;
    }
  }
  
  /// Envia um SMS
  /// 
  /// [phoneNumber] número do destinatário
  /// [message] mensagem a ser enviada
  static Future<bool> sendSMS({
    required String phoneNumber,
    String? message,
  }) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    final smsUrl = message != null
        ? 'sms:$cleanNumber?body=${Uri.encodeComponent(message)}'
        : 'sms:$cleanNumber';
    
    final uri = Uri.parse(smsUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao enviar SMS: $e');
      return false;
    }
  }
  
  /// Abre o aplicativo de email
  /// 
  /// [email] endereço de email do destinatário
  /// [subject] assunto do email (opcional)
  /// [body] corpo do email (opcional)
  static Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final subjectEncoded = subject != null ? Uri.encodeComponent(subject) : '';
    final bodyEncoded = body != null ? Uri.encodeComponent(body) : '';
    
    final emailUrl = 'mailto:$email?subject=$subjectEncoded&body=$bodyEncoded';
    final uri = Uri.parse(emailUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao abrir email: $e');
      return false;
    }
  }
  
  /// Formata o número de telefone para exibição
  /// 
  /// Exemplo: 11999999999 -> (11) 99999-9999
  static String formatPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.length == 11) {
      // Celular: (11) 99999-9999
      return '(${cleanNumber.substring(0, 2)}) ${cleanNumber.substring(2, 7)}-${cleanNumber.substring(7)}';
    } else if (cleanNumber.length == 10) {
      // Fixo: (11) 9999-9999
      return '(${cleanNumber.substring(0, 2)}) ${cleanNumber.substring(2, 6)}-${cleanNumber.substring(6)}';
    } else {
      return phoneNumber;
    }
  }
  
  /// Valida se o número de telefone é válido (Brasil)
  static bool isValidPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Celular: 11 dígitos (DDD + 9 + 8 dígitos)
    // Fixo: 10 dígitos (DDD + 8 dígitos)
    return cleanNumber.length == 10 || cleanNumber.length == 11;
  }
}
