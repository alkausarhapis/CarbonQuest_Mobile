import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../core/styles/app_color.dart';
import 'widgets/article_widget.dart';
import 'widgets/category_icon_widget.dart';
import 'widgets/mission_card_widget.dart';
import 'widgets/quiz_card_home_widget.dart';
import 'widgets/weekly_chart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'Week';

  final List<ChartData> weeklyData = [
    ChartData(value: 60, label: '24'),
    ChartData(value: 40, label: '25'),
    ChartData(value: 70, label: '26'),
    ChartData(value: 85, label: '27', isHighlighted: true),
    ChartData(value: 45, label: '28'),
    ChartData(value: 75, label: '29'),
    ChartData(value: 90, label: '30', isHighlighted: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary.color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
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
                                    opacity: const AlwaysStoppedAnimation(0.5),
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
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey[800],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 160),
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 120),
                              const SizedBox(height: 24),
                              WeeklyChartWidget(data: weeklyData),
                              const SizedBox(height: 40),
                              // Category Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Kategori',
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
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 16,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        CategoryIconWidget(
                                          icon: IconsaxPlusBold.task_square,
                                          label: 'Misi',
                                          onTap: () {},
                                        ),
                                        CategoryIconWidget(
                                          icon: IconsaxPlusBold.note_2,
                                          label: 'Kuis',
                                          onTap: () {},
                                        ),
                                        CategoryIconWidget(
                                          icon: IconsaxPlusBold.crown_1,
                                          label: 'Peringkat',
                                          onTap: () {},
                                        ),
                                        CategoryIconWidget(
                                          icon: IconsaxPlusBold.refresh_2,
                                          label: 'Riwayat',
                                          onTap: () {},
                                        ),
                                        CategoryIconWidget(
                                          icon: IconsaxPlusBold.book_1,
                                          label: 'Artikel',
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
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
                                          onTap: () {},
                                        ),
                                        const SizedBox(width: 12),
                                        QuizCardHomeWidget(
                                          title: 'Kuis Mingguan',
                                          points: '50 Pts',
                                          onTap: () {},
                                        ),
                                        const SizedBox(width: 12),
                                        QuizCardHomeWidget(
                                          title: 'Kuis Bulanan',
                                          points: '100 Pts',
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              // Missions Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Misi',
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
                                    child: Column(
                                      children: [
                                        MissionCardWidget(
                                          title: 'Tanam Pohon',
                                          description:
                                              'Tanam setidaknya satu pohon di lingkungan Anda, baik di halaman rumah atau di taman umum lainnya',
                                          points: '07 Pts',
                                          backgroundColor: const Color(
                                            0xFFD4F1F4,
                                          ),
                                          iconBackgroundColor: const Color(
                                            0xFF75E6DA,
                                          ),
                                          icon: IconsaxPlusBold.tree,
                                          onTap: () {},
                                        ),
                                        MissionCardWidget(
                                          title: 'Lewati Makan Daging Merah',
                                          description:
                                              'Cobalah untuk menggantikan daging merah dalam makanan Anda dengan alternatif nabati',
                                          points: '50 Pts',
                                          backgroundColor: const Color(
                                            0xFFFEE5D7,
                                          ),
                                          iconBackgroundColor: const Color(
                                            0xFFFF9A76,
                                          ),
                                          icon: IconsaxPlusBold.cake,
                                          onTap: () {},
                                        ),
                                        MissionCardWidget(
                                          title:
                                              'Bersepeda ke Kantor Minggu Ini',
                                          description:
                                              'Bersepeda ke kantor atau sekolah untuk mengurangi jejak karbon Anda',
                                          points: '65 Pts',
                                          backgroundColor: const Color(
                                            0xFFE8E3FF,
                                          ),
                                          iconBackgroundColor: const Color(
                                            0xFFB8A4FF,
                                          ),
                                          icon: IconsaxPlusBold.car,
                                          onTap: () {},
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
                                    child: Column(
                                      children: [
                                        ArticleWidget(
                                          imageUrl: '',
                                          title:
                                              'Merawat adalah pemasaran baru',
                                          author: 'Kathryn Murphy',
                                          onTap: () {},
                                        ),
                                        ArticleWidget(
                                          imageUrl: '',
                                          title:
                                              'Bagaimana membangun komunitas setia secara online dan offline',
                                          author: 'Wade Warren',
                                          onTap: () {},
                                        ),
                                        ArticleWidget(
                                          imageUrl: '',
                                          title:
                                              'Pelajaran dan wawasan dari 8 tahun Pixelgrade',
                                          author: 'Esther Howard',
                                          onTap: () {},
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
                                                  color: AppColor.primary.color,
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
            );
          },
        ),
      ),
    );
  }
}
