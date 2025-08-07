import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/post/post_controller.dart';
import 'pages/feed_page.dart';
import 'pages/create_page.dart';
import 'pages/mod_page.dart';
import 'pages/about_page.dart';
import 'app_shell.dart';

void main() {
  runApp(const AnonApp());
}

class AnonApp extends StatelessWidget {
  const AnonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController controller = PostController();

    final GoRouter router = GoRouter(
      initialLocation: '/feed',
      routes: [
        GoRoute(
          path: '/feed',
          builder: (context, state) =>
              AppShell(child: FeedPage(controller: controller)),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) =>
              AppShell(child: CreatePage(controller: controller)),
        ),
        GoRoute(
          path: '/mod',
          builder: (context, state) => const AppShell(child: ModPage()),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AppShell(child: AboutPage()),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}
