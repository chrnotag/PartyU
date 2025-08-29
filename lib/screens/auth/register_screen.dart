import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/custom_button.dart';
import 'package:partyu/widgets/custom_text_field.dart';
import 'package:partyu/widgets/floating_elements.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showErrorSnackBar('Você deve aceitar os termos de uso');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    if (!mounted) return;

    if (result['success']) {
      _showSuccessSnackBar('Conta criada com sucesso!');
      context.read<AppProvider>().navigateToHome();
    } else {
      _showErrorSnackBar(result['error'] ?? 'Erro ao criar conta');
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                    const SizedBox(height: 24),

                    // Header
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Register Form
                    _buildRegisterForm(),

                    // Footer
                    const SizedBox(height: 24),
                    _buildFooter(),
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
        // Logo
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
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.userPlus,
                  color: Color(0xFF9333EA),
                  size: 32,
                ),
                SizedBox(width: 4),
                Icon(
                  LucideIcons.sparkles,
                  color: Color(0xFFEC4899),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        const Text(
          'Criar Conta',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Junte-se à comunidade PartyU',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
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
                  'Crie sua conta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preencha os dados abaixo para começar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Name Field
            CustomTextField(
              controller: _nameController,
              label: 'Nome completo',
              hintText: 'Seu nome',
              prefixIcon: LucideIcons.user,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, digite seu nome';
                }
                if (value!.length < 2) {
                  return 'Nome deve ter pelo menos 2 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

            // Password Field
            CustomTextField(
              controller: _passwordController,
              label: 'Senha',
              hintText: '••••••••',
              prefixIcon: LucideIcons.lock,
              obscureText: !_showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppTheme.gray400,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, digite sua senha';
                }
                if (value!.length < 6) {
                  return 'Senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Confirm Password Field
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirmar senha',
              hintText: '••••••••',
              prefixIcon: LucideIcons.lock,
              obscureText: !_showConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirmPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppTheme.gray400,
                ),
                onPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, confirme sua senha';
                }
                if (value != _passwordController.text) {
                  return 'Senhas não coincidem';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Terms Checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Eu aceito os ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray600,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Termos de Uso',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Register Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  onPressed: authProvider.isLoading ? null : _handleRegister,
                  gradient: AppTheme.buttonGradient,
                  isLoading: authProvider.isLoading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Criar Conta'),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.userPlus,
                        size: 20,
                        color: authProvider.isLoading ? AppTheme.gray400 : Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Já tem uma conta? ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AppProvider>().navigateToScreen(AppScreen.login);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Ao se cadastrar, você concorda com nossos Termos de Uso e Política de Privacidade',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );
  }
}