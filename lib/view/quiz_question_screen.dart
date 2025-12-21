import 'package:carbonquest/core/styles/app_color.dart';
import 'package:carbonquest/view/quiz_score_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/quiz_controller.dart';
import '../model/quiz.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String quizType;

  const QuizQuestionScreen({super.key, this.quizType = 'daily'});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  late final QuizController _quizController;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<QuizController>()) {
      _quizController = Get.find<QuizController>();
    } else {
      _quizController = Get.put(QuizController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuiz();
    });
  }

  Future<void> _loadQuiz() async {
    final success = await _quizController.startQuiz(widget.quizType);
    if (mounted && !success) {
      Navigator.pop(context);
    }
  }

  void _goToNextQuestion() {
    final selectedAnswer =
        _quizController.userAnswers[_quizController.currentQuestionIndex.value];

    if (selectedAnswer != null) {
      if (!_quizController.goToNextQuestion()) {
        _finishQuiz();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jawaban terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _goToPreviousQuestion() {
    _quizController.goToPreviousQuestion();
  }

  Future<void> _finishQuiz() async {
    await _quizController.submitQuiz();

    final score = _quizController.totalScore.value;
    final maxScore = _quizController.getMaxScore();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScoreScreen(
            score: score,
            maxScore: maxScore,
            quizType: widget.quizType,
          ),
        ),
      );
    }
  }

  Widget _buildNavButton(String text, bool isPrimary, VoidCallback onTap) {
    Color primaryColor = AppColor.primary.color;
    Color secondaryColor = AppColor.cyan.color.withValues(alpha: 0.5);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOption(Answer answer, int index) {
    final currentIndex = _quizController.currentQuestionIndex.value;
    final selectedAnswer = _quizController.userAnswers[currentIndex];
    bool isSelected = selectedAnswer == index;

    Color primaryColor = AppColor.primary.color;
    Color darkTextColor = AppColor.cyan.color;

    return InkWell(
      onTap: () {
        _quizController.selectAnswer(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedAnswer,
              onChanged: (int? val) {
                _quizController.selectAnswer(val!);
              },
              activeColor: primaryColor,
            ),
            Expanded(
              child: Text(
                answer.content,
                style: TextStyle(fontSize: 16, color: darkTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_quizController.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColor.primary.color,
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      if (_quizController.currentQuestions.isEmpty) {
        return Scaffold(
          backgroundColor: AppColor.primary.color,
          body: const Center(
            child: Text(
              'Tidak ada pertanyaan tersedia',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      Color headerBg = AppColor.primary.color;
      Color quizTitleColor = Colors.white;

      final currentIndex = _quizController.currentQuestionIndex.value;
      final currentQuestion = _quizController.currentQuestions[currentIndex];
      final progress =
          (currentIndex + 1) / _quizController.currentQuestions.length;

      return Scaffold(
        body: Stack(
          children: [
            Container(height: 200, decoration: BoxDecoration(color: headerBg)),

            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Kuis ${widget.quizType == 'daily'
                              ? 'Harian'
                              : widget.quizType == 'weekly'
                              ? 'Mingguan'
                              : 'Bulanan'}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: quizTitleColor,
                          ),
                        ),
                        Obx(() {
                          final profileImageUrl = _authController
                              .currentUser
                              .value
                              ?.profileImageUrl;
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            backgroundImage: profileImageUrl != null
                                ? NetworkImage(profileImageUrl)
                                : const AssetImage('assets/profile.png')
                                      as ImageProvider,
                          );
                        }),
                      ],
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pertanyaan ${_quizController.currentQuestionIndex.value + 1} dari ${_quizController.currentQuestions.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColor.primary.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${currentIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          currentQuestion.content,
                          style: const TextStyle(fontSize: 17, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: List.generate(
                        currentQuestion.answers.length,
                        (index) => _buildAnswerOption(
                          currentQuestion.answers[index],
                          index,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_quizController.currentQuestionIndex.value > 0)
                          _buildNavButton('<<', false, _goToPreviousQuestion),
                        if (_quizController.currentQuestionIndex.value > 0)
                          const SizedBox(width: 30),
                        _buildNavButton(
                          _quizController.currentQuestionIndex.value <
                                  _quizController.currentQuestions.length - 1
                              ? '>>'
                              : 'Selesai',
                          true,
                          _goToNextQuestion,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
