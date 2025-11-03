import 'package:carbonquest/controller/auth_controller.dart';
import 'package:carbonquest/view/login_screen.dart';
import 'package:carbonquest/view/main_screen.dart';
import 'package:carbonquest/view/mission_screen.dart';
import 'package:carbonquest/view/quiz_menu_screen.dart';
import 'package:carbonquest/view/quiz_question_screen.dart';
import 'package:carbonquest/view/register_screen.dart';
import 'package:carbonquest/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/navigation_route.dart';
import 'core/styles/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(AuthController());

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool(AuthController.loggedInKey) ?? false;

  runApp(
    MainApp(
      initialRoute: isLoggedIn
          ? NavigationRoute.mainRoute.path
          : NavigationRoute.loginRoute.path,
    ),
  );
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: initialRoute,
      routes: {
        NavigationRoute.mainRoute.path: (context) => const MainScreen(),
        NavigationRoute.loginRoute.path: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.path: (context) => const RegisterScreen(),
        NavigationRoute.quizRoot.path: (context) => const QuizMenuScreen(),
        NavigationRoute.quizQuestion.path: (context) {
          final quizType =
              ModalRoute.of(context)?.settings.arguments as String?;
          return QuizQuestionScreen(quizType: quizType ?? 'daily');
        },
        NavigationRoute.missionRoute.path: (context) => const MissionScreen(),
        NavigationRoute.profileRoute.path: (context) => const SettingsScreen(),
      },
    );
  }
}
