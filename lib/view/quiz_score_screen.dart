import 'dart:convert';

import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuizScoreScreen extends StatefulWidget {
  final int score;
  final int maxScore;
  final String quizType;
  final String qaSummary;

  const QuizScoreScreen({
    super.key,
    required this.score,
    required this.maxScore,
    required this.quizType,
    this.qaSummary = '',
  });

  @override
  State<QuizScoreScreen> createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  String _aiFeedback = 'Sedang memuat umpan balik AI...';
  bool _isLoadingFeedback = true;

  @override
  void initState() {
    super.initState();
    _fetchAIFeedback();
  }

  Future<void> _fetchAIFeedback() async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _aiFeedback = 'API Key belum diatur. Mohon periksa file .env';
          _isLoadingFeedback = false;
        });
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'openai/gpt-oss-120b:free',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Kamu adalah ahli lingkungan. Berikan rekomendasi tindakan nyata dalam bahasa Indonesia. Maksimal 1 paragraf. Boleh gunakan emoji. Jangan beri penjelasan tambahan.',
            },
            {
              'role': 'user',
              'content':
                  'Saya menyelesaikan ${widget.quizType == "daily"
                      ? "Kuis Harian"
                      : widget.quizType == "weekly"
                      ? "Kuis Mingguan"
                      : widget.quizType == "monthly"
                      ? "Kuis Bulanan"
                      : "Kuis"} dengan skor ${widget.score} dari ${widget.maxScore}.\n\nBerikut adalah soal dan jawaban yang saya pilih:\n${widget.qaSummary}\n\nBerikan komentar singkat dan rekomendasi spesifik.',
            },
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _aiFeedback = data['choices'][0]['message']['content'];
            _isLoadingFeedback = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _aiFeedback = 'Gagal memuat umpan balik. Terjadi kesalahan server.';
            _isLoadingFeedback = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiFeedback = 'Terjadi kesalahan jaringan saat memuat umpan balik.';
          _isLoadingFeedback = false;
        });
      }
    }
  }

  String _getQuizTypeName() {
    switch (widget.quizType) {
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

  Color _getScoreColor() {
    double percentage = (widget.score / widget.maxScore) * 100;

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
    if (_isLoadingFeedback) {
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
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Mengumpulkan nilai...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Meminta analisis AI dari jawabanmu...',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final percentage = ((widget.score / widget.maxScore) * 100).toInt();

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
                                '${widget.score}',
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
                                'dari ${widget.maxScore} poin',
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
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.smart_toy,
                                    color: AppColor.primary.color,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Umpan Balik AI',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primary.color,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _aiFeedback,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.cyan.color,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
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
                          Get.until((route) => route.isFirst);
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
}
