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
      debugPrint('🔄 Loading leaderboard...');
      final token = await _authController.getToken();
      debugPrint('🔑 Token: ${token?.substring(0, 20)}...');

      final users = await User.fetchLeaderboard(token: token);
      debugPrint('✅ Loaded ${users.length} users');

      leaderboard.value = users;

      // Find current user's rank
      final currentUser = _authController.currentUser.value;
      if (currentUser != null) {
        debugPrint('👤 Looking for user ID: ${currentUser.id}');
        final userIndex = users.indexWhere(
          (user) => user.id.toString() == currentUser.id,
        );
        if (userIndex != -1) {
          currentUserRank.value = userIndex + 1;
          debugPrint('🏆 User rank: ${currentUserRank.value}');
        } else {
          debugPrint('⚠️ User not found in leaderboard');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading leaderboard: $e');
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
      debugPrint('🏁 Loading complete. Users: ${leaderboard.length}');
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
