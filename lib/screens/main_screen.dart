import 'package:flutter/material.dart';
import '../components/main_navigation.dart';
import 'learning_screen.dart';
import 'profile_screen.dart';
import 'achievements_screen.dart';
import 'materials_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    const LearningScreen(),
    const MaterialsScreen(),
    const AchievementsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
