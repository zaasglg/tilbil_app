class LessonTopic {
  final String id;
  final String title;
  final String imageUrl;
  final String level;
  final double progress;
  final int vocabularyCount;
  final int exerciseCount;
  final int lessonCount;
  final bool isCompleted;
  final bool isLocked;

  const LessonTopic({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.level,
    this.progress = 0.0,
    this.vocabularyCount = 0,
    this.exerciseCount = 0,
    this.lessonCount = 0,
    this.isCompleted = false,
    this.isLocked = false,
  });

  LessonTopic copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? level,
    double? progress,
    int? vocabularyCount,
    int? exerciseCount,
    int? lessonCount,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return LessonTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      vocabularyCount: vocabularyCount ?? this.vocabularyCount,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      lessonCount: lessonCount ?? this.lessonCount,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'level': level,
      'progress': progress,
      'vocabularyCount': vocabularyCount,
      'exerciseCount': exerciseCount,
      'lessonCount': lessonCount,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
    };
  }

  factory LessonTopic.fromJson(Map<String, dynamic> json) {
    return LessonTopic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      level: json['level'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      vocabularyCount: json['vocabularyCount'] ?? 0,
      exerciseCount: json['exerciseCount'] ?? 0,
      lessonCount: json['lessonCount'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
    );
  }
}

enum LessonSection {
  vocabulary('Сөздікқор', 'vocabulary'),
  trainer('Тренажер', 'trainer'),
  lesson('Сабақ', 'lesson'),
  quiz('Саюақ', 'quiz');

  const LessonSection(this.title, this.key);

  final String title;
  final String key;
}

class LessonSectionData {
  final LessonSection section;
  final int totalItems;
  final int completedItems;
  final bool isLocked;
  final String description;

  const LessonSectionData({
    required this.section,
    required this.totalItems,
    this.completedItems = 0,
    this.isLocked = false,
    this.description = '',
  });

  double get progress => totalItems > 0 ? completedItems / totalItems : 0.0;
  bool get isCompleted => completedItems >= totalItems && totalItems > 0;

  LessonSectionData copyWith({
    LessonSection? section,
    int? totalItems,
    int? completedItems,
    bool? isLocked,
    String? description,
  }) {
    return LessonSectionData(
      section: section ?? this.section,
      totalItems: totalItems ?? this.totalItems,
      completedItems: completedItems ?? this.completedItems,
      isLocked: isLocked ?? this.isLocked,
      description: description ?? this.description,
    );
  }
}
