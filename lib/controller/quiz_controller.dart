import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_service.dart';
import '../core/cooldown_helper.dart';
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
  final RxBool isDummyQuiz = false.obs;

  final RxMap<int, bool> quizCompletionStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    isLoading.value = true;

    quizCompletionStatus.clear();

    try {
      final token = await _authController.getToken();
      final fetchedQuizzes = await Quiz.fetchQuizzes(token: token);
      quizzes.value = fetchedQuizzes;

      await refreshCompletionStatuses();
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

  Future<void> refreshCompletionStatuses() async {
    if (quizzes.isEmpty) return;

    try {
      final token = await _authController.getToken();
      if (token == null) return;

      final response = await ApiService.get('/me/sessions', token: token);
      if (response.statusCode != 200) return;

      final jsonData = json.decode(response.body);
      final List<dynamic> allSessions = jsonData['data'] ?? [];

      final Map<String, bool> categoryIsCompleted = {};
      final Map<int, bool> individualCompletion = {};

      for (final quiz in quizzes) {
        final cat = CooldownHelper.parseCategory(quiz.category);
        final window = CooldownHelper.getWindow(cat);

        final List<dynamic> periodSessions;
        if (window != null) {
          periodSessions = allSessions.where((s) {
            final raw = s['start_time'] as String?;
            if (raw == null) return false;
            final t = DateTime.tryParse(raw)?.toUtc();
            return t != null && window.contains(t);
          }).toList();
        } else {
          periodSessions = allSessions;
        }

        final newSchema = periodSessions
            .where(
              (s) => s['session_type'] == 'quiz' && s['id_quiz'] == quiz.idQuiz,
            )
            .toList();

        bool completed;
        if (newSchema.isNotEmpty) {
          final answered = newSchema
              .map((s) => s['id_question'] as int?)
              .whereType<int>()
              .toSet();
          final count = answered.isNotEmpty
              ? answered.length
              : newSchema.length;
          completed = count >= quiz.questionCount;
        } else {
          final answered = periodSessions
              .where((s) => s['answer']?['question']?['id_quiz'] == quiz.idQuiz)
              .map((s) => s['answer']?['question']?['id_question'] as int?)
              .whereType<int>()
              .toSet();
          completed = answered.length >= quiz.questionCount;
        }

        individualCompletion[quiz.idQuiz] = completed;
        if (completed) {
          categoryIsCompleted[quiz.category] = true;
        }
      }

      for (final quiz in quizzes) {
        quizCompletionStatus[quiz.idQuiz] =
            (categoryIsCompleted[quiz.category] == true) ||
            (individualCompletion[quiz.idQuiz] == true);
      }
    } catch (e) {
      debugPrint('Error refreshing completion statuses: $e');
    }
  }

  Future<bool> isQuizCompleted(int quizId) async {
    if (quizCompletionStatus.containsKey(quizId)) {
      return quizCompletionStatus[quizId]!;
    }

    await refreshCompletionStatuses();
    return quizCompletionStatus[quizId] ?? false;
  }

  Quiz? getQuizByCategory(String category) {
    try {
      return quizzes.firstWhere(
        (quiz) => quiz.category.toLowerCase() == category.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> startQuiz(String quizType, {int? quizId}) async {
    isLoading.value = true;

    try {
      final category = _quizTypeToCategory(quizType);

      if (quizzes.isEmpty) {
        debugPrint('Quizzes not loaded yet, loading now…');
        await loadQuizzes();
      }

      Quiz? quiz;
      if (quizId != null) {
        try {
          quiz = quizzes.firstWhere((q) => q.idQuiz == quizId);
        } catch (_) {}
      }
      quiz ??= getQuizByCategory(category);
      if (quiz == null) {
        debugPrint('Quiz not found for category: $category');
        debugPrint(
          'Available quizzes: ${quizzes.map((q) => q.category).join(", ")}',
        );
        throw Exception('Kuis $category tidak ditemukan');
      }

      final completed = await isQuizCompleted(quiz.idQuiz);
      if (completed) {
        final quizCategory = CooldownHelper.parseCategory(quiz.category);
        final nextLabel =
            CooldownHelper.getNextAvailableLabel(quizCategory) ??
            'Coba lagi nanti';

        Get.snackbar(
          CooldownHelper.getLimitSnackbarTitle(quizCategory),
          nextLabel,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
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

      questions.sort((a, b) => a.order.compareTo(b.order));

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

  void startDummyQuiz() {
    isDummyQuiz.value = true;
    currentQuiz.value = Quiz(
      idQuiz: 0,
      title: 'Kuis Demo Lingkungan',
      category: 'Demo',
      totalPoints: 50,
      idCreator: 0,
      createdAt: DateTime.now(),
      questionCount: 5,
    );

    currentQuestions.value = [
      Question(
        idQuestion: 1,
        idQuiz: 0,
        content: 'Apa gas rumah kaca utama yang dihasilkan dari pembakaran bahan bakar fosil?',
        points: 10,
        order: 1,
        answers: [
          Answer(idAnswer: 1, idQuestion: 1, content: 'Karbon Dioksida (CO₂)', points: 10),
          Answer(idAnswer: 2, idQuestion: 1, content: 'Oksigen (O₂)', points: 0),
          Answer(idAnswer: 3, idQuestion: 1, content: 'Nitrogen (N₂)', points: 0),
          Answer(idAnswer: 4, idQuestion: 1, content: 'Hidrogen (H₂)', points: 0),
        ],
      ),
      Question(
        idQuestion: 2,
        idQuiz: 0,
        content: 'Apa cara paling efektif untuk mengurangi jejak karbon pribadi?',
        points: 10,
        order: 2,
        answers: [
          Answer(idAnswer: 5, idQuestion: 2, content: 'Mengurangi konsumsi daging merah', points: 8),
          Answer(idAnswer: 6, idQuestion: 2, content: 'Menggunakan transportasi umum', points: 10),
          Answer(idAnswer: 7, idQuestion: 2, content: 'Membeli produk baru setiap bulan', points: 0),
          Answer(idAnswer: 8, idQuestion: 2, content: 'Menggunakan pendingin ruangan terus menerus', points: 0),
        ],
      ),
      Question(
        idQuestion: 3,
        idQuiz: 0,
        content: 'Berapa lama waktu yang dibutuhkan sampah plastik untuk terurai di alam?',
        points: 10,
        order: 3,
        answers: [
          Answer(idAnswer: 9, idQuestion: 3, content: '1-5 tahun', points: 0),
          Answer(idAnswer: 10, idQuestion: 3, content: '10-20 tahun', points: 0),
          Answer(idAnswer: 11, idQuestion: 3, content: '100-500 tahun', points: 10),
          Answer(idAnswer: 12, idQuestion: 3, content: '1000+ tahun', points: 5),
        ],
      ),
      Question(
        idQuestion: 4,
        idQuiz: 0,
        content: 'Apa sumber energi terbarukan yang paling banyak digunakan di dunia?',
        points: 10,
        order: 4,
        answers: [
          Answer(idAnswer: 13, idQuestion: 4, content: 'Tenaga Surya', points: 8),
          Answer(idAnswer: 14, idQuestion: 4, content: 'Tenaga Angin', points: 5),
          Answer(idAnswer: 15, idQuestion: 4, content: 'Tenaga Air (Hidroelektrik)', points: 10),
          Answer(idAnswer: 16, idQuestion: 4, content: 'Tenaga Panas Bumi', points: 3),
        ],
      ),
      Question(
        idQuestion: 5,
        idQuiz: 0,
        content: 'Apa yang dimaksud dengan "carbon footprint"?',
        points: 10,
        order: 5,
        answers: [
          Answer(idAnswer: 17, idQuestion: 5, content: 'Jumlah pohon yang kita tanam', points: 0),
          Answer(idAnswer: 18, idQuestion: 5, content: 'Jejak kaki di atas karbon', points: 0),
          Answer(idAnswer: 19, idQuestion: 5, content: 'Total emisi CO₂ yang dihasilkan oleh aktivitas kita', points: 10),
          Answer(idAnswer: 20, idQuestion: 5, content: 'Jenis bahan bakar yang kita gunakan', points: 3),
        ],
      ),
    ];

    currentQuestionIndex.value = 0;
    userAnswers.value = List.filled(currentQuestions.length, null);
    totalScore.value = 0;
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
      if (answerIndex != null &&
          answerIndex < currentQuestions[i].answers.length) {
        score += currentQuestions[i].answers[answerIndex].points;
      }
    }
    return score;
  }

  int getMaxScore() {
    int maxScore = 0;
    for (final question in currentQuestions) {
      if (question.answers.isNotEmpty) {
        final maxPts = question.answers
            .map((a) => a.points)
            .reduce((a, b) => a > b ? a : b);
        maxScore += maxPts;
      }
    }
    return maxScore;
  }

  Future<bool> submitQuiz() async {
    if (isDummyQuiz.value) {
      int score = 0;
      for (int i = 0; i < currentQuestions.length; i++) {
        final answerIndex = userAnswers[i];
        if (answerIndex != null && answerIndex < currentQuestions[i].answers.length) {
          score += currentQuestions[i].answers[answerIndex].points;
        }
      }
      totalScore.value = score;
      return true;
    }

    try {
      final token = await _authController.getToken();
      if (token == null) throw Exception('Please login first');

      int accumulatedScore = 0;
      bool limitExceeded = false;
      String limitMessage = '';

      for (int i = 0; i < currentQuestions.length; i++) {
        final answerIndex = userAnswers[i];
        if (answerIndex == null) continue;

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
        } on QuizLimitExceededException catch (e) {
          limitExceeded = true;
          limitMessage = e.message;
          debugPrint('Quiz limit exceeded for question ${i + 1}: $e');
          break;
        } catch (e) {
          debugPrint('Error submitting answer for question ${i + 1}: $e');
        }
      }

      totalScore.value = accumulatedScore;

      if (currentQuiz.value != null) {
        quizCompletionStatus[currentQuiz.value!.idQuiz] = true;
      }

      if (limitExceeded) {
        final cat = CooldownHelper.parseCategory(
          currentQuiz.value?.category ?? '',
        );
        final nextLabel =
            CooldownHelper.getNextAvailableLabel(cat) ?? 'Coba lagi nanti';

        Get.snackbar(
          CooldownHelper.getLimitSnackbarTitle(cat),
          '$limitMessage\n$nextLabel',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
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

  static String _quizTypeToCategory(String quizType) {
    switch (quizType) {
      case 'daily':
        return 'Harian';
      case 'weekly':
        return 'Mingguan';
      case 'monthly':
        return 'Bulanan';
      default:
        return 'Harian';
    }
  }
}
