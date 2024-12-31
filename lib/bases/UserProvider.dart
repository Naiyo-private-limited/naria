import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nari/bases/api/login.dart'; // Import the User model from your API

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  /// Save user data and token to local storage
  Future<void> saveUser(User user, String token) async {
    _user = user;
    _token = token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = jsonEncode(user.toJson());
    await prefs.setString('user', userData);
    await prefs.setString('token', token);

    notifyListeners();
  }

  /// Load user data and token from local storage
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    String? token = prefs.getString('token');

    if (userData != null && token != null) {
      _user = User.fromJson(jsonDecode(userData));
      _token = token;
      notifyListeners();
    }
  }

  // Load user data from local storage
  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  /// Check if user data exists in local storage
  Future<bool> hasUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user') && prefs.containsKey('token');
  }

  /// Clear user data from local storage
  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
    _user = null;
    _token = null;

    notifyListeners();
  }

  /// Get user ID from current user
  int? getUserId() {
    return _user?.id;
  }
}
