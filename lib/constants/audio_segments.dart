/// Enum для аудиосегментов из main_audio.mp3
/// Каждый сегмент имеет название, начальное и конечное время
enum AudioSegment {
  // Приветствие и знакомство (0-9 секунд)
  welcome(
    name: 'Қош келдің',
    description: 'Приветствие и знакомство',
    startTime: Duration(seconds: 0),
    endTime: Duration(seconds: 9),
  ),

  // Первое задание (9.03-10.04 секунд)
  firstTask(
    name: 'Бірінші тапсырма',
    description: 'Дыбысты тыңдап тап',
    startTime: Duration(seconds: 9, milliseconds: 30),
    endTime: Duration(seconds: 10, milliseconds: 40),
  ),

  // Поощрение (10-12 секунд)
  encouragement(
    name: 'Жақсы!',
    description: 'Поощрение за правильный ответ',
    startTime: Duration(seconds: 10),
    endTime: Duration(seconds: 12),
  ),

  // Объяснение (12-15 секунд)
  explanation(
    name: 'Түсіндіру',
    description: 'Объяснение правил',
    startTime: Duration(seconds: 12),
    endTime: Duration(seconds: 15),
  ),

  // Второе задание (15-18 секунд)
  secondTask(
    name: 'Екінші тапсырма',
    description: 'Дауысты дыбысты тап',
    startTime: Duration(seconds: 15),
    endTime: Duration(seconds: 18),
  ),

  // Третье задание (18-21 секунд)
  thirdTask(
    name: 'Үшінші тапсырма',
    description: 'Сөз құрастыр',
    startTime: Duration(seconds: 18),
    endTime: Duration(seconds: 21),
  ),

  // Четвертое задание (21-24 секунд)
  fourthTask(
    name: 'Төртінші тапсырма',
    description: 'Дауысты дыбысы аз сөзді тап',
    startTime: Duration(seconds: 21),
    endTime: Duration(seconds: 24),
  ),

  // Пятое задание (24-27 секунд)
  fifthTask(
    name: 'Бесінші тапсырма',
    description: 'Сөйлем құрастыр',
    startTime: Duration(seconds: 24),
    endTime: Duration(seconds: 27),
  ),

  // Финальное поощрение (27-30 секунд)
  finalCongratulation(
    name: 'Сен жарайсың!',
    description: 'Финальное поздравление',
    startTime: Duration(seconds: 27),
    endTime: Duration(seconds: 30),
  );

  const AudioSegment({
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  final String name;
  final String description;
  final Duration startTime;
  final Duration endTime;

  /// Получить длительность сегмента
  Duration get duration => endTime - startTime;

  /// Получить форматированное время начала
  String get formattedStartTime {
    final seconds = startTime.inSeconds.toString().padLeft(2, '0');
    final milliseconds =
        (startTime.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$seconds.$milliseconds';
  }

  /// Получить форматированное время окончания
  String get formattedEndTime {
    final seconds = endTime.inSeconds.toString().padLeft(2, '0');
    final milliseconds =
        (endTime.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$seconds.$milliseconds';
  }

  /// Получить форматированную длительность
  String get formattedDuration {
    final totalMs = duration.inMilliseconds;
    final seconds = (totalMs / 1000).floor();
    final milliseconds = totalMs % 1000;
    return '${seconds}.${milliseconds.toString().padLeft(3, '0')}с';
  }

  /// Получить информацию о сегменте
  String get segmentInfo => '$name ($formattedStartTime-${formattedEndTime}с)';

  /// Путь к основному аудиофайлу
  static const String mainAudioPath = 'assets/audio/main_audio.mp3';

  /// Получить все доступные сегменты
  static List<AudioSegment> get allSegments => AudioSegment.values;

  /// Найти сегмент по названию
  static AudioSegment? findByName(String name) {
    try {
      return AudioSegment.values.firstWhere((segment) => segment.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Получить сегменты для определенного возраста
  static List<AudioSegment> getSegmentsForAge(int age) {
    if (age >= 4 && age <= 5) {
      return [
        AudioSegment.welcome,
        AudioSegment.firstTask,
        AudioSegment.encouragement,
        AudioSegment.finalCongratulation,
      ];
    } else if (age >= 6 && age <= 8) {
      return [
        AudioSegment.welcome,
        AudioSegment.firstTask,
        AudioSegment.secondTask,
        AudioSegment.thirdTask,
        AudioSegment.encouragement,
        AudioSegment.finalCongratulation,
      ];
    } else if (age >= 9 && age <= 14) {
      return AudioSegment.values; // Все сегменты
    } else {
      return [AudioSegment.welcome, AudioSegment.finalCongratulation];
    }
  }
}
