import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/quiz.dart';
import 'auth_controller.dart';

class QuizController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Reactive state
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

  /// Load all quizzes
  Future<void> loadQuizzes() async {
    isLoading.value = true;

    try {
      final token = await _authController.getToken();
      final fetchedQuizzes = await Quiz.fetchQuizzes(token: token);

      quizzes.value = fetchedQuizzes;
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
      // Show error to user
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

  /// Get quiz by category (Harian, Mingguan, Bulanan)
  Quiz? getQuizByCategory(String category) {
    try {
      return quizzes.firstWhere(
        (quiz) => quiz.category.toLowerCase() == category.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if quiz is completed
  Future<bool> isQuizCompleted(int quizId) async {
    // Check cache first
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

  /// Start a quiz by loading its questions
  Future<bool> startQuiz(String quizType) async {
    isLoading.value = true;

    try {
      // Map quiz type to category
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

      // Ensure quizzes are loaded
      if (quizzes.isEmpty) {
        debugPrint('Quizzes not loaded yet, loading now...');
        await loadQuizzes();
      }

      // Find quiz by category
      final quiz = getQuizByCategory(category);
      if (quiz == null) {
        debugPrint('Quiz not found for category: $category');
        debugPrint(
          'Available quizzes: ${quizzes.map((q) => q.category).join(", ")}',
        );
        throw Exception('Kuis $category tidak ditemukan');
      }

      // Check if quiz is already completed
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

      // Fetch full quiz with questions from API
      final token = await _authController.getToken();
      final fullQuiz = await Quiz.fetchQuizById(quiz.idQuiz, token: token);

      currentQuiz.value = fullQuiz;

      // Extract questions from the quiz
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

  /// Select an answer for current question
  void selectAnswer(int answerIndex) {
    if (currentQuestionIndex.value < userAnswers.length) {
      userAnswers[currentQuestionIndex.value] = answerIndex;
    }
  }

  /// Go to next question
  bool goToNextQuestion() {
    if (currentQuestionIndex.value < currentQuestions.length - 1) {
      currentQuestionIndex.value++;
      return true;
    }
    return false;
  }

  /// Go to previous question
  bool goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      return true;
    }
    return false;
  }

  /// Calculate score based on correct answers
  int calculateScore() {
    int score = 0;

    for (int i = 0; i < currentQuestions.length; i++) {
      final answerIndex = userAnswers[i];
      if (answerIndex != null) {
        final question = currentQuestions[i];
        if (answerIndex < question.answers.length) {
          final answer = question.answers[answerIndex];
          // Award points if answer is correct
          if (answer.isCorrect) {
            score += question.points;
          }
        }
      }
    }

    return score;
  }

  /// Get maximum possible score
  int getMaxScore() {
    return currentQuestions.fold(0, (sum, q) => sum + q.points);
  }

  /// Submit quiz by sending each answer to API
  Future<bool> submitQuiz() async {
    try {
      final token = await _authController.getToken();
      if (token == null) {
        throw Exception('Please login first');
      }

      int accumulatedScore = 0;

      // Submit each answer to the API
      for (int i = 0; i < currentQuestions.length; i++) {
        final answerIndex = userAnswers[i];
        if (answerIndex != null) {
          final question = currentQuestions[i];
          final answer = question.answers[answerIndex];

          try {
            // Submit answer - backend auto-creates session
            final result = await Quiz.submitAnswer(
              question.idQuestion,
              answer.idAnswer,
              token: token,
            );

            // Accumulate points from response
            final pointsEarned = result['points_earned'] ?? 0;
            accumulatedScore += pointsEarned as int;

            debugPrint(
              'Question ${i + 1}: ${result['is_correct'] ? 'Correct' : 'Wrong'} - Earned $pointsEarned points',
            );
          } catch (e) {
            debugPrint('Error submitting answer for question ${i + 1}: $e');
            // Continue with other answers even if one fails
          }
        }
      }

      totalScore.value = accumulatedScore;
      debugPrint('Total score: $accumulatedScore');

      // Mark quiz as completed
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

  /// Reset quiz state
  void resetQuiz() {
    currentQuiz.value = null;
    currentQuestions.clear();
    currentQuestionIndex.value = 0;
    userAnswers.clear();
    totalScore.value = 0;
  }
}
