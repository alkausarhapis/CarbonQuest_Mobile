import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/styles/app_color.dart';
import '../model/Missions.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});
  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColor.primary.color,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  final List<String> _categoryIcons = [
    'assets/car.png',
    'assets/listrik.png',
    'assets/daun.png',
    'assets/makanan.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary.color,
      body: _missionContent(),
    );
  }

  Widget _missionContent() {
    final currentCategory = MissionsData.categories[_categoryIndex];
    final currentMissions = MissionsData.getMissionsByCategory(currentCategory);

    return SafeArea(
      child: Stack(
        children: [
          Container(color: AppColor.primary.color),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: CurvedClipper(),
              child: Container(color: Colors.white),
            ),
          ),
          // Left cloud
          Positioned(
            left: -70,
            top: 10,
            child: Image.asset(
              'assets/CloudVector.png',
              width: 200,
              height: 100,
            ),
          ),
          // Right cloud
          Positioned(
            right: -50,
            top: 50,
            child: Image.asset(
              'assets/CloudVector.png',
              width: 200,
              height: 100,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Pilih kategori misi Anda",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(MissionsData.categories.length, (
                    index,
                  ) {
                    bool isSelected = _categoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _categoryIndex = index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Image.asset(
                          _categoryIcons[index],
                          width: isSelected ? 75 : 60,
                          height: isSelected ? 75 : 60,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                currentCategory,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: currentMissions.length,
                  itemBuilder: (context, idx) {
                    final mission = currentMissions[idx];
                    return _buildMissionCard(mission);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Mission mission) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(mission.icon, width: 70, height: 70),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${mission.points}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Pts',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
