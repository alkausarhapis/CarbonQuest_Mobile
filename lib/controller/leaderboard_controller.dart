import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/users.dart';
import 'auth_controller.dart';

class LeaderboardController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxList<User> leaderboard = <User>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<int> currentUserRank = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    isLoading.value = true;

    try {
      final token = await _authController.getToken();

      final users = await User.fetchLeaderboard(token: token);

      leaderboard.value = users;

      final currentUser = _authController.currentUser.value;
      if (currentUser != null) {
        final userIndex = users.indexWhere(
          (user) => user.id.toString() == currentUser.id,
        );
        if (userIndex != -1) {
          currentUserRank.value = userIndex + 1;
        } else {
          debugPrint('User not found in leaderboard');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Gagal memuat leaderboard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<User> getTopUsers(int count) {
    return leaderboard.take(count).toList();
  }

  User? getUserById(int id) {
    try {
      return leaderboard.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}
