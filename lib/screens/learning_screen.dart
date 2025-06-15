import 'package:flutter/material.dart';
import 'language_level_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and illustration
              _buildHeader(context),

              // Learning plan section
              _buildLearningPlan(context),

              // Progress section
              _buildProgressSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top greeting row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Привет! 👋',
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFamily: "AtypDisplay",
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Готов изучать казахский?',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3371B9),  // Blue
                      Color(0xFF56B9CB),  // Light blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3371B9).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Streak container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3371B9),  // Blue
                  Color(0xFF56B9CB),  // Light blue
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3371B9).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Серия дней подряд',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '7 дней',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Продолжай!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningPlan(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Level progression section
          _buildLevelProgression(context),


          const SizedBox(height: 16),
          
          // Additional lesson card
          _buildLessonCard(
            context,
            title: 'Произношение',
            level: 'A1-A2',
            count: '30 упражнений',
            color: const Color(0xFF56B9CB),
            icon: Icons.record_voice_over_rounded,
            isCompleted: false,
            isWide: true,
          ),
          
          const SizedBox(height: 24),
          

        ],
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required String title,
    required String level,
    required String count,
    required Color color,
    required IconData icon,
    required bool isCompleted,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LanguageLevelScreen(level: level),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? color : color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted ? color : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isCompleted ? Colors.white : color,
                    size: 24,
                  ),
                ),
                if (isCompleted)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF2D3748),
                fontSize: isWide ? 18 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // Level and count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            if (!isCompleted) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Начать',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Твой прогресс',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3371B9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF3371B9),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3371B9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          // Progress items
          _buildProgressItem(
            context,
            title: 'Алфавит',
            subtitle: 'Осталось совсем немного!',
            progress: 0.8,
            icon: Icons.translate_rounded,
            color: const Color(0xFF3498DB),
          ),
          const SizedBox(height: 16),
          _buildProgressItem(
            context,
            title: 'Грамматика',
            subtitle: 'Продолжай в том же духе',
            progress: 0.5,
            icon: Icons.menu_book_rounded,
            color: const Color(0xFF3371B9),
          ),
          const SizedBox(height: 16),
          _buildProgressItem(
            context,
            title: 'Произношение',
            subtitle: 'Отличное начало!',
            progress: 0.3,
            icon: Icons.record_voice_over_rounded,
            color: const Color(0xFF56B9CB),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double progress,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width * progress * 0.75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgression(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3371B9).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3371B9).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Уровень прогресса',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                'A1 → A2',
                style: TextStyle(
                  color: Color(0xFF3371B9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '320 / 500 XP',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '64%',
                style: TextStyle(
                  color: const Color(0xFF3371B9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF3371B9).withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.64, // 320/500 = 0.64
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3371B9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Level path
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLevelNode('A1', true, false),
              _buildLevelConnector(true),
              _buildLevelNode('A2', false, true),
              _buildLevelConnector(false),
              _buildLevelNode('B1', false, false),
              _buildLevelConnector(false),
              _buildLevelNode('B2', false, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelNode(String level, bool isCompleted, bool isCurrent) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted 
            ? const Color(0xFF3371B9)
            : isCurrent 
                ? const Color(0xFF3371B9).withOpacity(0.2)
                : const Color(0xFF718096).withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted 
              ? const Color(0xFF3371B9)
              : isCurrent 
                  ? const Color(0xFF3371B9)
                  : const Color(0xFF718096).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              )
            : Text(
                level,
                style: TextStyle(
                  color: isCurrent 
                      ? const Color(0xFF3371B9)
                      : const Color(0xFF718096).withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLevelConnector(bool isActive) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? const Color(0xFF3371B9)
            : const Color(0xFF718096).withOpacity(0.2),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
