import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/services/auth_service.dart';
import 'package:todo_list/utils/constants.dart';

class AuthProvider {
  SharedPreferences preferences;
  AuthService authService = AuthService();

  AuthProvider({required this.preferences});

  Future<void> _setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    Constants.tokenKey = token;
    await preferences.setString('token', token);
    await preferences.setBool('isAuthenticated', true);
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (email.length < 6 || password.length < 6) {
      throw Exception('Email and password must be at least 6 characters');
    }

    final respone = await authService.login(email, password);
    await _setToken(json.decode(respone.body)['token']);
  }
}
