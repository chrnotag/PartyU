import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/widgets/bottom_navigation.dart';

// Auth Screens
import 'package:partyu/screens/auth/login_screen.dart';
import 'package:partyu/screens/auth/register_screen.dart';
import 'package:partyu/screens/auth/forgot_password_screen.dart';

// Main Screens
import 'package:partyu/screens/home/home_screen.dart';
import 'package:partyu/screens/search/search_screen.dart';
import 'package:partyu/screens/search/search_results_screen.dart';
import 'package:partyu/screens/profile/user_profile_screen.dart';
import 'package:partyu/screens/profile/venue_profile_screen.dart';
import 'package:partyu/screens/settings/settings_screen.dart';

// Feature Screens
import 'package:partyu/screens/calendar/calendar_screen.dart';
import 'package:partyu/screens/booking/booking_screen.dart';
import 'package:partyu/screens/payment/checkout_screen.dart';
import 'package:partyu/screens/payment/multiple_checkout_screen.dart';
import 'package:partyu/screens/reviews/reviews_screen.dart';
import 'package:partyu/screens/chat/chat_screen.dart';
import 'package:partyu/screens/events/event_guide_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  DateTime? _lastBackTime;

  Future<bool> _onWillPop() async {
    final app = context.read<AppProvider>();
    final auth = context.read<AuthProvider>();

    // Se há algo na pilha (dialog, bottom sheet, etc.), deixa o sistema fechar isso primeiro
    if (Navigator.of(context, rootNavigator: true).canPop()) return true;

    // Regras de "voltar" por tela
    switch (app.currentScreen) {
      case AppScreen.searchResults:
        app.navigateToScreen(AppScreen.search);
        return false;

      case AppScreen.profile:
      case AppScreen.venueProfile:
      case AppScreen.calendar:
      case AppScreen.booking:
      case AppScreen.checkout:
      case AppScreen.multipleCheckout:
      case AppScreen.reviews:
      case AppScreen.chat:
      case AppScreen.eventGuide:
      case AppScreen.settings:
        app.navigateToHome();
        return false;

      default:
        break;
    }

    // Se não logado e não está no login, manda pro login em vez de fechar
    if (!auth.isLoggedIn && app.currentScreen != AppScreen.login) {
      app.navigateToScreen(AppScreen.login);
      return false;
    }

    // Duplo voltar para sair (Home/Login)
    final now = DateTime.now();
    final canExit =
        _lastBackTime != null &&
        now.difference(_lastBackTime!) < const Duration(seconds: 2);
    if (canExit) return true;

    _lastBackTime = now;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Toque VOLTAR novamente para sair')),
      );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer2<AuthProvider, AppProvider>(
        builder: (context, authProvider, appProvider, child) {
          if (authProvider.isLoading) return const _LoadingScreen();

          // Mantém teu redirecionamento pós-auth sem quebrar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleNavigation(authProvider, appProvider);
          });

          return Scaffold(
            body: _buildCurrentScreen(authProvider, appProvider),
            bottomNavigationBar:
                appProvider.showBottomNav && authProvider.isLoggedIn
                ? const BottomNavigation()
                : null,
          );
        },
      ),
    );
  }

  void _handleNavigation(AuthProvider authProvider, AppProvider appProvider) {
    final authScreens = [
      AppScreen.login,
      AppScreen.register,
      AppScreen.forgotPassword,
    ];
    final protectedScreens = [
      AppScreen.home,
      AppScreen.search,
      AppScreen.searchResults,
      AppScreen.profile,
      AppScreen.venueProfile,
      AppScreen.calendar,
      AppScreen.booking,
      AppScreen.checkout,
      AppScreen.multipleCheckout,
      AppScreen.reviews,
      AppScreen.chat,
      AppScreen.eventGuide,
      AppScreen.settings,
    ];

    if (authProvider.isLoggedIn &&
        authScreens.contains(appProvider.currentScreen)) {
      appProvider.navigateToHome();
    }
    if (!authProvider.isLoggedIn &&
        protectedScreens.contains(appProvider.currentScreen)) {
      appProvider.navigateToScreen(AppScreen.login);
    }
  }

  Widget _buildCurrentScreen(
    AuthProvider authProvider,
    AppProvider appProvider,
  ) {
    switch (appProvider.currentScreen) {
      case AppScreen.login:
        return const LoginScreen();
      case AppScreen.register:
        return const RegisterScreen();
      case AppScreen.forgotPassword:
        return const ForgotPasswordScreen();
      case AppScreen.home:
        return const HomeScreen();
      case AppScreen.search:
        return const SearchScreen();
      case AppScreen.searchResults:
        return const SearchResultsScreen();
      case AppScreen.profile:
        return const UserProfileScreen();
      case AppScreen.venueProfile:
        return const VenueProfileScreen();
      case AppScreen.calendar:
        return const CalendarScreen();
      case AppScreen.booking:
        return const BookingScreen();
      case AppScreen.checkout:
        return const CheckoutScreen();
      case AppScreen.multipleCheckout:
        return const MultipleCheckoutScreen();
      case AppScreen.reviews:
        return const ReviewsScreen();
      case AppScreen.chat:
        return const ChatScreen();
      case AppScreen.eventGuide:
        return const EventGuideScreen();
      case AppScreen.settings:
        return const SettingsScreen();
      default:
        return const _NotFoundScreen();
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Carregando...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9333EA),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tela não encontrada',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<AppProvider>().navigateToHome();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9333EA),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
