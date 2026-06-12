import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SettingsMenuPage extends StatelessWidget {
  const SettingsMenuPage({super.key});

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
          'Pengaturan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _SettingsMenuItem(
                icon: IconsaxPlusLinear.lock,
                title: 'Ubah Password',
                subtitle: 'Perbarui kata sandi akun Anda',
                onTap: () {
                  Get.toNamed(NavigationRoute.changePasswordRoute.path);
                },
              ),
              const SizedBox(height: 12),
              _SettingsMenuItem(
                icon: IconsaxPlusLinear.profile,
                title: 'Edit Profil',
                subtitle: 'Perbarui informasi profil Anda',
                onTap: () {
                  Get.toNamed(NavigationRoute.editProfileRoute.path);
                },
              ),
              const SizedBox(height: 12),
              _SettingsMenuItem(
                icon: IconsaxPlusLinear.activity,
                title: 'Ubah Target Poin',
                subtitle: 'Sesuaikan target poin harian Anda',
                onTap: () {
                  Get.toNamed(NavigationRoute.changePointTargetRoute.path);
                },
              ),
              const SizedBox(height: 12),
              _SettingsMenuItem(
                icon: IconsaxPlusLinear.color_swatch,
                title: 'Data Demo',
                subtitle: 'Mock data untuk keperluan screenshot',
                onTap: () {
                  Get.toNamed(NavigationRoute.mockDataRoute.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primary.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColor.primary.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
