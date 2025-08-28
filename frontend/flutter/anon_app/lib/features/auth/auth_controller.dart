import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  String? token;
  final String baseUrl = "http://192.168.100.52:8080"; // ⚡ your LAN IP

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return response.statusCode == 200;
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data["token"];
      return true;
    }
    return false;
  }
}
