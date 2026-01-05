import 'package:flutter/foundation.dart';
import '../entities/user.dart';
import '../databaseSqFlite/database_helper.dart';

/// ViewModel for User management
/// Manages state and business logic for users
class UserProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _selectedUser;

  // Getters
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get selectedUser => _selectedUser;

  /// Load all users from database
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();

    try {
      _users = await _databaseHelper.getAllUsers();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load users: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new user
  Future<bool> addUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      final id = await _databaseHelper.insertUser(user);
      final newUser = user.copyWith(id: id);
      _users.add(newUser);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing user
  Future<bool> updateUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      await _databaseHelper.updateUser(user);
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a user
  Future<bool> deleteUser(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _databaseHelper.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Select a user (for detail view)
  void selectUser(User? user) {
    _selectedUser = user;
    notifyListeners();
  }

  /// Search users by name
  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    return _users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

