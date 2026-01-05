import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/auth.dart';
import '../databaseSqFlite/database_helper.dart';

/// ViewModel for Authentication
/// Manages login, registration, and auth state
class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Auth? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isInitialized = false;

  // Getters
  Auth? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  // SharedPreferences keys
  static const String _keyRememberMe = 'remember_me';
  static const String _keyUserId = 'user_id';

  /// Register a new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? specialty,
    String? classe,
    String? subClasse,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Check if email already exists
      final existingUser = await _databaseHelper.getAuthByEmail(email);
      if (existingUser != null) {
        _setError('Email déjà utilisé');
        return false;
      }

      // Validate email format
      if (!_isValidEmail(email)) {
        _setError('Email invalide (@esprit.tn requis)');
        return false;
      }

      // Create new auth user
      final auth = Auth(
        username: username,
        email: email,
        classe: classe,
        subClasse: subClasse,
        password: password,
        specialty: specialty,
        createdAt: DateTime.now(),
      );

      final id = await _databaseHelper.insertAuth(auth);
      _currentUser = auth.copyWith(id: id);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erreur lors de l\'inscription: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate inputs
      if (email.trim().isEmpty) {
        _setError('Veuillez saisir votre email');
        return false;
      }

      if (password.trim().isEmpty) {
        _setError('Veuillez saisir votre mot de passe');
        return false;
      }

      // Attempt login
      final auth = await _databaseHelper.login(email, password);

      if (auth == null) {
        _setError('Email ou mot de passe incorrect');
        return false;
      }

      // Always update remember me in database
      final updatedAuth = auth.copyWith(rememberMe: rememberMe);
      await _databaseHelper.updateAuth(updatedAuth);
      _currentUser = updatedAuth;

      _isLoggedIn = true;

      // Save remember me state to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        if (rememberMe && updatedAuth.id != null) {
          await prefs.setBool(_keyRememberMe, true);
          await prefs.setInt(_keyUserId, updatedAuth.id!);
          debugPrint('Remember me saved: userId=${updatedAuth.id}');
        } else {
          await prefs.setBool(_keyRememberMe, false);
          await prefs.remove(_keyUserId);
          debugPrint('Remember me cleared');
        }
      } catch (e) {
        // SharedPreferences error - continue without saving remember me
        debugPrint('SharedPreferences error: $e');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erreur lors de la connexion: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    // Clear remember me state
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyRememberMe, false);
      await prefs.remove(_keyUserId);
    } catch (e) {
      // SharedPreferences error - continue with logout
      debugPrint('SharedPreferences error during logout: $e');
    }

    _currentUser = null;
    _isLoggedIn = false;
    _clearError();
    notifyListeners();
  }

  /// Validate email format (should contain @esprit.tn)
  bool _isValidEmail(String email) {
    return email.contains('@') && email.toLowerCase().endsWith('@esprit.tn');
  }

  /// Check if user is remembered and auto-login
  Future<void> checkRememberedUser() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
      final userId = prefs.getInt(_keyUserId);

      debugPrint('Checking remembered user: rememberMe=$rememberMe, userId=$userId');

      if (rememberMe && userId != null) {
        // Try to get user from database
        final auth = await _databaseHelper.getAuthById(userId);

        if (auth != null) {
          debugPrint('User found in database: ${auth.email}, rememberMe=${auth.rememberMe}');
          // Auto-login regardless of database rememberMe field (trust SharedPreferences)
          _currentUser = auth;
          _isLoggedIn = true;
          debugPrint('Auto-login successful!');
          notifyListeners();
        } else {
          debugPrint('User not found in database, clearing preferences');
          // User not found, clear preferences
          try {
            await prefs.setBool(_keyRememberMe, false);
            await prefs.remove(_keyUserId);
          } catch (e) {
            debugPrint('Error clearing SharedPreferences: $e');
          }
        }
      } else {
        debugPrint('Remember me is false or no userId, skipping auto-login');
      }
    } catch (e) {
      debugPrint('Error checking remembered user: $e');
      // Continue without auto-login if SharedPreferences fails
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

