import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/mission_controller.dart';
import '../../core/styles/app_color.dart';
import '../../model/missions.dart';

class MissionDetailBottomSheet extends StatefulWidget {
  final Mission mission;
  final VoidCallback onUpdate;

  const MissionDetailBottomSheet({
    super.key,
    required this.mission,
    required this.onUpdate,
  });

  static void show(
    BuildContext context,
    Mission mission,
    VoidCallback onUpdate,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          MissionDetailBottomSheet(mission: mission, onUpdate: onUpdate),
    );
  }

  @override
  State<MissionDetailBottomSheet> createState() =>
      _MissionDetailBottomSheetState();
}

class _MissionDetailBottomSheetState extends State<MissionDetailBottomSheet> {
  late final AuthController _authController;
  late final MissionController _missionController;
  final _isLoading = false.obs;
  final Rx<String?> _workingId = Rx<String?>(null);

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    if (Get.isRegistered<MissionController>()) {
      _missionController = Get.find<MissionController>();
    } else {
      _missionController = Get.put(MissionController());
    }

    if (widget.mission.status == 'on_going' &&
        widget.mission.workingId != null) {
      _workingId.value = widget.mission.workingId;
    }
  }

  Future<void> _startMission() async {
    _isLoading.value = true;

    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      final result = await Mission.startMission(
        widget.mission.id,
        token: token,
      );

      if (result != null) {
        _workingId.value = result['id_working']?.toString();
        widget.mission.workingId = _workingId.value;
        widget.mission.status = 'on_going';

        Get.back();
        widget.onUpdate();
        Get.snackbar(
          'Sukses',
          'Misi "${widget.mission.title}" telah dimulai!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint('Error starting mission: $e');
      Get.snackbar(
        'Error',
        'Gagal memulai misi: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _completeMission() async {
    _isLoading.value = true;

    try {
      if (_workingId.value == null) {
        throw Exception('Working ID not found');
      }

      final success = await _missionController.completeMission(
        widget.mission,
        _workingId.value!,
      );

      if (success) {
        Get.back();
        widget.onUpdate();
        Get.snackbar(
          'Selamat!',
          'Misi "${widget.mission.title}" telah selesai! +${widget.mission.points} poin',
          backgroundColor: Colors.amber[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint('Error completing mission: $e');
      Get.snackbar(
        'Error',
        'Gagal menyelesaikan misi: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Mission icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primary.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    widget.mission.icon,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mission.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.mission.points} Poin',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Divider
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            // Description section
            const Text(
              'Deskripsi Misi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.mission.desc,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColor.primary.color),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading.value
                          ? null
                          : (widget.mission.status == 'not_started' ||
                                widget.mission.status == 'on_going')
                          ? (widget.mission.status == 'not_started'
                                ? _startMission
                                : _completeMission)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: widget.mission.status == 'completed'
                            ? Colors.grey
                            : AppColor.primary.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              widget.mission.status == 'not_started'
                                  ? 'Mulai Misi'
                                  : widget.mission.status == 'on_going'
                                  ? 'Selesaikan Misi'
                                  : 'Sudah Selesai',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
