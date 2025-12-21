import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/missions.dart';
import 'auth_controller.dart';

class MissionController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxMap<String, List<Mission>> missions = <String, List<Mission>>{}.obs;
  final RxList<Mission> activeMissions = <Mission>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMissions();
  }

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

      if (token != null) {
        await MissionsData.updateMissionStatuses(fetchedMissions, token: token);
      }

      missions.value = fetchedMissions;
      _updateActiveMissions();
    } catch (e) {
      debugPrint('Error loading missions: $e');
      missions.value = MissionsData.missions;
      _updateActiveMissions();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshMissions() async {
    await loadMissions(silent: true);
  }

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

  Future<bool> startMission(Mission mission) async {
    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      final result = await Mission.startMission(mission.id, token: token);

      if (result != null) {
        // Update local mission status
        mission.status = 'on_going';
        _updateActiveMissions();

        refreshMissions();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error starting mission: $e');
      rethrow;
    }
  }

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

      // Update local mission status
      mission.status = 'completed';
      _updateActiveMissions();

      refreshMissions();

      return true;
    } catch (e) {
      debugPrint('Error completing mission: $e');
      rethrow;
    }
  }

  List<Mission> getMissionsByCategory(String category) {
    return missions[category] ?? [];
  }

  List<String> get categories => missions.keys.toList();
}
