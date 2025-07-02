import '../models/achievement.dart';
import 'api_service.dart';

class AchievementService {
  final ApiService _apiService = ApiService();

  // Get all available achievements for user
  Future<List<Achievement>> getUserAchievements() async {
    try {
      final response = await _apiService.get('api/achievements');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> achievementsJson = data['data'];
          return achievementsJson
              .map((json) => Achievement.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load achievements');
        }
      } else {
        throw Exception(response.error ?? 'Failed to load achievements');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return getMockAchievements();
    }
  }

  // Get achievement statistics
  Future<Map<String, dynamic>> getAchievementStats() async {
    try {
      final response = await _apiService.get('api/achievements/stats');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to load achievement stats');
        }
      } else {
        throw Exception(response.error ?? 'Failed to load achievement stats');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return getMockStats();
    }
  }

  // Unlock achievement (when user meets criteria)
  Future<bool> unlockAchievement(String achievementCode) async {
    try {
      final response = await _apiService.post(
        'api/achievements/unlock',
        body: {'achievement_code': achievementCode},
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Check if user meets achievement criteria
  Future<List<String>> checkAchievementCriteria() async {
    try {
      final response = await _apiService.get('api/achievements/check');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> unlockedCodes = data['data']['unlocked'] ?? [];
          return unlockedCodes.cast<String>();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Get achievement by code
  Future<Achievement?> getAchievementByCode(String code) async {
    try {
      final achievements = await getUserAchievements();
      return achievements.firstWhere(
        (achievement) => achievement.code == code,
        orElse: () => throw Exception('Achievement not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // Mock data for development/testing
  List<Achievement> getMockAchievements() {
    return [
      Achievement(
        code: 'quick_learner',
        titleRu: 'Быстрый ученик',
        titleKk: 'Жылдам оқушы',
        titleEn: 'Quick Learner',
        descriptionRu: 'Прошёл 10 уроков менее чем за 5 минут',
        descriptionKk: '10 сабақты 5 минуттан аз уақытта өттім',
        descriptionEn: 'Completed 10 lessons in less than 5 minutes',
        type: 'learning_speed',
        criteria: {'lessons_completed': 10, 'max_time_per_lesson': 300},
        isUnlocked: true,
      ),
      Achievement(
        code: 'ambitious',
        titleRu: 'Амбициозный',
        titleKk: 'Амбициялы',
        titleEn: 'Ambitious',
        descriptionRu: 'Достиг 15 учебных целей',
        descriptionKk: '15 оқу мақсатына жеттім',
        descriptionEn: 'Reached 15 learning goals',
        type: 'goal_achievement',
        criteria: {'goals_completed': 15},
        isUnlocked: true,
      ),
      Achievement(
        code: 'consistency',
        titleRu: 'Постоянство',
        titleKk: 'Тұрақтылық',
        titleEn: 'Consistency',
        descriptionRu: 'Занимайся 30 дней подряд',
        descriptionKk: '30 күн қатарынан оқы',
        descriptionEn: 'Study for 30 days in a row',
        type: 'streak',
        criteria: {'consecutive_days': 30},
        isUnlocked: false,
      ),
      Achievement(
        code: 'word_master',
        titleRu: 'Мастер слов',
        titleKk: 'Сөз шебері',
        titleEn: 'Word Master',
        descriptionRu: 'Выучи 500 новых слов',
        descriptionKk: '500 жаңа сөз үйрен',
        descriptionEn: 'Learn 500 new words',
        type: 'vocabulary',
        criteria: {'words_learned': 500},
        isUnlocked: false,
      ),
    ];
  }

  Map<String, dynamic> getMockStats() {
    return {
      'total_achievements': 4,
      'unlocked_achievements': 2,
      'progress_percentage': 50.0,
      'latest_unlock': 'ambitious',
      'next_unlock': 'consistency',
    };
  }
}