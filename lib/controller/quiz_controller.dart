import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/quiz.dart';
import 'auth_controller.dart';

class QuizController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxList<Quiz> quizzes = <Quiz>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Quiz?> currentQuiz = Rx<Quiz?>(null);
  final RxList<Question> currentQuestions = <Question>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxList<int?> userAnswers = <int?>[].obs;
  final RxInt totalScore = 0.obs;
  final RxMap<int, bool> quizCompletionStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    isLoading.value = true;

    try {
      final token = await _authController.getToken();
      final fetchedQuizzes = await Quiz.fetchQuizzes(token: token);

      quizzes.value = fetchedQuizzes;
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat kuis: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Quiz? getQuizByCategory(String category) {
    try {
      return quizzes.firstWhere(
        (quiz) => quiz.category.toLowerCase() == category.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> isQuizCompleted(int quizId) async {
    if (quizCompletionStatus.containsKey(quizId)) {
      return quizCompletionStatus[quizId]!;
    }

    try {
      final token = await _authController.getToken();
      if (token == null) return false;

      final completed = await Quiz.isQuizCompleted(quizId, token: token);
      quizCompletionStatus[quizId] = completed;
      return completed;
    } catch (e) {
      debugPrint('Error checking quiz completion: $e');
      return false;
    }
  }

  Future<bool> startQuiz(String quizType) async {
    isLoading.value = true;

    try {
      String category;
      switch (quizType) {
        case 'daily':
          category = 'Harian';
          break;
        case 'weekly':
          category = 'Mingguan';
          break;
        case 'monthly':
          category = 'Bulanan';
          break;
        default:
          category = 'Harian';
      }

      if (quizzes.isEmpty) {
        debugPrint('Quizzes not loaded yet, loading now...');
        await loadQuizzes();
      }

      final quiz = getQuizByCategory(category);
      if (quiz == null) {
        debugPrint('Quiz not found for category: $category');
        debugPrint(
          'Available quizzes: ${quizzes.map((q) => q.category).join(", ")}',
        );
        throw Exception('Kuis $category tidak ditemukan');
      }

      final completed = await isQuizCompleted(quiz.idQuiz);
      if (completed) {
        Get.snackbar(
          'Kuis Sudah Selesai',
          'Anda sudah menyelesaikan kuis ini. Silakan coba kuis lainnya!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      debugPrint('Loading quiz with questions for ID: ${quiz.idQuiz}');

      final token = await _authController.getToken();
      final fullQuiz = await Quiz.fetchQuizById(quiz.idQuiz, token: token);

      currentQuiz.value = fullQuiz;

      final questions = fullQuiz.questions ?? [];
      if (questions.isEmpty) {
        throw Exception('Tidak ada pertanyaan untuk kuis ini');
      }

      debugPrint('Loaded ${questions.length} questions');
      currentQuestions.value = questions;
      currentQuestionIndex.value = 0;
      userAnswers.value = List.filled(questions.length, null);
      totalScore.value = 0;

      return true;
    } catch (e) {
      debugPrint('Error starting quiz: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat pertanyaan kuis: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(int answerIndex) {
    if (currentQuestionIndex.value < userAnswers.length) {
      userAnswers[currentQuestionIndex.value] = answerIndex;
    }
  }

  bool goToNextQuestion() {
    if (currentQuestionIndex.value < currentQuestions.length - 1) {
      currentQuestionIndex.value++;
      return true;
    }
    return false;
  }

  bool goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      return true;
    }
    return false;
  }

  int calculateScore() {
    int score = 0;

    for (int i = 0; i < currentQuestions.length; i++) {
      final answerIndex = userAnswers[i];
      if (answerIndex != null) {
        final question = currentQuestions[i];
        if (answerIndex < question.answers.length) {
          final answer = question.answers[answerIndex];
          if (answer.isCorrect) {
            score += question.points;
          }
        }
      }
    }

    return score;
  }

  int getMaxScore() {
    return currentQuestions.fold(0, (sum, q) => sum + q.points);
  }

  Future<bool> submitQuiz() async {
    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      int accumulatedScore = 0;

      for (int i = 0; i < currentQuestions.length; i++) {
        final answerIndex = userAnswers[i];
        if (answerIndex != null) {
          final question = currentQuestions[i];
          final answer = question.answers[answerIndex];

          try {
            final result = await Quiz.submitAnswer(
              question.idQuestion,
              answer.idAnswer,
              token: token,
            );

            final pointsEarned = result['points_earned'] ?? 0;
            accumulatedScore += pointsEarned as int;
          } catch (e) {
            debugPrint('Error submitting answer for question ${i + 1}: $e');
          }
        }
      }

      totalScore.value = accumulatedScore;

      if (currentQuiz.value != null) {
        quizCompletionStatus[currentQuiz.value!.idQuiz] = true;
      }

      return true;
    } catch (e) {
      debugPrint('Error submitting quiz: $e');
      Get.snackbar(
        'Error',
        'Gagal mengirim hasil kuis: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void resetQuiz() {
    currentQuiz.value = null;
    currentQuestions.clear();
    currentQuestionIndex.value = 0;
    userAnswers.clear();
    totalScore.value = 0;
  }
}
