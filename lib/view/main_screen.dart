import 'package:carbonquest/view/mission_screen.dart';
import 'package:carbonquest/view/quiz_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
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
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          HomeScreen(),
          QuizMenuScreen(),
          MissionScreen(),
          PlaceholderScreen(title: 'Leaderboard'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        currentIndex: _currentIndex,
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
        ],
      ),
    );
  }
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
