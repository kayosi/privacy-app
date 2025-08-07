import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/feed');
              break;
            case 1:
              context.go('/create');
              break;
            case 2:
              context.go('/mod');
              break;
            case 3:
              context.go('/about');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Mod'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
