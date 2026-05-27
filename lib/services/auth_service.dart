import 'package:flutter/material.dart';

class AuthService {
  static Future<bool> isLoggedIn() async {
    return true;
  }

  static Future<void> logout() async {
    print("Logged out");
  }
}
