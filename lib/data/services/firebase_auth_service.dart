import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as app_models;

/// Serviço de autenticação com Firebase
/// Gerencia login, registro, logout e estado do usuário
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuário atual
  User? get currentUser => _auth.currentUser;

  /// Verificar se está autenticado
  bool get isAuthenticated => currentUser != null;

  // ==================== REGISTRO ====================

  /// Registrar com email e senha
  Future<app_models.User?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role, // 'admin', 'barbershop', 'barber', 'client'
  }) async {
    try {
      // Criar usuário no Firebase Auth
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Erro ao criar usuário');
      }

      // Atualizar display name
      await firebaseUser.updateDisplayName(name);

      // Criar documento do usuário no Firestore
      final app_models.User appUser = app_models.User(
        uid: firebaseUser.uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
        photoUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(appUser.toMap());

      // Enviar email de verificação
      await firebaseUser.sendEmailVerification();

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao registrar: $e');
    }
  }

  // ==================== LOGIN ====================

  /// Login com email e senha
  Future<app_models.User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Erro ao fazer login');
      }

      // Buscar dados do usuário no Firestore
      final app_models.User? appUser = await getUserData(firebaseUser.uid);
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Login com Google
  Future<app_models.User?> signInWithGoogle() async {
    try {
      // Iniciar fluxo de autenticação Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Usuário cancelou
      }

      // Obter credenciais de autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Criar credencial do Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao fazer login com Google');
      }

      // Verificar se é primeiro login
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        // Criar documento do usuário no Firestore
        final app_models.User appUser = app_models.User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'Usuário',
          phone: firebaseUser.phoneNumber ?? '',
          role: 'client', // Novo usuário é cliente por padrão
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(firebaseUser.uid).set(appUser.toMap());
        return appUser;
      } else {
        // Buscar dados do usuário existente
        return await getUserData(firebaseUser.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: $e');
    }
  }

  // ==================== LOGOUT ====================

  /// Fazer logout
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  // ==================== RECUPERAÇÃO DE SENHA ====================

  /// Enviar email de recuperação de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }

  /// Confirmar recuperação de senha
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao redefinir senha: $e');
    }
  }

  // ==================== ATUALIZAÇÃO DE PERFIL ====================

  /// Atualizar nome do usuário
  Future<void> updateDisplayName(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
      await _firestore.collection('users').doc(currentUser?.uid).update({
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar nome: $e');
    }
  }

  /// Atualizar foto do usuário
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await currentUser?.updatePhotoURL(photoUrl);
      await _firestore.collection('users').doc(currentUser?.uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar foto: $e');
    }
  }

  /// Atualizar email do usuário
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.updateEmail(newEmail);
      await _firestore.collection('users').doc(currentUser?.uid).update({
        'email': newEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar email: $e');
    }
  }

  /// Atualizar senha do usuário
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao atualizar senha: $e');
    }
  }

  // ==================== VERIFICAÇÃO ====================

  /// Enviar email de verificação
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      throw Exception('Erro ao enviar email de verificação: $e');
    }
  }

  /// Verificar se email está verificado
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Recarregar usuário atual
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      throw Exception('Erro ao recarregar usuário: $e');
    }
  }

  // ==================== DADOS DO USUÁRIO ====================

  /// Buscar dados do usuário no Firestore
  Future<app_models.User?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      return app_models.User.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário: $e');
    }
  }

  /// Stream dos dados do usuário
  Stream<app_models.User?> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return app_models.User.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Atualizar dados do usuário no Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar dados do usuário: $e');
    }
  }

  // ==================== EXCLUSÃO ====================

  /// Deletar conta do usuário
  Future<void> deleteAccount() async {
    try {
      final String? uid = currentUser?.uid;
      if (uid == null) {
        throw Exception('Usuário não autenticado');
      }

      // Deletar documento do Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Deletar conta do Firebase Auth
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao deletar conta: $e');
    }
  }

  /// Reautenticar usuário (necessário para operações sensíveis)
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      final User? user = currentUser;
      if (user == null || user.email == null) {
        throw Exception('Usuário não autenticado');
      }

      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao reautenticar: $e');
    }
  }

  // ==================== TRATAMENTO DE ERROS ====================

  /// Tratar exceções do Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este email já está em uso';
      case 'invalid-email':
        return 'Email inválido';
      case 'operation-not-allowed':
        return 'Operação não permitida';
      case 'weak-password':
        return 'Senha muito fraca. Use no mínimo 6 caracteres';
      case 'user-disabled':
        return 'Usuário desabilitado';
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde';
      case 'requires-recent-login':
        return 'Esta operação requer login recente. Faça login novamente';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este email usando outro método de login';
      case 'invalid-credential':
        return 'Credenciais inválidas';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet';
      default:
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}
