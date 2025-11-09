import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../data/models/user_model.dart';
import '../../data/services/firebase_auth_service.dart';

/// Provider de autenticação
/// Gerencia estado de autenticação e dados do usuário
/// HIERARQUIA: Admin → Barbearias → Barbeiros → Clientes
class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  // Verificações de hierarquia
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isBarbershop => _currentUser?.isBarbershop ?? false;
  bool get isBarber => _currentUser?.isBarber ?? false;
  bool get isClient => _currentUser?.isClient ?? false;

  /// Inicializar provider
  AuthProvider() {
    _initAuthListener();
  }

  /// Escutar mudanças no estado de autenticação
  void _initAuthListener() {
    _authService.authStateChanges.listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        // Usuário autenticado, buscar dados
        await _loadUserData(firebaseUser.uid);
      } else {
        // Usuário desautenticado
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  /// Carregar dados do usuário
  Future<void> _loadUserData(String uid) async {
    try {
      _currentUser = await _authService.getUserData(uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados do usuário';
      notifyListeners();
    }
  }

  /// Verificar status de autenticação
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final firebase_auth.User? firebaseUser = _authService.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _authService.getUserData(firebaseUser.uid);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== REGISTRO ====================

  /// Registrar com email e senha
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== LOGIN ====================

  /// Login com email e senha
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login com Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.signInWithGoogle();

      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== LOGOUT ====================

  /// Fazer logout
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
      _currentUser = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== RECUPERAÇÃO DE SENHA ====================

  /// Enviar email de recuperação de senha
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== ATUALIZAÇÃO DE PERFIL ====================

  /// Atualizar nome
  Future<bool> updateDisplayName(String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateDisplayName(name);
      await _loadUserData(_currentUser!.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Atualizar foto
  Future<bool> updatePhotoUrl(String photoUrl) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updatePhotoUrl(photoUrl);
      await _loadUserData(_currentUser!.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Atualizar dados do usuário
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateUserData(_currentUser!.uid, data);
      await _loadUserData(_currentUser!.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== VERIFICAÇÃO ====================

  /// Enviar email de verificação
  Future<bool> sendEmailVerification() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendEmailVerification();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Recarregar usuário
  Future<void> reloadUser() async {
    try {
      await _authService.reloadUser();
      if (_currentUser != null) {
        await _loadUserData(_currentUser!.uid);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // ==================== EXCLUSÃO ====================

  /// Deletar conta
  Future<bool> deleteAccount() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.deleteAccount();
      _currentUser = null;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== HELPERS ====================

  /// Limpar erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Definir usuário manualmente (para testes)
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
