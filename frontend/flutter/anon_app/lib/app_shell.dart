import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_controller.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final AuthController auth;
  const AppShell({super.key, required this.child, required this.auth});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    final navItems = [
      {'label': 'Feed', 'path': '/feed'},
      {'label': 'Create', 'path': '/create'},
      {'label': 'About', 'path': '/about'},
      {
        'label': auth.token == null ? 'Login' : 'Account',
        'path': auth.token == null ? '/login' : '/account',
      },
    ];

    bool isMobile = MediaQuery.of(context).size.width < 600;

    int currentIndex = navItems.indexWhere(
      (item) => location.startsWith(item['path']!),
    );
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              title: const Text("Anon App"),
              actions: navItems.map((item) {
                return TextButton(
                  onPressed: () => context.go(item['path']!),
                  child: Text(
                    item['label']!,
                    style: TextStyle(
                      color: location.startsWith(item['path']!)
                          ? Colors.amber
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
      body: child,
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              backgroundColor: Colors.grey[900], // dark grey bar
              selectedItemColor: Colors.amber, // highlight for active tab
              unselectedItemColor: Colors.white70, // dimmed white for inactive
              currentIndex: currentIndex,
              onTap: (index) => context.go(navItems[index]['path']!),
              items: navItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: const Icon(Icons.circle),
                      label: item['label']!,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}
