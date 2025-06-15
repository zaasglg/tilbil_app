import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3371B9).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2D3748),
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Достижения',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: "AtypDisplay",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressCard(),
              const SizedBox(height: 20),
              
              // Achievements section title
              const Text(
                'Достижения',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              
              const SizedBox(height: 12),
              
              _buildAchievementCard(
                color: const Color(0xFF3371B9),
                title: 'Быстрый ученик',
                description: 'Прошёл 10 уроков менее чем за 5 минут',
                iconData: Icons.flash_on_rounded,
                stars: 3,
                isUnlocked: true,
              ),
              const SizedBox(height: 12),
              _buildAchievementCard(
                color: const Color(0xFF56B9CB),
                title: 'Амбициозный',
                description: 'Достиг 15 учебных целей',
                iconData: Icons.emoji_events_rounded,
                stars: 3,
                isUnlocked: true,
              ),
              const SizedBox(height: 12),
              _buildAchievementCard(
                color: const Color(0xFF718096),
                title: 'Постоянство',
                description: 'Занимайся 30 дней подряд',
                iconData: Icons.local_fire_department_rounded,
                stars: 5,
                isUnlocked: false,
              ),
              const SizedBox(height: 12),
              _buildAchievementCard(
                color: const Color(0xFF718096),
                title: 'Мастер слов',
                description: 'Выучи 500 новых слов',
                iconData: Icons.library_books_rounded,
                stars: 4,
                isUnlocked: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3371B9).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Progress indicator
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 0.5, // 2 из 4
                    strokeWidth: 4,
                    backgroundColor: const Color(0xFF3371B9).withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3371B9)),
                  ),
                ),
                const Center(
                  child: Text(
                    '2/4',
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Achievement text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Твой прогресс',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Получено 2 награды из 4',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required Color color,
    required String title,
    required String description,
    required IconData iconData,
    required int stars,
    required bool isUnlocked,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.2) : const Color(0xFF718096).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked ? color.withOpacity(0.1) : const Color(0xFF718096).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              iconData,
              color: isUnlocked ? color : const Color(0xFF718096),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isUnlocked ? const Color(0xFF2D3748) : const Color(0xFF718096),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      )
                    else
                      Icon(
                        Icons.lock_outline_rounded,
                        color: const Color(0xFF718096).withOpacity(0.5),
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isUnlocked ? const Color(0xFF718096) : const Color(0xFF718096).withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
