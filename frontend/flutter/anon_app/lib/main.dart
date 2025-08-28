import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_controller.dart';
import 'features/post/post_controller.dart';
import 'pages/feed_page.dart';
import 'pages/create_page.dart';
import 'pages/mod_page.dart';
import 'pages/about_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/account_page.dart';
import 'app_shell.dart';

void main() {
  runApp(const AnonApp());
}

class AnonApp extends StatelessWidget {
  const AnonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = AuthController();
    final PostController posts = PostController(auth);

    final GoRouter router = GoRouter(
      initialLocation: '/feed', // ✅ Feed is now landing page
      routes: [
        GoRoute(
          path: '/feed',
          builder: (context, state) =>
              AppShell(child: FeedPage(controller: posts)),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) =>
              AppShell(child: CreatePage(controller: posts)),
        ),
        GoRoute(
          path: '/mod',
          builder: (context, state) => const AppShell(child: ModPage()),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AppShell(child: AboutPage()),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(authController: auth),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(authController: auth),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => AccountPage(authController: auth),
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
