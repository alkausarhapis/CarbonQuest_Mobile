import 'package:carbonquest/controller/auth_controller.dart';
import 'package:carbonquest/core/auth_middleware.dart';
import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_theme.dart';
import 'package:carbonquest/view/login_screen.dart';
import 'package:carbonquest/view/main_screen.dart';
import 'package:carbonquest/view/mission_screen.dart';
import 'package:carbonquest/view/quiz_menu_screen.dart';
import 'package:carbonquest/view/quiz_question_screen.dart';
import 'package:carbonquest/view/register_screen.dart';
import 'package:carbonquest/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final authController = Get.put(AuthController());

  while (!authController.isInitialized.value) {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  debugPrint(
    'Starting app with isAuthenticated: ${authController.isAuthenticated.value}',
  );

  runApp(
    MainApp(
      initialRoute: authController.isAuthenticated.value
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
      getPages: [
        GetPage(
          name: NavigationRoute.loginRoute.path,
          page: () => const LoginScreen(),
          middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.registerRoute.path,
          page: () => const RegisterScreen(),
          middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.mainRoute.path,
          page: () => const MainScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.quizRoot.path,
          page: () => const QuizMenuScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.quizQuestion.path,
          page: () {
            final quizType = Get.arguments as String?;
            return QuizQuestionScreen(quizType: quizType ?? 'daily');
          },
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.missionRoute.path,
          page: () => const MissionScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: NavigationRoute.profileRoute.path,
          page: () => const SettingsScreen(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
