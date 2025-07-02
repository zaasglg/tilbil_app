import '../models/language_level.dart';
import 'api_service.dart';

class LanguageLevelService {
  final ApiService _apiService = ApiService();

  // Get all language levels
  Future<List<LanguageLevel>> getLanguageLevels() async {
    try {
      final response = await _apiService.get('api/levels');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> levelsJson = data['data'];
          return levelsJson
              .map((json) => LanguageLevel.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load language levels');
        }
      } else {
        throw Exception(response.error ?? 'Failed to load language levels');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return getMockLanguageLevels();
    }
  }

  // Get specific language level by code
  Future<LanguageLevel?> getLanguageLevelByCode(String code) async {
    try {
      final response = await _apiService.get('api/levels/$code');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          return LanguageLevel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load language level');
        }
      } else {
        throw Exception(response.error ?? 'Failed to load language level');
      }
    } catch (e) {
      return null;
    }
  }

  // Get user's progress for all levels
  Future<Map<String, double>> getUserLevelProgress() async {
    try {
      final response = await _apiService.get('api/levels/progress');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        
        if (data['success'] == true && data['data'] != null) {
          final Map<String, dynamic> progressData = data['data'];
          return progressData.map((key, value) => MapEntry(key, value.toDouble()));
        } else {
          return {};
        }
      } else {
        return {};
      }
    } catch (e) {
      // Fallback to mock progress
      return getMockUserProgress();
    }
  }

  // Update user progress for a specific level
  Future<bool> updateLevelProgress(String levelCode, double progress) async {
    try {
      final response = await _apiService.post(
        'api/levels/$levelCode/progress',
        body: {'progress': progress},
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

  // Mock data for development/testing
  List<LanguageLevel> getMockLanguageLevels() {
    return [
      LanguageLevel(
        id: 1,
        code: 'A1',
        nameRu: 'Начальный',
        nameKk: 'Бастауыш',
        nameEn: 'Beginner',
        descriptionRu: 'Основы казахского языка. Простые фразы и слова.',
        descriptionKk: 'Қазақ тілінің негіздері. Қарапайым сөздер мен сөйлемдер.',
        descriptionEn: 'Basics of Kazakh language. Simple phrases and words.',
        order: 1,
        isLocked: false,
        progress: 0.64,
      ),
      LanguageLevel(
        id: 2,
        code: 'A2',
        nameRu: 'Элементарный',
        nameKk: 'Элементарлы',
        nameEn: 'Elementary',
        descriptionRu: 'Расширение словарного запаса. Простые диалоги.',
        descriptionKk: 'Сөздік қорын кеңейту. Қарапайым сұхбаттар.',
        descriptionEn: 'Expanding vocabulary. Simple conversations.',
        order: 2,
        isLocked: false,
        progress: 0.0,
      ),
      LanguageLevel(
        id: 3,
        code: 'B1',
        nameRu: 'Средний',
        nameKk: 'Орташа',
        nameEn: 'Intermediate',
        descriptionRu: 'Более сложная грамматика. Пересказ текстов.',
        descriptionKk: 'Күрделірек грамматика. Мәтіндерді айтып беру.',
        descriptionEn: 'More complex grammar. Text retelling.',
        order: 3,
        isLocked: true,
        progress: 0.0,
      ),
      LanguageLevel(
        id: 4,
        code: 'B2',
        nameRu: 'Выше среднего',
        nameKk: 'Орташадан жоғары',
        nameEn: 'Upper Intermediate',
        descriptionRu: 'Свободное общение. Понимание сложных текстов.',
        descriptionKk: 'Еркін қарым-қатынас. Күрделі мәтіндерді түсіну.',
        descriptionEn: 'Free communication. Understanding complex texts.',
        order: 4,
        isLocked: true,
        progress: 0.0,
      ),
      LanguageLevel(
        id: 5,
        code: 'C1',
        nameRu: 'Продвинутый',
        nameKk: 'Жетілген',
        nameEn: 'Advanced',
        descriptionRu: 'Высокий уровень владения языком.',
        descriptionKk: 'Тілді жоғары деңгейде меңгеру.',
        descriptionEn: 'High level of language proficiency.',
        order: 5,
        isLocked: true,
        progress: 0.0,
      ),
      LanguageLevel(
        id: 6,
        code: 'C2',
        nameRu: 'Мастерство',
        nameKk: 'Шеберлік',
        nameEn: 'Mastery',
        descriptionRu: 'Владение языком на уровне носителя.',
        descriptionKk: 'Ана тілі деңгейінде меңгеру.',
        descriptionEn: 'Native-level language proficiency.',
        order: 6,
        isLocked: true,
        progress: 0.0,
      ),
    ];
  }

  Map<String, double> getMockUserProgress() {
    return {
      'A1': 0.64,
      'A2': 0.0,
      'B1': 0.0,
      'B2': 0.0,
      'C1': 0.0,
      'C2': 0.0,
    };
  }
}
