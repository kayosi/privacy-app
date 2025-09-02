import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  final AuthController authController;
  const LoginPage({super.key, required this.authController});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _busy = false;

  Future<void> _handleLogin() async {
    setState(() => _busy = true);
    final ok = await widget.authController.login(userCtrl.text, passCtrl.text);
    setState(() => _busy = false);
    if (ok) {
      context.go('/account');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _busy ? null : _handleLogin,
              child: Text(_busy ? "Logging in..." : "Login"),
            ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text("No account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
