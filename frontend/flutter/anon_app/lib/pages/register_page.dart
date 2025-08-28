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
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String? msg;

  void handleRegister() async {
    final success = await widget.authController.register(
      userCtrl.text,
      passCtrl.text,
    );
    if (success) {
      setState(() => msg = "✅ Registered! Please login.");
      Future.delayed(const Duration(seconds: 2), () {
        context.go('/login');
      });
    } else {
      setState(() => msg = "❌ Registration failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleRegister,
                child: const Text("Register"),
              ),
              if (msg != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    msg!,
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
