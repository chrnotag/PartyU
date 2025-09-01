import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/custom_button.dart';
import 'package:partyu/widgets/custom_text_field.dart';
import 'package:partyu/widgets/floating_elements.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (result['success']) {
      _showSuccessSnackBar('Login realizado com sucesso!');
      context.read<AppProvider>().navigateToHome();
    } else {
      _showErrorSnackBar(result['error'] ?? 'Erro no login');
    }
  }

  Future<void> _handleDemoLogin() async {
    _emailController.text = 'demo@partyu.com';
    _passwordController.text = 'demo123456';

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.signIn('demo@partyu.com', 'demo123456');

    if (!mounted) return;

    if (result['success']) {
      _showSuccessSnackBar('Login demo realizado com sucesso!');
      context.read<AppProvider>().navigateToHome();
    } else {
      _showErrorSnackBar('Erro no login demo');
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
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Login Form
                    _buildLoginForm(),

                    // Footer
                    const SizedBox(height: 32),
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
                  LucideIcons.heart,
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Party',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'U',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFEF08A), // yellow-300
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Subtitle
        const Text(
          'Transforme seus sonhos em realidade',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Conectamos você aos melhores profissionais',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
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
                  'Bem-vindo de volta!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Entre na sua conta para continuar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Demo Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFEFF6FF), // blue-50
                    Color(0xFFFAF5FF), // purple-50
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDBEAFE)), // blue-100
              ),
              child: Column(
                children: [
                  const Text(
                    '🚀 Modo Demo Disponível',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D4ED8), // blue-700
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButton(
                        onPressed: authProvider.isLoading ? null : _handleDemoLogin,
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                        ),
                        isLoading: authProvider.isLoading,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎯 Entrar em Demo'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                const Expanded(
                  child: Divider(color: AppTheme.gray200),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'ou use suas credenciais',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray500,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(color: AppTheme.gray200),
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
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.read<AppProvider>().navigateToScreen(AppScreen.forgotPassword);
                },
                child: const Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  onPressed: authProvider.isLoading ? null : _handleLogin,
                  gradient: AppTheme.buttonGradient,
                  isLoading: authProvider.isLoading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Entrar'),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 20,
                        color: authProvider.isLoading ? AppTheme.gray400 : Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Divider
            Row(
              children: [
                const Expanded(
                  child: Divider(color: AppTheme.gray200),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ou continue com',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray500,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(color: AppTheme.gray200),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Social Login
            Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    'Google',
                    _buildGoogleIcon(),
                    () => _showErrorSnackBar('Login com Google em desenvolvimento!'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSocialButton(
                    'Apple',
                    const Icon(LucideIcons.apple, color: AppTheme.gray700),
                    () => _showErrorSnackBar('Login com Apple em desenvolvimento!'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Register Link
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Não tem uma conta? ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AppProvider>().navigateToScreen(AppScreen.register);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Cadastre-se grátis',
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

  Widget _buildSocialButton(String text, Widget icon, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: AppTheme.gray200, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );
  }
}

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Google Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.93, size.height * 0.51)
        ..cubicTo(size.width * 0.93, size.height * 0.47, size.width * 0.91, size.height * 0.43, size.width * 0.875, size.height * 0.43)
        ..lineTo(size.width * 0.5, size.height * 0.43)
        ..lineTo(size.width * 0.5, size.height * 0.61)
        ..lineTo(size.width * 0.79, size.height * 0.61)
        ..cubicTo(size.width * 0.77, size.height * 0.71, size.width * 0.69, size.height * 0.79, size.width * 0.58, size.height * 0.83)
        ..lineTo(size.width * 0.58, size.height * 0.99)
        ..lineTo(size.width * 0.74, size.height * 0.99)
        ..cubicTo(size.width * 0.86, size.height * 0.95, size.width * 0.93, size.height * 0.84, size.width * 0.93, size.height * 0.69)
        ..close(),
      paint,
    );

    // Google Green
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.96)
        ..cubicTo(size.width * 0.62, size.height * 0.96, size.width * 0.73, size.height * 0.92, size.width * 0.82, size.height * 0.85)
        ..lineTo(size.width * 0.74, size.height * 0.77)
        ..cubicTo(size.width * 0.69, size.height * 0.81, size.width * 0.6, size.height * 0.83, size.width * 0.5, size.height * 0.83)
        ..cubicTo(size.width * 0.31, size.height * 0.83, size.width * 0.15, size.height * 0.71, size.width * 0.09, size.height * 0.55)
        ..lineTo(size.width * 0.01, size.height * 0.62)
        ..cubicTo(size.width * 0.11, size.height * 0.84, size.width * 0.29, size.height * 0.96, size.width * 0.5, size.height * 0.96)
        ..close(),
      paint,
    );

    // Google Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.24, size.height * 0.59)
        ..cubicTo(size.width * 0.21, size.height * 0.55, size.width * 0.19, size.height * 0.51, size.width * 0.19, size.height * 0.5)
        ..cubicTo(size.width * 0.19, size.height * 0.49, size.width * 0.21, size.height * 0.45, size.width * 0.24, size.height * 0.41)
        ..lineTo(size.width * 0.01, size.height * 0.38)
        ..cubicTo(size.width * -0.00, size.height * 0.42, size.width * 0.00, size.height * 0.46, size.width * 0.00, size.height * 0.5)
        ..cubicTo(size.width * 0.00, size.height * 0.54, size.width * 0.01, size.height * 0.58, size.width * 0.01, size.height * 0.62)
        ..close(),
      paint,
    );

    // Google Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.22)
        ..cubicTo(size.width * 0.58, size.height * 0.22, size.width * 0.65, size.height * 0.25, size.width * 0.71, size.height * 0.29)
        ..lineTo(size.width * 0.78, size.height * 0.22)
        ..cubicTo(size.width * 0.69, size.height * 0.13, size.width * 0.6, size.height * 0.04, size.width * 0.5, size.height * 0.04)
        ..cubicTo(size.width * 0.29, size.height * 0.04, size.width * 0.11, size.height * 0.16, size.width * 0.01, size.height * 0.38)
        ..lineTo(size.width * 0.24, size.height * 0.41)
        ..cubicTo(size.width * 0.29, size.height * 0.29, size.width * 0.38, size.height * 0.22, size.width * 0.5, size.height * 0.22)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}