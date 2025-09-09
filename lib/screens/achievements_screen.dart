import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';
import '../services/language_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  List<Achievement> _achievements = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Try to load from API, fallback to mock data if needed
      List<Achievement> achievements;
      Map<String, dynamic> stats;

      try {
        // Load both achievements and stats in parallel
        final results = await Future.wait([
          _achievementService.getUserAchievements(),
          _achievementService.getAchievementStats(),
        ]);

        achievements = results[0] as List<Achievement>;
        stats = results[1] as Map<String, dynamic>;
      } catch (apiError) {
        // Fallback to mock data if API fails
        achievements = _achievementService.getMockAchievements();
        stats = _achievementService.getMockStats();
      }

      setState(() {
        _achievements = achievements;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2D3748),
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.achievementsTitle,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: "AtypDisplay",
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                radius: 16,
                color: Color(0xFF3371B9),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading achievements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadAchievements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3371B9),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressCard(),
                        const SizedBox(height: 20),

                        // Achievements section title
                        Text(
                          localizations.achievementsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Dynamic achievement cards
                        ..._buildAchievementCards(context, localizations),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProgressCard() {
    return Builder(
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;

        // Use stats from API if available, otherwise calculate from achievements
        final unlockedCount = _stats.isNotEmpty
            ? 0 ?? _achievements.where((a) => a.isUnlocked).length
            : _achievements.where((a) => a.isUnlocked).length;
        final totalCount = _stats.isNotEmpty
            ? 6 ?? _achievements.length
            : _achievements.length;
        final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

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
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor:
                            const Color(0xFF3371B9).withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF3371B9)),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$unlockedCount/$totalCount',
                        style: const TextStyle(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.yourProgress,
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.earnedRewards(unlockedCount, totalCount),
                      style: const TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Show next achievement hint if available from stats
                    if (_stats.isNotEmpty && _stats['next_unlock'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Next: ${_stats['next_unlock']}',
                        style: const TextStyle(
                          color: Color(0xFF3371B9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAchievementCards(
      BuildContext context, AppLocalizations localizations) {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final currentLanguageCode = languageService.currentLocale.languageCode;

    return _achievements.map((achievement) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildAchievementCard(
          context,
          color: achievement.isUnlocked
              ? _getAchievementColor(achievement.type)
              : const Color(0xFF718096),
          title: achievement.getTitle(currentLanguageCode),
          description: achievement.getDescription(currentLanguageCode),
          iconData: _getAchievementIcon(achievement.type),
          stars: _getAchievementStars(achievement.type),
          isUnlocked: achievement.isUnlocked,
        ),
      );
    }).toList();
  }

  Color _getAchievementColor(String type) {
    switch (type) {
      case 'learning_speed':
        return const Color(0xFF3371B9);
      case 'goal_achievement':
        return const Color(0xFF56B9CB);
      case 'streak':
        return const Color(0xFFE5BA73);
      case 'vocabulary':
        return const Color(0xFF9C88FF);
      default:
        return const Color(0xFF3371B9);
    }
  }

  IconData _getAchievementIcon(String type) {
    switch (type) {
      case 'learning_speed':
        return Icons.flash_on_rounded;
      case 'goal_achievement':
        return Icons.emoji_events_rounded;
      case 'streak':
        return Icons.local_fire_department_rounded;
      case 'vocabulary':
        return Icons.library_books_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  int _getAchievementStars(String type) {
    switch (type) {
      case 'learning_speed':
        return 3;
      case 'goal_achievement':
        return 3;
      case 'streak':
        return 5;
      case 'vocabulary':
        return 4;
      default:
        return 3;
    }
  }

  Widget _buildAchievementCard(
    BuildContext context, {
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
          color: isUnlocked
              ? color.withOpacity(0.2)
              : const Color(0xFF718096).withOpacity(0.1),
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
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : const Color(0xFF718096).withOpacity(0.1),
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
                        color: isUnlocked
                            ? const Color(0xFF2D3748)
                            : const Color(0xFF718096),
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
                    color: isUnlocked
                        ? const Color(0xFF718096)
                        : const Color(0xFF718096).withOpacity(0.7),
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
