// lib/view/quiz_question_screen.dart

import 'package:flutter/material.dart';
import 'package:carbonquest/core/styles/app_color.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  String? _selectedAnswer = '1-2 buah';

  Widget _buildNavButton(String text, bool isPrimary, VoidCallback onTap) {
    Color primaryColor = AppColor.primary.color;
    Color secondaryColor = AppColor.cyan.color.withOpacity(0.5);

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

  Widget _buildAnswerOption(String text, String value) {
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
          color: isSelected ? primaryColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedAnswer,
              onChanged: (String? val) {
                setState(() {
                  _selectedAnswer = val;
                });
              },
              activeColor: primaryColor,
            ),
            Text(text, style: TextStyle(fontSize: 16, color: darkTextColor)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color headerBg = AppColor.primary.color;
    Color quizTitleColor = Colors.white;

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
                        'Quiz',
                        style: TextStyle(
                          fontSize: 30,
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

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '15',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Berapa banyak sampah plastik sekali pakai (contoh: botol minum, kantong kresek, sedotan) yang Anda gunakan hari ini?',
                        style: TextStyle(fontSize: 17, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      _buildAnswerOption('0 buah', '0 buah'),
                      _buildAnswerOption('1-2 buah', '1-2 buah'),
                      _buildAnswerOption('3-5 buah', '3-5 buah'),
                      _buildAnswerOption(
                        'Lebih dari 5 buah',
                        'Lebih dari 5 buah',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavButton('<<', false, () {}),
                      const SizedBox(width: 30),
                      _buildNavButton('>>', true, () {}),
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
