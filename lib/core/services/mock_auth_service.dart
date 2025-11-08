import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

class MockAuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';

  // Usuários mock para demonstração
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'admin_001',
      'name': 'Administrador',
      'email': 'admin@barbearia.com',
      'password': 'admin123',
      'role': 'admin',
      'phone': '(11) 99999-9999',
    },
    {
      'id': 'barber_001',
      'name': 'João Silva',
      'email': 'joao@barbearia.com',
      'password': 'barber123',
      'role': 'barber',
      'phone': '(11) 98888-8888',
    },
    {
      'id': 'client_001',
      'name': 'Carlos Santos',
      'email': 'carlos@email.com',
      'password': 'client123',
      'role': 'client',
      'phone': '(11) 97777-7777',
    },
  ];

  Future<User?> login(String email, String password) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Buscar usuário mock
    final userMap = _mockUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (userMap.isEmpty) {
      throw Exception('E-mail ou senha incorretos');
    }

    // Salvar sessão
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userMap['id']);
    await prefs.setString(_keyUserName, userMap['name']);
    await prefs.setString(_keyUserEmail, userMap['email']);
    await prefs.setString(_keyUserRole, userMap['role']);

    return User(
      id: userMap['id'],
      name: userMap['name'],
      email: userMap['email'],
      phone: userMap['phone'],
      role: _parseRole(userMap['role']),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Verificar se e-mail já existe
    final exists = _mockUsers.any((user) => user['email'] == email);
    if (exists) {
      throw Exception('E-mail já está em uso');
    }

    // Criar novo usuário
    final newUser = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
    };

    _mockUsers.add(newUser);

    // Salvar sessão
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, newUser['id']!);
    await prefs.setString(_keyUserName, newUser['name']!);
    await prefs.setString(_keyUserEmail, newUser['email']!);
    await prefs.setString(_keyUserRole, newUser['role']!);

    return User(
      id: newUser['id']!,
      name: newUser['name']!,
      email: newUser['email']!,
      phone: newUser['phone']!,
      role: _parseRole(newUser['role']!),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final userId = prefs.getString(_keyUserId);
    final userName = prefs.getString(_keyUserName);
    final userEmail = prefs.getString(_keyUserEmail);
    final userRole = prefs.getString(_keyUserRole);

    if (userId == null || userName == null || userEmail == null || userRole == null) {
      return null;
    }

    // Buscar dados completos do usuário
    final userMap = _mockUsers.firstWhere(
      (user) => user['id'] == userId,
      orElse: () => {},
    );

    if (userMap.isEmpty) return null;

    return User(
      id: userId,
      name: userName,
      email: userEmail,
      phone: userMap['phone'] ?? '',
      role: _parseRole(userRole),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  UserRole _parseRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'barber':
        return UserRole.barber;
      case 'client':
        return UserRole.client;
      default:
        return UserRole.client;
    }
  }

  // Dados de demonstração para login rápido
  static String getDemoCredentials(String role) {
    switch (role) {
      case 'admin':
        return 'E-mail: admin@barbearia.com\nSenha: admin123';
      case 'barber':
        return 'E-mail: joao@barbearia.com\nSenha: barber123';
      case 'client':
        return 'E-mail: carlos@email.com\nSenha: client123';
      default:
        return '';
    }
  }
}
