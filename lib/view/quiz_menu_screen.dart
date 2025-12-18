import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/quiz_controller.dart';

class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  late final QuizController _quizController;

  @override
  void initState() {
    super.initState();
    // Initialize or get QuizController
    if (Get.isRegistered<QuizController>()) {
      _quizController = Get.find<QuizController>();
    } else {
      _quizController = Get.put(QuizController());
    }
    // Load completion status for all quizzes
    _loadQuizCompletionStatus();
  }

  Future<void> _loadQuizCompletionStatus() async {
    for (var quiz in _quizController.quizzes) {
      await _quizController.isQuizCompleted(quiz.idQuiz);
    }
  }

  Widget _buildQuizItem(
    BuildContext context,
    String title,
    String subtitle,
    String badgeText,
    IconData icon,
    String quizType,
    int quizId,
    bool isCompleted,
  ) {
    Color primaryColor = AppColor.primary.color;
    Color cyanColor = AppColor.cyan.color;
    Color lightBlueBg = primaryColor.withValues(alpha: 0.4);
    Color darkTextColor = cyanColor.withValues(alpha: 0.9);
    Color secondaryTextColor = cyanColor.withValues(alpha: 0.7);

    return Card(
      elevation: 0,
      color: isCompleted
          ? Colors.grey.withValues(alpha: 0.2)
          : lightBlueBg.withValues(alpha: 0.2),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: isCompleted
            ? () {
                Get.snackbar(
                  'Kuis Sudah Selesai',
                  'Anda sudah menyelesaikan kuis ini!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            : () {
                Get.toNamed(
                  NavigationRoute.quizQuestion.path,
                  arguments: quizType,
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
                  color: isCompleted ? Colors.grey.shade300 : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: isCompleted ? Colors.grey : primaryColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isCompleted ? Colors.grey : darkTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted ? Colors.grey : secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Badge "15 Qs"
                    Row(
                      children: [
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
                              color: isCompleted ? Colors.grey : primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Selesai',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey.shade300 : lightBlueBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isCompleted ? Colors.grey : primaryColor,
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
                            Get.toNamed(NavigationRoute.profileRoute.path);
                          },
                          child: Obx(() {
                            final profileImageUrl = authController
                                .currentUser
                                .value
                                ?.profileImageUrl;
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFD9E3E8),
                              backgroundImage: profileImageUrl != null
                                  ? NetworkImage(profileImageUrl)
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
                  child: Obx(() {
                    if (_quizController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_quizController.quizzes.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada kuis tersedia',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => _quizController.loadQuizzes(),
                      child: ListView(
                        children: _quizController.quizzes.map((quiz) {
                          String quizType;
                          switch (quiz.category) {
                            case 'Harian':
                              quizType = 'daily';
                              break;
                            case 'Mingguan':
                              quizType = 'weekly';
                              break;
                            case 'Bulanan':
                              quizType = 'monthly';
                              break;
                            default:
                              quizType = 'daily';
                          }

                          IconData icon;
                          switch (quiz.category) {
                            case 'Harian':
                              icon = Icons.today;
                              break;
                            case 'Mingguan':
                              icon = Icons.calendar_view_week;
                              break;
                            case 'Bulanan':
                              icon = Icons.calendar_month;
                              break;
                            default:
                              icon = Icons.quiz;
                          }

                          // Check if quiz is completed
                          final isCompleted =
                              _quizController.quizCompletionStatus[quiz
                                  .idQuiz] ??
                              false;

                          return _buildQuizItem(
                            context,
                            quiz.title,
                            '${quiz.questionCount} pertanyaan',
                            '${quiz.questionCount} Qs',
                            icon,
                            quizType,
                            quiz.idQuiz,
                            isCompleted,
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
