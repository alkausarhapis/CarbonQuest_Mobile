import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import 'navigation_route.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated.value) {
      return RouteSettings(name: NavigationRoute.loginRoute.path);
    }

    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (authController.isAuthenticated.value) {
      return RouteSettings(name: NavigationRoute.mainRoute.path);
    }

    return null;
  }
}
