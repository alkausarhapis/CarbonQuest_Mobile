import 'package:carbonquest/view/login_screen.dart';
import 'package:carbonquest/view/main_screen.dart';
import 'package:carbonquest/view/mission_screen.dart';
import 'package:carbonquest/view/quiz_menu_screen.dart';
import 'package:carbonquest/view/quiz_question_screen.dart';
import 'package:carbonquest/view/register_screen.dart';
import 'package:carbonquest/view/settings_page.dart';
import 'package:flutter/material.dart';

import 'core/navigation_route.dart';
import 'core/styles/app_theme.dart';

void main() {
  runApp(const MainApp());
}

// TODO: Leaderboard page
// TODO: Article page
// TODO: History page
// TODO: Implement components/widgets for reusability

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: NavigationRoute.loginRoute.path,
      routes: {
        NavigationRoute.mainRoute.path: (context) => const MainScreen(),
        NavigationRoute.loginRoute.path: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.path: (context) => const RegisterScreen(),
        NavigationRoute.quizRoot.path: (context) => const QuizMenuScreen(),
        NavigationRoute.quizQuestion.path: (context) =>
            const QuizQuestionScreen(),
        NavigationRoute.missionRoute.path: (context) => const MissionScreen(),
        NavigationRoute.profileRoute.path: (context) => const SettingsScreen(),
      },
    );
  }
}
