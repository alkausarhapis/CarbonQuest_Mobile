import 'package:get/get.dart';

import '../model/articles.dart';
import '../model/daily_points.dart';
import '../view/widgets/weekly_chart_widget.dart';
import 'auth_controller.dart';
import 'mission_controller.dart';
import 'quiz_controller.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final MissionController _missionController = Get.find<MissionController>();
  final QuizController _quizController = Get.find<QuizController>();

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoadingArticles = false.obs;
  final RxInt todayPoints = 0.obs;
  final RxBool isLoadingPoints = false.obs;
  final RxList<ChartData> weeklyData = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadArticles(),
      loadTodayPoints(),
      loadWeeklyPoints(),
      loadQuizCompletionStatus(),
    ]);
  }

  Future<void> loadQuizCompletionStatus() async {
    for (var quiz in _quizController.quizzes) {
      await _quizController.isQuizCompleted(quiz.idQuiz);
    }
  }

  Future<void> loadTodayPoints() async {
    isLoadingPoints.value = true;

    try {
      final token = await _authController.getToken();
      final points = await DailyPoint.fetchDailyPoints(token: token, days: 1);

      if (points.isNotEmpty) {
        todayPoints.value = points.first.totalPoints;
      } else {
        todayPoints.value = 0;
      }
    } catch (e) {
      todayPoints.value = 0;
    } finally {
      isLoadingPoints.value = false;
    }
  }

  Future<void> loadWeeklyPoints() async {
    try {
      final token = await _authController.getToken();
      final points = await DailyPoint.fetchDailyPoints(token: token, days: 7);

      final sortedPoints = [...points];
      sortedPoints.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      final uniqueScores =
          sortedPoints
              .map((p) => p.totalPoints)
              .where((score) => score > 0)
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a));
      final topTwoScores = uniqueScores.take(2).toSet();

      weeklyData.value = points.map((point) {
        String day;
        try {
          final date = DateTime.parse(point.week).add(Duration(days: 1));
          day = date.day.toString();
        } catch (e) {
          day = point.week.split('-').last;
        }
        return ChartData(
          value: point.totalPoints.toDouble(),
          label: day,
          isHighlighted: topTwoScores.contains(point.totalPoints),
        );
      }).toList();
    } catch (e) {
      weeklyData.value = [];
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      _missionController.refreshMissions(),
      loadArticles(),
      loadTodayPoints(),
      loadWeeklyPoints(),
      loadQuizCompletionStatus(),
    ]);
  }

  Future<void> refreshMissionsOnly() async {
    await _missionController.refreshMissions();
  }

  Future<void> loadArticles() async {
    isLoadingArticles.value = true;

    try {
      final token = await _authController.getToken();
      final fetchedArticles = await ArticlesData.getArticles(token: token);

      fetchedArticles.sort(
        (a, b) => b.publishedDate.compareTo(a.publishedDate),
      );

      articles.value = fetchedArticles;
    } catch (e) {
      articles.value = [];
    } finally {
      isLoadingArticles.value = false;
    }
  }

  List<ChartData> getDefaultWeeklyData() {
    return [
      ChartData(value: 60, label: '24'),
      ChartData(value: 40, label: '25'),
      ChartData(value: 70, label: '26'),
      ChartData(value: 85, label: '27', isHighlighted: true),
      ChartData(value: 45, label: '28'),
      ChartData(value: 75, label: '29'),
      ChartData(value: 100, label: '30', isHighlighted: true),
    ];
  }
}
