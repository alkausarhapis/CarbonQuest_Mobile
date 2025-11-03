import 'dart:io';

import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  Widget _buildQuizItem(
    BuildContext context,
    String title,
    String subtitle,
    String badgeText,
    IconData icon,
    String quizType,
  ) {
    Color primaryColor = AppColor.primary.color;
    Color cyanColor = AppColor.cyan.color;
    Color lightBlueBg = primaryColor.withValues(alpha: 0.4);
    Color darkTextColor = cyanColor.withValues(alpha: 0.9);
    Color secondaryTextColor = cyanColor.withValues(alpha: 0.7);

    return Card(
      elevation: 0,
      color: lightBlueBg.withValues(alpha: 0.2),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            NavigationRoute.quizQuestion.path,
            arguments: quizType, // Pass quizType
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: primaryColor, size: 30),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 4),
                    // Badge "15 Qs"
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow ke kanan dan Bentuk Biru Muda di belakangnya
              Stack(
                alignment: Alignment.center,
                children: [
                  // Bentuk Biru Muda di Belakang Arrow
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    Color headerBg = AppColor.primary.color;

    return Scaffold(
      backgroundColor: headerBg,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset('assets/CloudVector.png', height: 80),
                    ),
                    Positioned(
                      top: 50,
                      left: 0,
                      child: Image.asset('assets/CloudVector.png', height: 40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quiz',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Obx(() {
                            final profileImagePath = authController
                                .currentUser
                                .value
                                ?.profileImagePath;
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFD9E3E8),
                              backgroundImage:
                                  profileImagePath != null &&
                                      File(profileImagePath).existsSync()
                                  ? FileImage(File(profileImagePath))
                                  : const AssetImage('assets/profile.png')
                                        as ImageProvider,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      _buildQuizItem(
                        context,
                        'Kuis Harian',
                        '10 pertanyaan',
                        '10 Qs',
                        Icons.today,
                        'daily',
                      ),
                      _buildQuizItem(
                        context,
                        'Kuis Mingguan',
                        '5 pertanyaan',
                        '5 Qs',
                        Icons.calendar_view_week,
                        'weekly',
                      ),
                      _buildQuizItem(
                        context,
                        'Kuis Bulanan',
                        '3 pertanyaan',
                        '3 Qs',
                        Icons.calendar_month,
                        'monthly',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
