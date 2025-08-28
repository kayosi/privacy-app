import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_controller.dart';

class AccountPage extends StatelessWidget {
  final AuthController authController;
  const AccountPage({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final loggedIn = authController.token != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loggedIn
                ? const Text(
                    "✅ You are logged in",
                    style: TextStyle(fontSize: 18),
                  )
                : const Text(
                    "👤 You are browsing as Anonymous",
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            if (!loggedIn)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text("Create Account"),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () {
                  authController.token = null; // clear token
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Logged out")));
                  context.go('/feed');
                },
                child: const Text("Logout"),
              ),
          ],
        ),
      ),
    );
  }
}
