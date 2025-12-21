import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/mission_controller.dart';
import '../controller/quiz_controller.dart';
import '../core/navigation_route.dart';
import '../core/styles/app_color.dart';
import '../model/articles.dart';
import '../model/daily_points.dart';
import 'article_list_screen.dart';
import 'article_screen.dart';
import 'widgets/active_mission_widget.dart';
import 'widgets/article_widget.dart';
import 'widgets/mission_detail_bottom_sheet.dart';
import 'widgets/quiz_card_home_widget.dart';
import 'widgets/weekly_chart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'Week';
  final AuthController _authController = Get.find<AuthController>();
  late final MissionController _missionController;
  late final QuizController _quizController;
  List<Article> _articles = [];
  bool _isLoadingArticles = false;
  int _todayPoints = 0;
  bool _isLoadingPoints = false;
  List<ChartData> _weeklyData = [];

  final List<ChartData> weeklyData = [
    ChartData(value: 60, label: '24'),
    ChartData(value: 40, label: '25'),
    ChartData(value: 70, label: '26'),
    ChartData(value: 85, label: '27', isHighlighted: true),
    ChartData(value: 45, label: '28'),
    ChartData(value: 75, label: '29'),
    ChartData(value: 100, label: '30', isHighlighted: true),
  ];

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<MissionController>()) {
      _missionController = Get.find<MissionController>();
    } else {
      _missionController = Get.put(MissionController());
    }
    if (Get.isRegistered<QuizController>()) {
      _quizController = Get.find<QuizController>();
    } else {
      _quizController = Get.put(QuizController());
    }
    _loadArticles();
    _loadTodayPoints();
    _loadWeeklyPoints();
    _loadQuizCompletionStatus();
  }

  Future<void> _loadQuizCompletionStatus() async {
    for (var quiz in _quizController.quizzes) {
      await _quizController.isQuizCompleted(quiz.idQuiz);
    }
  }

  Future<void> _loadTodayPoints() async {
    setState(() {
      _isLoadingPoints = true;
    });

    try {
      final token = await _authController.getToken();
      final points = await DailyPoint.fetchDailyPoints(token: token, days: 1);

      if (points.isNotEmpty) {
        setState(() {
          _todayPoints = points.first.totalPoints;
          _isLoadingPoints = false;
        });
      } else {
        setState(() {
          _todayPoints = 0;
          _isLoadingPoints = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading today points: $e');
      setState(() {
        _todayPoints = 0;
        _isLoadingPoints = false;
      });
    }
  }

  Future<void> _loadWeeklyPoints() async {
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

      setState(() {
        _weeklyData = points.map((point) {
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
      });
    } catch (e) {
      debugPrint('Error loading weekly points: $e');
      setState(() {
        _weeklyData = [];
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([
      _missionController.refreshMissions(),
      _loadArticles(),
      _loadTodayPoints(),
      _loadWeeklyPoints(),
      _loadQuizCompletionStatus(),
    ]);
  }

  Future<void> refreshMissionsOnly() async {
    await _missionController.refreshMissions();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoadingArticles = true;
    });

    try {
      final token = await _authController.getToken();
      final articles = await ArticlesData.getArticles(token: token);

      articles.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));

      setState(() {
        _articles = articles;
        _isLoadingArticles = false;
      });
    } catch (e) {
      debugPrint('Error loading articles: $e');
      setState(() {
        _articles = [];
        _isLoadingArticles = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary.color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Image.asset(
                                      'assets/CloudVector.png',
                                      height: 80,
                                      opacity: const AlwaysStoppedAnimation(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Image.asset(
                                          'assets/logotype.png',
                                          height: 32,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            NavigationRoute.profileRoute.path,
                                          );
                                        },
                                        child: Obx(() {
                                          final profileImageUrl =
                                              _authController
                                                  .currentUser
                                                  .value
                                                  ?.profileImageUrl;
                                          return CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color(0xFFD9E3E8),
                                            backgroundImage:
                                                profileImageUrl != null
                                                ? NetworkImage(profileImageUrl)
                                                : const AssetImage(
                                                        'assets/profile.png',
                                                      )
                                                      as ImageProvider,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 160),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 160),
                                WeeklyChartWidget(
                                  data: _weeklyData.isNotEmpty
                                      ? _weeklyData
                                      : weeklyData,
                                ),
                                const SizedBox(height: 40),
                                // Active Missions Section
                                Obx(() {
                                  if (_missionController
                                      .activeMissions
                                      .isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          'Misi Aktif',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 140,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          itemCount: _missionController
                                              .activeMissions
                                              .length,
                                          itemBuilder: (context, index) {
                                            final mission = _missionController
                                                .activeMissions[index];
                                            return ActiveMissionWidget(
                                              mission: mission,
                                              onTap: () {
                                                MissionDetailBottomSheet.show(
                                                  context,
                                                  mission,
                                                  _refreshData,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  );
                                }),
                                // Quiz Section
                                Obx(() {
                                  final quizzes = _quizController.quizzes
                                      .take(3)
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          'Kuis',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 140,
                                        child: quizzes.isEmpty
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Text(
                                                    'Tidak ada kuis tersedia',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                children: quizzes.map((quiz) {
                                                  String quizType;
                                                  switch (quiz.category) {
                                                    case 'Harian':
                                                      quizType = 'daily';
                                                      break;
                                                    case 'Mingguan':
                                                      quizType = 'weekly';
                                                      break;
                                                    case 'Bulanan':
                                                      quizType = 'monthly';
                                                      break;
                                                    default:
                                                      quizType = 'daily';
                                                  }

                                                  final isCompleted =
                                                      _quizController
                                                          .quizCompletionStatus[quiz
                                                          .idQuiz] ??
                                                      false;

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 12,
                                                        ),
                                                    child: QuizCardHomeWidget(
                                                      title: quiz.title,
                                                      points:
                                                          '${quiz.totalPoints} Pts',
                                                      isCompleted: isCompleted,
                                                      onTap: isCompleted
                                                          ? () {
                                                              Get.snackbar(
                                                                'Kuis Sudah Selesai',
                                                                'Kamu sudah menyelesaikan kuis ini!',
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                margin:
                                                                    const EdgeInsets.all(
                                                                      16,
                                                                    ),
                                                              );
                                                            }
                                                          : () {
                                                              Get.toNamed(
                                                                NavigationRoute
                                                                    .quizQuestion
                                                                    .path,
                                                                arguments:
                                                                    quizType,
                                                              );
                                                            },
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                      ),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 40),
                                // Article Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        'Artikel',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: _isLoadingArticles
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          : _articles.isEmpty
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Text(
                                                  'Tidak ada artikel tersedia',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                ..._articles.take(3).map((
                                                  article,
                                                ) {
                                                  return ArticleWidget(
                                                    imageUrl: article.imageUrl,
                                                    title: article.title,
                                                    author: article.author,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ArticleScreen(
                                                                articleId:
                                                                    article.id,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                                const SizedBox(height: 8),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ArticleListScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Selengkapnya',
                                                      style: TextStyle(
                                                        color: AppColor
                                                            .primary
                                                            .color,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 100,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.grey[50]!],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AppColor.primary.color.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 4),
                                spreadRadius: -5,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Poin Kamu Hari Ini!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: _isLoadingPoints
                                    ? SizedBox(
                                        width: 160,
                                        height: 160,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.primary.color,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.primary.color
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Outer decorative ring
                                            Container(
                                              width: 160,
                                              height: 160,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColor.primary.color
                                                      .withValues(alpha: 0.1),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            // Progress indicator
                                            SizedBox(
                                              width: 140,
                                              height: 140,
                                              child: CircularProgressIndicator(
                                                value: _todayPoints / 100,
                                                strokeWidth: 12,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                strokeCap: StrokeCap.round,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      AppColor.primary.color,
                                                    ),
                                              ),
                                            ),
                                            // Inner circle with gradient
                                            Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.white,
                                                    Colors.grey[50]!,
                                                  ],
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '$_todayPoints',
                                                    style: TextStyle(
                                                      fontSize: 44,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColor
                                                          .primary
                                                          .color,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '/100 Pts',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _todayPoints >= 100
                                    ? 'Target Tercapai! 🎉'
                                    : _todayPoints > 0
                                    ? 'Kerja Bagus! Terus Lanjutkan!'
                                    : 'Mulai Kumpulkan Poin Hari Ini!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
