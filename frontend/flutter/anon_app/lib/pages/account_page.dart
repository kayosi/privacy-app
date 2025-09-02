import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_controller.dart';

class AccountPage extends StatelessWidget {
  final AuthController authController;
  const AccountPage({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final loggedIn = authController.isLoggedIn;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: loggedIn
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Logged in as: ${authController.username}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      authController.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged out")),
                      );
                      context.go('/feed');
                    },
                    child: const Text("Logout"),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("You are not logged in."),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text("Create account"),
                  ),
                ],
              ),
      ),
    );
  }
}
