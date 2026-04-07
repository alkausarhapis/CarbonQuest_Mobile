import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/home_controller.dart';
import '../controller/mission_controller.dart';
import '../controller/quiz_controller.dart';
import '../core/navigation_route.dart';
import '../core/cooldown_helper.dart';
import '../core/styles/app_color.dart';
import 'article_list_screen.dart';
import 'article_screen.dart';
import 'widgets/active_mission_widget.dart';
import 'widgets/article_widget.dart';
import 'widgets/mission_detail_bottom_sheet.dart';
import 'widgets/quiz_card_home_widget.dart';
import 'widgets/weekly_chart_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    final MissionController missionController =
        Get.isRegistered<MissionController>()
        ? Get.find<MissionController>()
        : Get.put(MissionController());

    final QuizController quizController = Get.isRegistered<QuizController>()
        ? Get.find<QuizController>()
        : Get.put(QuizController());

    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColor.primary.color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: controller.refreshData,
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
                                          final profileImageUrl = authController
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
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 160),
                                  WeeklyChartWidget(
                                    data: controller.weeklyData.isNotEmpty
                                        ? controller.weeklyData
                                        : controller.getDefaultWeeklyData(),
                                  ),
                                  const SizedBox(height: 40),
                                  if (missionController
                                      .activeMissions
                                      .isNotEmpty)
                                    Column(
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
                                            itemCount: missionController
                                                .activeMissions
                                                .length,
                                            itemBuilder: (context, index) {
                                              final mission = missionController
                                                  .activeMissions[index];
                                              return ActiveMissionWidget(
                                                mission: mission,
                                                onTap: () {
                                                  MissionDetailBottomSheet.show(
                                                    context,
                                                    mission,
                                                    controller.refreshData,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  Column(
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
                                        child: quizController.quizzes.isEmpty
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
                                                children: quizController.quizzes.take(3).map((
                                                  quiz,
                                                ) {
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
                                                      quizController
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
                                                      category: quiz.category,
                                                      isCompleted: isCompleted,
                                                      onTap: isCompleted
                                                          ? () {
                                                              final cat =
                                                                  CooldownHelper.parseCategory(
                                                                    quiz.category,
                                                                  );
                                                              final nextLabel =
                                                                  CooldownHelper.getNextAvailableLabel(
                                                                    cat,
                                                                  ) ??
                                                                  'Coba lagi nanti';
                                                              Get.snackbar(
                                                                CooldownHelper.getLimitSnackbarTitle(
                                                                  cat,
                                                                ),
                                                                nextLabel,
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
                                                                duration:
                                                                    const Duration(
                                                                      seconds:
                                                                          4,
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
                                  ),
                                  const SizedBox(height: 40),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        child:
                                            controller.isLoadingArticles.value
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : controller.articles.isEmpty
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
                                                  ...controller.articles.take(3).map((
                                                    article,
                                                  ) {
                                                    return ArticleWidget(
                                                      imageUrl:
                                                          article.imageUrl,
                                                      title: article.title,
                                                      author: article.author,
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ArticleScreen(
                                                                  articleId:
                                                                      article
                                                                          .id,
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
                          ),
                        ],
                      ),
                      Positioned(
                        top: 100,
                        left: 20,
                        right: 20,
                        child: Obx(
                          () => Container(
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
                                  child: controller.isLoadingPoints.value
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
                                              Container(
                                                width: 160,
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColor
                                                        .primary
                                                        .color
                                                        .withValues(alpha: 0.1),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 140,
                                                height: 140,
                                                child: CircularProgressIndicator(
                                                  value:
                                                      controller
                                                          .todayPoints
                                                          .value /
                                                      100,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${controller.todayPoints.value}',
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
                                  controller.todayPoints.value >= 100
                                      ? 'Target Tercapai! 🎉'
                                      : controller.todayPoints.value > 0
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
