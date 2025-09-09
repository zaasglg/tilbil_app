
enum ExerciseType {
  multipleChoice,
  fillInTheBlank,
  dragAndDrop,
  matching,
  translation,
  pronunciation,
}

enum ExerciseDifficulty {
  easy,
  medium,
  hard,
}

class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final String? questionImageUrl;
  final List<String> options;
  final List<String> correctAnswers;
  final String explanation;
  final ExerciseDifficulty difficulty;
  final int points;
  final String? audioUrl;
  final Map<String, dynamic>? metadata;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.questionImageUrl,
    required this.options,
    required this.correctAnswers,
    this.explanation = '',
    this.difficulty = ExerciseDifficulty.medium,
    this.points = 10,
    this.audioUrl,
    this.metadata,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      type: ExerciseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExerciseType.multipleChoice,
      ),
      question: json['question'] ?? '',
      questionImageUrl: json['questionImageUrl'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswers: List<String>.from(json['correctAnswers'] ?? []),
      explanation: json['explanation'] ?? '',
      difficulty: ExerciseDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => ExerciseDifficulty.medium,
      ),
      points: json['points'] ?? 10,
      audioUrl: json['audioUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'question': question,
      'questionImageUrl': questionImageUrl,
      'options': options,
      'correctAnswers': correctAnswers,
      'explanation': explanation,
      'difficulty': difficulty.name,
      'points': points,
      'audioUrl': audioUrl,
      'metadata': metadata,
    };
  }
}

class ExerciseResult {
  final String exerciseId;
  final bool isCorrect;
  final List<String> userAnswers;
  final int pointsEarned;
  final Duration timeSpent;
  final DateTime completedAt;

  const ExerciseResult({
    required this.exerciseId,
    required this.isCorrect,
    required this.userAnswers,
    required this.pointsEarned,
    required this.timeSpent,
    required this.completedAt,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      exerciseId: json['exerciseId'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      userAnswers: List<String>.from(json['userAnswers'] ?? []),
      pointsEarned: json['pointsEarned'] ?? 0,
      timeSpent: Duration(milliseconds: json['timeSpentMs'] ?? 0),
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'isCorrect': isCorrect,
      'userAnswers': userAnswers,
      'pointsEarned': pointsEarned,
      'timeSpentMs': timeSpent.inMilliseconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}

class TrainingSession {
  final String id;
  final String topicId;
  final List<Exercise> exercises;
  final List<ExerciseResult> results;
  final int totalPoints;
  final int maxPoints;
  final int lives;
  final int maxLives;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const TrainingSession({
    required this.id,
    required this.topicId,
    required this.exercises,
    this.results = const [],
    this.totalPoints = 0,
    this.maxPoints = 0,
    this.lives = 5,
    this.maxLives = 5,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  });

  double get progress => exercises.isEmpty ? 0.0 : results.length / exercises.length;
  
  int get correctAnswers => results.where((r) => r.isCorrect).length;
  
  int get incorrectAnswers => results.where((r) => !r.isCorrect).length;
  
  double get accuracy => results.isEmpty ? 0.0 : correctAnswers / results.length;

  TrainingSession copyWith({
    String? id,
    String? topicId,
    List<Exercise>? exercises,
    List<ExerciseResult>? results,
    int? totalPoints,
    int? maxPoints,
    int? lives,
    int? maxLives,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      exercises: exercises ?? this.exercises,
      results: results ?? this.results,
      totalPoints: totalPoints ?? this.totalPoints,
      maxPoints: maxPoints ?? this.maxPoints,
      lives: lives ?? this.lives,
      maxLives: maxLives ?? this.maxLives,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
