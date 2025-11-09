import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

/// Tela de login com Firebase
class LoginScreenFirebase extends StatefulWidget {
  const LoginScreenFirebase({super.key});

  @override
  State<LoginScreenFirebase> createState() => _LoginScreenFirebaseState();
}

class _LoginScreenFirebaseState extends State<LoginScreenFirebase> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Login bem-sucedido, navegar baseado no role
      final user = authProvider.currentUser;
      if (user == null) return;

      if (user.isAdmin) {
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
      } else if (user.isBarbershop || user.isBarber) {
        Navigator.pushReplacementNamed(context, '/barber/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/client/home');
      }
    } else {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Erro ao fazer login'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.signInWithGoogle();

    if (!mounted) return;

    if (success) {
      // Login bem-sucedido
      final user = authProvider.currentUser;
      if (user == null) return;

      if (user.isAdmin) {
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
      } else if (user.isBarbershop || user.isBarber) {
        Navigator.pushReplacementNamed(context, '/barber/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/client/home');
      }
    } else {
      // Mostrar erro
      if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/auth/register');
  }

  void _navigateToForgotPassword() {
    Navigator.pushNamed(context, '/auth/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Icon(
                  Icons.content_cut,
                  size: 80,
                  color: AppColors.primary,
                ),
                
                const SizedBox(height: 16),
                
                // Título
                Text(
                  'Bem-vindo!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Faça login para continuar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Email
                CustomTextField(
                  label: 'Email',
                  hint: 'seu@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
                
                const SizedBox(height: 16),
                
                // Senha
                PasswordTextField(
                  label: 'Senha',
                  hint: 'Sua senha',
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                
                const SizedBox(height: 8),
                
                // Esqueceu a senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botão de login
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return LoadingButton(
                      text: 'Entrar',
                      onPressed: _handleLogin,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.textHint)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.textHint)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Botão Google
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return LoadingOutlineButton(
                      text: 'Continuar com Google',
                      onPressed: _handleGoogleLogin,
                      isLoading: authProvider.isLoading,
                      icon: Icons.g_mobiledata,
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Link para registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não tem uma conta? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToRegister,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
