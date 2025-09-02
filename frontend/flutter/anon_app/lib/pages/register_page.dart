import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  final AuthController authController;
  const RegisterPage({super.key, required this.authController});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _busy = false;

  Future<void> _handleRegister() async {
    setState(() => _busy = true);
    final ok = await widget.authController.register(
      userCtrl.text,
      passCtrl.text,
    );
    setState(() => _busy = false);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registered — please login")),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _busy ? null : _handleRegister,
              child: Text(_busy ? "Registering..." : "Register"),
            ),
          ],
        ),
      ),
    );
  }
}
