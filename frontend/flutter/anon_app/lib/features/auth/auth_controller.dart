import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthController {
  String? token;
  String? username;

  // Use localhost for web, LAN IP for device/emulator
  final String baseUrl = kIsWeb
      ? "http://localhost:8080"
      : "http://192.168.100.52:8080"; // <-- set to your LAN IP

  bool get isLoggedIn => token != null;

  Future<bool> register(String user, String pass) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": user, "password": pass}),
    );
    return res.statusCode == 200;
  }

  Future<bool> login(String user, String pass) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": user, "password": pass}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      token = data["token"] as String?;
      username = data["username"] as String?;
      return true;
    }
    return false;
  }

  void logout() {
    token = null;
    username = null;
  }
}
