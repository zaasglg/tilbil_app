class VideoMaterial {
  final String id;
  final String title;
  final String titleKk;
  final String titleRu;
  final String description;
  final String descriptionKk;
  final String descriptionRu;
  final String videoUrl;
  final String thumbnailUrl;
  final String difficulty;
  final int duration; // в секундах
  final bool isCompleted;

  VideoMaterial({
    required this.id,
    required this.title,
    required this.titleKk,
    required this.titleRu,
    required this.description,
    required this.descriptionKk,
    required this.descriptionRu,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.difficulty,
    required this.duration,
    this.isCompleted = false,
  });

  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return titleKk.isNotEmpty ? titleKk : title;
      case 'ru':
        return titleRu.isNotEmpty ? titleRu : title;
      default:
        return title;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return descriptionKk.isNotEmpty ? descriptionKk : description;
      case 'ru':
        return descriptionRu.isNotEmpty ? descriptionRu : description;
      default:
        return description;
    }
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

class StoryMaterial {
  final String id;
  final String title;
  final String titleKk;
  final String titleRu;
  final String content;
  final String contentKk;
  final String contentRu;
  final String audioUrl;
  final String difficulty;
  final List<String> vocabulary;
  final bool isCompleted;

  StoryMaterial({
    required this.id,
    required this.title,
    required this.titleKk,
    required this.titleRu,
    required this.content,
    required this.contentKk,
    required this.contentRu,
    required this.audioUrl,
    required this.difficulty,
    required this.vocabulary,
    this.isCompleted = false,
  });

  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return titleKk.isNotEmpty ? titleKk : title;
      case 'ru':
        return titleRu.isNotEmpty ? titleRu : title;
      default:
        return title;
    }
  }

  String getContent(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return contentKk.isNotEmpty ? contentKk : content;
      case 'ru':
        return contentRu.isNotEmpty ? contentRu : content;
      default:
        return content;
    }
  }
}