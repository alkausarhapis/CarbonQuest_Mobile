import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../core/styles/app_color.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});
  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int _selectedIndex = 0;
  int _categoryIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final List<String> _categories = [
    'Transportasi',
    'Energi',
    'Lingkungan',
    'Hewan',
  ];

  final List<String> _categoryIcons = [
    'assets/car.png',
    'assets/listrik.png',
    'assets/daun.png',
    'assets/makanan.png',
  ];

  final Map<String, List<Map<String, dynamic>>> _missions = {
    'Transportasi': [
      {
        'title': 'Bike to Work Week',
        'desc':
            'Commute to work or school by bicycle for at least 3 days this week instead of using a car.',
        'points': 65,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Use Public Transport',
        'desc':
            'Take public transportation for your daily commute at least 5 times this week.',
        'points': 50,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Walk More',
        'desc':
            'Walk to your nearby destinations instead of driving. Complete at least 3 walks.',
        'points': 40,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Running Errands on Foot',
        'desc':
            'Walk to your nearby destinations instead of driving. Complete at least 3 walks.',
        'points': 40,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Walking Challenge',
        'desc':
            'Walk to your nearby destinations instead of driving. Complete at least 3 walks.',
        'points': 40,
        'icon': 'assets/car.png',
      },
    ],
    'Energi': [
      {
        'title': 'Power Save Challenge',
        'desc':
            'Reduce your electricity usage by turning off unused lights, unplugging devices and lowering energy consumption for at least 3 days.',
        'points': 45,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Solar Power Usage',
        'desc':
            'Use solar-powered chargers or devices for at least one week to reduce electricity usage.',
        'points': 55,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Cold Shower Challenge',
        'desc':
            'Take cold showers to reduce hot water usage and energy consumption for 5 days.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'No Sauna Challenge',
        'desc':
            'Take cold showers to reduce hot water usage and energy consumption for 5 days.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Power Down Challenge',
        'desc':
            'Take cold showers to reduce hot water usage and energy consumption for 5 days.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Cold Shower Challenge',
        'desc':
            'Take cold showers to reduce hot water usage and energy consumption for 5 days.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
    ],
    'Lingkungan': [
      {
        'title': 'Plant a Tree',
        'desc':
            'Plant at least one tree in your garden, park, or any other green space in your area.',
        'points': 57,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Reduce Plastic Usage',
        'desc':
            'Avoid using single-use plastics for a whole week. Use reusable bags and bottles instead.',
        'points': 48,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Garden Green Space',
        'desc':
            'Create a small garden or plant flowers in your home to improve local air quality.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Recycle More',
        'desc':
            'Create a small garden or plant flowers in your home to improve local air quality.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Reuse Challenge',
        'desc':
            'Create a small garden or plant flowers in your home to improve local air quality.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
    ],
    'Hewan': [
      {
        'title': 'Skip the Red Meat',
        'desc':
            'Avoid eating red meat (such as beef and lamb) for at least 3 days this week to reduce your carbon footprint.',
        'points': 40,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Vegetarian Week',
        'desc':
            'Follow a vegetarian diet for an entire week to significantly reduce your environmental impact.',
        'points': 70,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Support Local Farmers',
        'desc':
            'Buy food from local farmers markets instead of supermarkets to support sustainable agriculture.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Eat Seasonal Produce',
        'desc':
            'Buy food from local farmers markets instead of supermarkets to support sustainable agriculture.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Meatless Monday',
        'desc':
            'Buy food from local farmers markets instead of supermarkets to support sustainable agriculture.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          PlaceholderScreen(title: 'Home'),
          PlaceholderScreen(title: 'Quiz'),
          _missionContent(),
          PlaceholderScreen(title: 'Leaderboard'),
          PlaceholderScreen(title: 'Article'),
          PlaceholderScreen(title: 'History'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusBold.home_2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusBold.clipboard_text),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusBold.warning_2),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.crown), label: ''),
          BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.book), label: ''),
          BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.clock), label: ''),
        ],
      ),
    );
  }

  Widget _missionContent() {
    final currentCategory = _categories[_categoryIndex];
    final currentMissions = _missions[currentCategory] ?? [];

    return SafeArea(
      child: Stack(
        children: [
          // Background - Blue top
          Container(color: AppColor.primary.color),
          // Curved divider with white bottom
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
          // Main content
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Chose your mission category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Custom Tab Bar with Icons
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
                  children: List.generate(_categories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _categoryIndex = index);
                      },
                      child: Image.asset(
                        _categoryIcons[index],
                        width: 80,
                        height: 80,
                      ),
                    );
                  }),
                ),
              ),
              // Title "All Mission"
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    currentCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // ListView Mission
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

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            // Icon
            Container(
              child: Image.asset(mission['icon'], width: 70, height: 70),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission['desc'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Points
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${mission['points']}',
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

    // Quadratic bezier untuk curve yang melengkung
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
