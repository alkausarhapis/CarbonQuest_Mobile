import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';

class QuizScoreScreen extends StatelessWidget {
  final int score;
  final int maxScore;
  final String quizType;

  const QuizScoreScreen({
    super.key,
    required this.score,
    required this.maxScore,
    required this.quizType,
  });

  String _getQuizTypeName() {
    switch (quizType) {
      case 'daily':
        return 'Kuis Harian';
      case 'weekly':
        return 'Kuis Mingguan';
      case 'monthly':
        return 'Kuis Bulanan';
      default:
        return 'Kuis';
    }
  }

  String _getMessage() {
    double percentage = (score / maxScore) * 100;

    if (percentage >= 90) {
      return 'Luar biasa! Anda sangat peduli lingkungan! 🌟';
    } else if (percentage >= 75) {
      return 'Bagus sekali! Terus tingkatkan kepedulian lingkungan! 🌿';
    } else if (percentage >= 50) {
      return 'Cukup baik! Masih ada ruang untuk berkembang! 🌱';
    } else {
      return 'Yuk, tingkatkan kepedulian lingkungan kita! 💚';
    }
  }

  Color _getScoreColor() {
    double percentage = (score / maxScore) * 100;

    if (percentage >= 90) {
      return Colors.green.shade700;
    } else if (percentage >= 75) {
      return Colors.green.shade500;
    } else if (percentage >= 50) {
      return Colors.orange.shade600;
    } else {
      return Colors.orange.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((score / maxScore) * 100).toInt();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primary.color,
              AppColor.primary.color.withValues(alpha: 0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Trophy Icon
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            size: 80,
                            color: _getScoreColor(),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Quiz Type
                        Text(
                          _getQuizTypeName(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Selesai!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Score Card
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Skor Anda',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Main Score
                              Text(
                                '$score',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(),
                                  height: 1,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Max Score
                              Text(
                                'dari $maxScore poin',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Percentage Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getScoreColor().withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$percentage%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Message
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getMessage(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.cyan.color,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Stats
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                Icons.check_circle,
                                'Poin Diraih',
                                '$score',
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                Icons.grade,
                                'Persentase',
                                '$percentage%',
                                Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Back to Home Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Pop all routes until we reach home
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary.color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
