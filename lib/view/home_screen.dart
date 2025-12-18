import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/mission_controller.dart';
import '../core/navigation_route.dart';
import '../core/styles/app_color.dart';
import '../model/articles.dart';
import 'article_screen.dart';
import 'widgets/active_mission_widget.dart';
import 'widgets/article_widget.dart';
import 'widgets/mission_detail_bottom_sheet.dart';
import 'widgets/quiz_card_home_widget.dart';
import 'widgets/weekly_chart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'Week';
  final AuthController _authController = Get.find<AuthController>();
  late final MissionController _missionController;
  List<Article> _articles = [];
  bool _isLoadingArticles = false;

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
    // Initialize or get MissionController
    if (Get.isRegistered<MissionController>()) {
      _missionController = Get.find<MissionController>();
    } else {
      _missionController = Get.put(MissionController());
    }
    _loadArticles();
  }

  Future<void> _refreshData() async {
    await Future.wait([_missionController.refreshMissions(), _loadArticles()]);
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoadingArticles = true;
    });

    try {
      final token = await _authController.getToken();
      final articles = await ArticlesData.getArticles(token: token);
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
                                const SizedBox(height: 144),
                                WeeklyChartWidget(data: weeklyData),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        children: [
                                          QuizCardHomeWidget(
                                            title: 'Kuis Harian',
                                            points: '10 Pts',
                                            onTap: () {
                                              Get.toNamed(
                                                NavigationRoute
                                                    .quizQuestion
                                                    .path,
                                                arguments: 'daily',
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          QuizCardHomeWidget(
                                            title: 'Kuis Mingguan',
                                            points: '50 Pts',
                                            onTap: () {
                                              Get.toNamed(
                                                NavigationRoute
                                                    .quizQuestion
                                                    .path,
                                                arguments: 'weekly',
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          QuizCardHomeWidget(
                                            title: 'Kuis Bulanan',
                                            points: '100 Pts',
                                            onTap: () {
                                              Get.toNamed(
                                                NavigationRoute
                                                    .quizQuestion
                                                    .path,
                                                arguments: 'monthly',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                              children: _articles.take(3).map((
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
                                              }).toList(),
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
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Jejak karbon Anda hari ini!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        height: 140,
                                        child: CircularProgressIndicator(
                                          value: 0.75,
                                          strokeWidth: 8,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation(
                                            AppColor.primary.color.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CO',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '2',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '148',
                                                style: TextStyle(
                                                  fontSize: 36,
                                                  color: AppColor.primary.color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Text(
                                                  'kg',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        AppColor.primary.color,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Hari ini',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Kerja Bagus!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
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
