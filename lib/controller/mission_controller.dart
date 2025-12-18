import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/missions.dart';
import 'auth_controller.dart';

class MissionController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Reactive state
  final RxMap<String, List<Mission>> missions = <String, List<Mission>>{}.obs;
  final RxList<Mission> activeMissions = <Mission>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMissions();
  }

  /// Load missions from API
  Future<void> loadMissions({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    } else {
      isRefreshing.value = true;
    }

    try {
      final token = await _authController.getToken();
      final fetchedMissions = await MissionsData.fetchMissionsByCategory(
        token: token,
      );

      // Update mission statuses from user's missions
      if (token != null) {
        await MissionsData.updateMissionStatuses(fetchedMissions, token: token);
      }

      missions.value = fetchedMissions;
      _updateActiveMissions();
    } catch (e) {
      debugPrint('Error loading missions: $e');
      // Use static data as fallback
      missions.value = MissionsData.missions;
      _updateActiveMissions();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  /// Refresh missions silently (for background updates)
  Future<void> refreshMissions() async {
    await loadMissions(silent: true);
  }

  /// Update active missions list
  void _updateActiveMissions() {
    final List<Mission> active = [];
    missions.forEach((category, missionList) {
      active.addAll(
        missionList.where(
          (mission) =>
              mission.status == 'on_going' || mission.status == 'in_progress',
        ),
      );
    });
    activeMissions.value = active;
  }

  /// Start a mission
  Future<bool> startMission(Mission mission) async {
    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      final result = await Mission.startMission(mission.id, token: token);

      if (result != null) {
        // Update mission status locally
        mission.status = 'on_going';
        _updateActiveMissions();

        // Refresh missions in background to get latest data
        refreshMissions();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error starting mission: $e');
      rethrow;
    }
  }

  /// Complete a mission
  Future<bool> completeMission(Mission mission, String workingId) async {
    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      await Mission.completeMission(
        workingId,
        token: token,
        points: mission.points,
      );

      // Update mission status locally
      mission.status = 'completed';
      _updateActiveMissions();

      // Refresh missions in background to get latest data
      refreshMissions();

      return true;
    } catch (e) {
      debugPrint('Error completing mission: $e');
      rethrow;
    }
  }

  /// Get missions by category
  List<Mission> getMissionsByCategory(String category) {
    return missions[category] ?? [];
  }

  /// Get all categories
  List<String> get categories => missions.keys.toList();
}
