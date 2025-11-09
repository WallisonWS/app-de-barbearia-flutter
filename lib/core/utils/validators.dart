/// Validadores para formulários
/// Garante consistência e qualidade dos dados
class Validators {
  /// Valida email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }

  /// Valida senha
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < minLength) {
      return 'Senha deve ter no mínimo $minLength caracteres';
    }
    
    return null;
  }

  /// Valida confirmação de senha
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (value != password) {
      return 'Senhas não conferem';
    }
    
    return null;
  }

  /// Valida nome
  static String? name(String? value, {int minLength = 3}) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.trim().length < minLength) {
      return 'Nome deve ter no mínimo $minLength caracteres';
    }
    
    return null;
  }

  /// Valida telefone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }

  /// Valida CEP
  static String? cep(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    final cleanCep = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanCep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    
    return null;
  }

  /// Valida CPF
  static String? cpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    final cleanCpf = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanCpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    // Validação básica de CPF
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanCpf)) {
      return 'CPF inválido';
    }
    
    return null;
  }

  /// Valida CNPJ
  static String? cnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    
    final cleanCnpj = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanCnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    
    // Validação básica de CNPJ
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cleanCnpj)) {
      return 'CNPJ inválido';
    }
    
    return null;
  }

  /// Valida preço
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'[^\d,.]'), '');
    final price = double.tryParse(cleanValue.replaceAll(',', '.'));
    
    if (price == null || price <= 0) {
      return 'Preço inválido';
    }
    
    return null;
  }

  /// Valida número inteiro positivo
  static String? positiveInt(String? value, {String fieldName = 'Valor'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    final number = int.tryParse(value);
    
    if (number == null || number <= 0) {
      return '$fieldName deve ser um número positivo';
    }
    
    return null;
  }

  /// Valida duração em minutos
  static String? duration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duração é obrigatória';
    }
    
    final minutes = int.tryParse(value);
    
    if (minutes == null || minutes <= 0) {
      return 'Duração inválida';
    }
    
    if (minutes > 480) {
      return 'Duração máxima é 480 minutos (8 horas)';
    }
    
    return null;
  }

  /// Valida descrição
  static String? description(String? value, {int minLength = 10, int maxLength = 500}) {
    if (value == null || value.isEmpty) {
      return 'Descrição é obrigatória';
    }
    
    if (value.trim().length < minLength) {
      return 'Descrição deve ter no mínimo $minLength caracteres';
    }
    
    if (value.length > maxLength) {
      return 'Descrição deve ter no máximo $maxLength caracteres';
    }
    
    return null;
  }

  /// Valida endereço
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Endereço é obrigatório';
    }
    
    if (value.trim().length < 10) {
      return 'Endereço deve ter no mínimo 10 caracteres';
    }
    
    return null;
  }

  /// Valida horário (HH:mm)
  static String? time(String? value) {
    if (value == null || value.isEmpty) {
      return 'Horário é obrigatório';
    }
    
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    
    if (!timeRegex.hasMatch(value)) {
      return 'Horário inválido (use HH:mm)';
    }
    
    return null;
  }

  /// Valida data
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }
    
    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        return 'Data inválida (use DD/MM/AAAA)';
      }
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      
      if (date.year != year || date.month != month || date.day != day) {
        return 'Data inválida';
      }
      
      return null;
    } catch (e) {
      return 'Data inválida (use DD/MM/AAAA)';
    }
  }

  /// Valida desconto (0-100)
  static String? discount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Desconto é obrigatório';
    }
    
    final discount = int.tryParse(value);
    
    if (discount == null || discount < 0 || discount > 100) {
      return 'Desconto deve estar entre 0 e 100';
    }
    
    return null;
  }

  /// Valida campo obrigatório genérico
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL é opcional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }
    
    return null;
  }

  /// Valida avaliação (1-5)
  static String? rating(double? value) {
    if (value == null) {
      return 'Avaliação é obrigatória';
    }
    
    if (value < 1.0 || value > 5.0) {
      return 'Avaliação deve estar entre 1 e 5';
    }
    
    return null;
  }
}
