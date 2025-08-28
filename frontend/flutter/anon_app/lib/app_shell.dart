import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    final navItems = [
      {'label': 'Feed', 'path': '/feed'},
      {'label': 'Create', 'path': '/create'},
      {'label': 'About', 'path': '/about'},
      {'label': 'Account', 'path': '/account'},
    ];

    bool isMobile = MediaQuery.of(context).size.width < 600;

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
              currentIndex: navItems.indexWhere(
                (item) => location.startsWith(item['path']!),
              ),
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
