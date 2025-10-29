import 'package:carbonquest/view/login_screen.dart';
import 'package:carbonquest/view/main_screen.dart';
import 'package:carbonquest/view/register_screen.dart';
import 'package:carbonquest/view/mission_screen.dart';
import 'package:flutter/material.dart';

import 'core/navigation_route.dart';
import 'core/styles/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: NavigationRoute.missionRoute.path,
      routes: {
        NavigationRoute.mainRoute.path: (context) => const MainScreen(),
        NavigationRoute.loginRoute.path: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.path: (context) => const RegisterScreen(),
        NavigationRoute.missionRoute.path: (context) => const MissionScreen(),
      },
    );
  }
}
