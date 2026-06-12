import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../controller/home_controller.dart';
import '../controller/mock_data_controller.dart';
import '../core/custom_snackbar.dart';
import '../core/navigation_route.dart';
import '../core/styles/app_color.dart';

class MockDataPage extends StatefulWidget {
  const MockDataPage({super.key});

  @override
  State<MockDataPage> createState() => _MockDataPageState();
}

class _MockDataPageState extends State<MockDataPage> {
  final MockDataController _mockController = Get.find<MockDataController>();
  late TextEditingController _totalPointsController;
  late TextEditingController _todayPointsController;

  @override
  void initState() {
    super.initState();
    _totalPointsController = TextEditingController(
      text: _mockController.mockTotalPoints.value.toString(),
    );
    _todayPointsController = TextEditingController(
      text: _mockController.mockTodayPoints.value.toString(),
    );
  }

  @override
  void dispose() {
    _totalPointsController.dispose();
    _todayPointsController.dispose();
    super.dispose();
  }

  Future<void> _applyMockData() async {
    final total = int.tryParse(_totalPointsController.text);
    final today = int.tryParse(_todayPointsController.text);

    if (total == null || total < 0) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Total poin harus angka positif',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (today == null || today < 0) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Poin hari ini harus angka positif',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _mockController.setMockTotalPoints(total);
    await _mockController.setMockTodayPoints(today);
    await _mockController.setMockEnabled(true);

    _refreshHome();

    showCustomSnackbar(
      title: 'Sukses',
      message: 'Data demo berhasil diterapkan!',
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      colorText: Colors.white,
    );
    Get.offAllNamed(NavigationRoute.mainRoute.path);
  }

  Future<void> _generateDefault() async {
    await _mockController.generateDefaultMockData();
    _totalPointsController.text =
        _mockController.mockTotalPoints.value.toString();
    _todayPointsController.text =
        _mockController.mockTodayPoints.value.toString();
    setState(() {});

    _refreshHome();

    showCustomSnackbar(
      title: 'Sukses',
      message: 'Data demo default berhasil dibuat!',
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      colorText: Colors.white,
    );
    Get.offAllNamed(NavigationRoute.mainRoute.path);
  }

  void _refreshHome() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.loadTodayPoints();
      homeController.loadWeeklyPoints();
    }
  }

  Future<void> _disableMock() async {
    await _mockController.clearMockData();
    _refreshHome();
    showCustomSnackbar(
      title: 'Berhasil',
      message: 'Data demo dinonaktifkan',
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 2),
      colorText: Colors.white,
    );
    Get.offAllNamed(NavigationRoute.mainRoute.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primary.color,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Data Demo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Obx(() {
                if (!_mockController.isMockEnabled.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.info_circle,
                          color: Colors.orange[700],
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Data demo belum aktif. Aktifkan untuk mengisi data tanpa API.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconsaxPlusLinear.tick_circle,
                        color: Colors.green[700],
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data demo aktif. Poin & grafik menggunakan data lokal.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primary.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconsaxPlusLinear.color_swatch,
                        color: AppColor.primary.color,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Atur Data Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data ini akan ditampilkan di halaman utama dan profil tanpa memanggil server',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      label: 'Total Poin',
                      controller: _totalPointsController,
                      icon: IconsaxPlusLinear.award,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Poin Hari Ini',
                      controller: _todayPointsController,
                      icon: IconsaxPlusLinear.activity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primary.color,
                      AppColor.primary.color.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _applyMockData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusLinear.tick_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Terapkan Data Demo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _generateDefault,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColor.primary.color,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusLinear.color_swatch,
                        color: AppColor.primary.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Generate Default',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.primary.color,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (!_mockController.isMockEnabled.value) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _disableMock,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.slash,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Nonaktifkan Data Demo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: AppColor.primary.color, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primary.color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF2D3748),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
