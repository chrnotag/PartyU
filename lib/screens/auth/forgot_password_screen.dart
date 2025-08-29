import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/custom_button.dart';
import 'package:partyu/widgets/custom_text_field.dart';
import 'package:partyu/widgets/floating_elements.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.resetPassword(_emailController.text.trim());

    if (!mounted) return;

    if (result['success']) {
      setState(() {
        _emailSent = true;
      });
      _showSuccessSnackBar('E-mail de recuperação enviado!');
    } else {
      _showErrorSnackBar(result['error'] ?? 'Erro ao enviar e-mail');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9333EA), // purple-600
              Color(0xFFEC4899), // pink-500
              Color(0xFFF97316), // orange-400
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Ccircle cx='7' cy='7' r='2'/%3E%3Ccircle cx='27' cy='7' r='2'/%3E%3Ccircle cx='47' cy='7' r='2'/%3E%3Ccircle cx='7' cy='27' r='2'/%3E%3Ccircle cx='27' cy='27' r='2'/%3E%3Ccircle cx='47' cy='27' r='2'/%3E%3Ccircle cx='7' cy='47' r='2'/%3E%3Ccircle cx='27' cy='47' r='2'/%3E%3Ccircle cx='47' cy='47' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E",
                      ),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
            ),

            // Floating Elements
            const FloatingElements(),

            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              context.read<AppProvider>().navigateToScreen(AppScreen.login);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Icon(
                              LucideIcons.arrowLeft,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Header
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Reset Form
                    _buildResetForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            _emailSent ? LucideIcons.mailCheck : LucideIcons.keyRound,
            color: const Color(0xFF9333EA),
            size: 32,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          _emailSent ? 'E-mail Enviado!' : 'Esqueceu a Senha?',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          _emailSent
              ? 'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha.'
              : 'Não se preocupe! Digite seu e-mail e enviaremos um link para redefinir sua senha.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResetForm() {
    if (_emailSent) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            // Success Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'E-mail enviado com sucesso!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enviamos as instruções para ${_emailController.text}',
                          style: TextStyle(
                            color: Colors.green.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resend Button
            CustomButton(
              onPressed: () {
                setState(() {
                  _emailSent = false;
                });
              },
              backgroundColor: AppTheme.gray100,
              foregroundColor: AppTheme.gray700,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.refreshCw, size: 20),
                  SizedBox(width: 8),
                  Text('Enviar Novamente'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Back to Login
            CustomButton(
              onPressed: () {
                context.read<AppProvider>().navigateToScreen(AppScreen.login);
              },
              gradient: AppTheme.buttonGradient,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.arrowLeft, size: 20),
                  SizedBox(width: 8),
                  Text('Voltar ao Login'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Header
            Column(
              children: [
                Text(
                  'Redefinir Senha',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Digite seu e-mail para receber as instruções',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Email Field
            CustomTextField(
              controller: _emailController,
              label: 'E-mail',
              hintText: 'seu@email.com',
              prefixIcon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, digite seu e-mail';
                }
                if (!value!.contains('@')) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Reset Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  onPressed: authProvider.isLoading ? null : _handleResetPassword,
                  gradient: AppTheme.buttonGradient,
                  isLoading: authProvider.isLoading,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Enviar Instruções'),
                      SizedBox(width: 8),
                      Icon(LucideIcons.send, size: 20),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Back to Login
            TextButton(
              onPressed: () {
                context.read<AppProvider>().navigateToScreen(AppScreen.login);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.arrowLeft,
                    color: AppTheme.primaryPurple,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Voltar ao Login',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}