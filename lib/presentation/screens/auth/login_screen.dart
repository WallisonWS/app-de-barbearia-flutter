import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/mock_auth_service.dart';
import '../../providers/auth_provider.dart';
import '../barber/barber_dashboard_screen.dart';
import '../client/client_home_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = authProvider.currentUser!;
      
      // Navegar para a tela apropriada
      if (user.role.toString().contains('admin')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboardScreen(),
          ),
        );
      } else if (user.role.toString().contains('barber')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BarberDashboardScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ClientHomeScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? AppStrings.genericError),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo e título
                  const Icon(
                    Icons.content_cut,
                    size: 80,
                    color: AppColors.textWhite,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.role == 'barber'
                        ? AppStrings.barberDescription
                        : AppStrings.clientDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textWhite,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Card de login
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppStrings.login,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Campo de e-mail
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: AppStrings.email,
                                prefixIcon: const Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.fieldRequired;
                                }
                                if (!value.contains('@')) {
                                  return AppStrings.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Campo de senha
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: AppStrings.password,
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.fieldRequired;
                                }
                                if (value.length < 6) {
                                  return AppStrings.passwordTooShort;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Botão de login
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _handleLogin,
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.textWhite,
                                            ),
                                          ),
                                        )
                                      : Text(AppStrings.login),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Link para cadastro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.dontHaveAccount,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(
                                          role: widget.role,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(AppStrings.register),
                                ),
                              ],
                            ),

                            // Credenciais de demonstração
                            const Divider(height: 32),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: AppColors.info,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Credenciais de demonstração:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.info,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    MockAuthService.getDemoCredentials(
                                        widget.role),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
