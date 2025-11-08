import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../enums/user_role.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Chaves para SharedPreferences
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserPhoto = 'user_photo';

  Future<User?> signInWithGoogle() async {
    try {
      // Tentar fazer login silencioso primeiro
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      // Se não conseguir, fazer login interativo
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        // Usuário cancelou o login
        return null;
      }

      // Obter detalhes da autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Criar usuário no sistema
      final user = User(
        id: googleUser.id,
        name: googleUser.displayName ?? 'Usuário Google',
        email: googleUser.email,
        phone: '', // Google não fornece telefone
        role: UserRole.client, // Por padrão, usuários do Google são clientes
        photoUrl: googleUser.photoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Salvar sessão
      await _saveSession(user);

      return user;
    } catch (error) {
      print('Erro ao fazer login com Google: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _clearSession();
    } catch (error) {
      print('Erro ao fazer logout: $error');
    }
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn) {
      return null;
    }

    final id = prefs.getString(_keyUserId);
    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final roleStr = prefs.getString(_keyUserRole);
    final photoUrl = prefs.getString(_keyUserPhoto);

    if (id == null || name == null || email == null || roleStr == null) {
      return null;
    }

    return User(
      id: id,
      name: name,
      email: email,
      phone: '',
      role: _parseRole(roleStr),
      photoUrl: photoUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserRole, user.role.toString());
    if (user.photoUrl != null) {
      await prefs.setString(_keyUserPhoto, user.photoUrl!);
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  UserRole _parseRole(String roleStr) {
    switch (roleStr) {
      case 'UserRole.admin':
        return UserRole.admin;
      case 'UserRole.barbershop':
        return UserRole.barbershop;
      case 'UserRole.client':
        return UserRole.client;
      default:
        return UserRole.client;
    }
  }

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
