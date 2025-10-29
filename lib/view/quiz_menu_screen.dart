import 'package:flutter/material.dart';
import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_color.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  Widget _buildQuizItem(
    BuildContext context,
    String title,
    String subtitle,
    String badgeText,
    IconData icon,
  ) {
    Color primaryColor = AppColor.primary.color;
    Color cyanColor = AppColor.cyan.color;
    Color lightBlueBg = primaryColor.withOpacity(0.4);
    Color darkTextColor = cyanColor.withOpacity(0.9);
    Color secondaryTextColor = cyanColor.withOpacity(0.7);

    return Card(
      elevation: 0,
      color: lightBlueBg.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, NavigationRoute.quizQuestion.path);
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
    Color headerBg = AppColor.primary.color;

    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header Biru Muda
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            decoration: BoxDecoration(color: headerBg),
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
                    color: Colors.white,
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Image(
                      image: AssetImage('assets/profile.png'),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    _buildQuizItem(
                      context,
                      'Daily Quiz',
                      '3 questions left',
                      '15 Qs',
                      Icons.chat_bubble_outline,
                    ),
                    _buildQuizItem(
                      context,
                      'Weekly Quiz',
                      'Open in 5 days',
                      '15 Qs',
                      Icons.chat_bubble_outline,
                    ),
                    _buildQuizItem(
                      context,
                      'Survey',
                      'Open in 2 days',
                      '15 Qs',
                      Icons.chat_bubble_outline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
