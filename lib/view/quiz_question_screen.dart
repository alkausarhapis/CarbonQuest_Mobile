// lib/view/quiz_question_screen.dart

import 'package:carbonquest/core/styles/app_color.dart';
import 'package:carbonquest/view/quiz_score_screen.dart';
import 'package:flutter/material.dart';

import '../model/questions.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String quizType;

  const QuizQuestionScreen({super.key, this.quizType = 'daily'});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  List<int?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _questions = QuestionsData.getQuizByType(widget.quizType);
    _userAnswers = List.filled(_questions.length, null);
  }

  void _goToNextQuestion() {
    if (_selectedAnswer != null) {
      _userAnswers[_currentQuestionIndex] = _selectedAnswer;

      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = _userAnswers[_currentQuestionIndex];
        });
      } else {
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
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _userAnswers[_currentQuestionIndex];
      });
    }
  }

  void _finishQuiz() {
    int score = 0;
    int maxScore = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] != null) {
        score += _questions[i].pointsPerOption[_userAnswers[i]!];
      }
      maxScore += _questions[i].pointsPerOption.reduce((a, b) => a > b ? a : b);
    }

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

  Widget _buildNavButton(String text, bool isPrimary, VoidCallback onTap) {
    Color primaryColor = AppColor.primary.color;
    Color secondaryColor = AppColor.cyan.color.withValues(alpha: 0.5);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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

  Widget _buildAnswerOption(String text, int value) {
    bool isSelected = _selectedAnswer == value;

    Color primaryColor = AppColor.primary.color;
    Color darkTextColor = AppColor.cyan.color;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedAnswer = value;
        });
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
              value: value,
              groupValue: _selectedAnswer,
              onChanged: (int? val) {
                setState(() {
                  _selectedAnswer = val;
                });
              },
              activeColor: primaryColor,
            ),
            Expanded(
              child: Text(
                text,
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
    Color headerBg = AppColor.primary.color;
    Color quizTitleColor = Colors.white;

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            'assets/profile.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
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
                            'Pertanyaan ${_currentQuestionIndex + 1} dari ${_questions.length}',
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
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
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
                            '${_currentQuestionIndex + 1}',
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
                        currentQuestion.question,
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
                      currentQuestion.options.length,
                      (index) => _buildAnswerOption(
                        currentQuestion.options[index],
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
                      if (_currentQuestionIndex > 0)
                        _buildNavButton('<<', false, _goToPreviousQuestion),
                      if (_currentQuestionIndex > 0) const SizedBox(width: 30),
                      _buildNavButton(
                        _currentQuestionIndex < _questions.length - 1
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
  }
}
