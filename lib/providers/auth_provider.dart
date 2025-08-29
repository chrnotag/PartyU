import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:partyu/models/user_model.dart';
import 'package:partyu/services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId != null) {
        final user = await DatabaseService.instance.getUserById(userId);
        if (user != null) {
          _user = user;
        }
      }
    } catch (e) {
      debugPrint('Error checking auth state: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check for demo credentials
      if (email == "demo@partyu.com" && password == "demo123456") {
        final demoUser = await DatabaseService.instance.getUserByEmail(email);
        if (demoUser != null) {
          _user = demoUser;
          await _saveUserSession(demoUser.id);
          _isLoading = false;
          notifyListeners();
          return {'success': true, 'user': demoUser};
        }
      }

      // Check database for user
      final user = await DatabaseService.instance.getUserByEmail(email);
      if (user != null && user.password == password) {
        _user = user;
        await _saveUserSession(user.id);
        _isLoading = false;
        notifyListeners();
        return {'success': true, 'user': user};
      }

      // If credentials look valid, create demo user
      if (email.contains('@') && email.contains('.') && password.length >= 6) {
        final demoUser = User(
          id: const Uuid().v4(),
          email: email,
          name: email.split('@')[0],
          password: password,
          createdAt: DateTime.now(),
          isDemo: true,
        );

        await DatabaseService.instance.createUser(demoUser);
        _user = demoUser;
        await _saveUserSession(demoUser.id);
        _isLoading = false;
        notifyListeners();
        return {'success': true, 'user': demoUser};
      }

      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Credenciais inválidas'};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Erro no login: $e'};
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if user already exists
      final existingUser = await DatabaseService.instance.getUserByEmail(email);
      if (existingUser != null) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'error': 'Usuário já existe'};
      }

      // Create new user
      final newUser = User(
        id: const Uuid().v4(),
        email: email,
        name: name,
        password: password,
        createdAt: DateTime.now(),
      );

      final result = await DatabaseService.instance.createUser(newUser);
      if (result != null) {
        _user = newUser;
        await _saveUserSession(newUser.id);
        _isLoading = false;
        notifyListeners();
        return {'success': true, 'user': newUser};
      }

      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Erro ao criar conta'};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Erro no cadastro: $e'};
    }
  }

  Future<void> signOut() async {
    try {
      _user = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<void> _saveUserSession(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
    } catch (e) {
      debugPrint('Error saving user session: $e');
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final user = await DatabaseService.instance.getUserByEmail(email);
      if (user != null) {
        return {'success': true};
      }
      return {'success': false, 'error': 'Email não encontrado'};
    } catch (e) {
      return {'success': false, 'error': 'Erro ao redefinir senha: $e'};
    }
  }
}