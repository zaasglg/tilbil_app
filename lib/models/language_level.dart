class LanguageLevel {
  final int id;
  final String code;
  final String nameRu;
  final String nameKk;
  final String nameEn;
  final String descriptionRu;
  final String descriptionKk;
  final String descriptionEn;
  final int order;
  final bool isLocked;
  final double? progress;

  LanguageLevel({
    required this.id,
    required this.code,
    required this.nameRu,
    required this.nameKk,
    required this.nameEn,
    required this.descriptionRu,
    required this.descriptionKk,
    required this.descriptionEn,
    required this.order,
    this.isLocked = false,
    this.progress,
  });

  factory LanguageLevel.fromJson(Map<String, dynamic> json) {
    return LanguageLevel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameKk: json['name_kk'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionRu: json['description_ru'] ?? '',
      descriptionKk: json['description_kk'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      order: json['order'] ?? 0,
      isLocked: json['is_locked'] ?? false,
      progress: json['progress']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name_ru': nameRu,
      'name_kk': nameKk,
      'name_en': nameEn,
      'description_ru': descriptionRu,
      'description_kk': descriptionKk,
      'description_en': descriptionEn,
      'order': order,
      'is_locked': isLocked,
      'progress': progress,
    };
  }

  // Helper methods for localization
  String getName(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return nameKk;
      case 'ru':
        return nameRu;
      case 'en':
      default:
        return nameEn;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return descriptionKk;
      case 'ru':
        return descriptionRu;
      case 'en':
      default:
        return descriptionEn;
    }
  }

  // Helper to create a copy with updated values
  LanguageLevel copyWith({
    int? id,
    String? code,
    String? nameRu,
    String? nameKk,
    String? nameEn,
    String? descriptionRu,
    String? descriptionKk,
    String? descriptionEn,
    int? order,
    bool? isLocked,
    double? progress,
  }) {
    return LanguageLevel(
      id: id ?? this.id,
      code: code ?? this.code,
      nameRu: nameRu ?? this.nameRu,
      nameKk: nameKk ?? this.nameKk,
      nameEn: nameEn ?? this.nameEn,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      descriptionKk: descriptionKk ?? this.descriptionKk,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      order: order ?? this.order,
      isLocked: isLocked ?? this.isLocked,
      progress: progress ?? this.progress,
    );
  }
}
