class Achievement {
  final String code;
  final String titleRu;
  final String titleKk;
  final String titleEn;
  final String descriptionRu;
  final String descriptionKk;
  final String descriptionEn;
  final String? iconUrl;
  final String type;
  final Map<String, dynamic> criteria;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.code,
    required this.titleRu,
    required this.titleKk,
    required this.titleEn,
    required this.descriptionRu,
    required this.descriptionKk,
    required this.descriptionEn,
    this.iconUrl,
    required this.type,
    required this.criteria,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      code: json['code'] ?? '',
      titleRu: json['title_ru'] ?? '',
      titleKk: json['title_kk'] ?? '',
      titleEn: json['title_en'] ?? '',
      descriptionRu: json['description_ru'] ?? '',
      descriptionKk: json['description_kk'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      iconUrl: json['icon_url'],
      type: json['type'] ?? '',
      criteria: json['criteria'] ?? {},
      isUnlocked: json['is_unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null 
          ? DateTime.parse(json['unlocked_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title_ru': titleRu,
      'title_kk': titleKk,
      'title_en': titleEn,
      'description_ru': descriptionRu,
      'description_kk': descriptionKk,
      'description_en': descriptionEn,
      'icon_url': iconUrl,
      'type': type,
      'criteria': criteria,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }

  // Helper methods to get localized text
  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return titleKk.isNotEmpty ? titleKk : titleEn;
      case 'ru':
        return titleRu.isNotEmpty ? titleRu : titleEn;
      case 'en':
      default:
        return titleEn;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return descriptionKk.isNotEmpty ? descriptionKk : descriptionEn;
      case 'ru':
        return descriptionRu.isNotEmpty ? descriptionRu : descriptionEn;
      case 'en':
      default:
        return descriptionEn;
    }
  }

  Achievement copyWith({
    String? code,
    String? titleRu,
    String? titleKk,
    String? titleEn,
    String? descriptionRu,
    String? descriptionKk,
    String? descriptionEn,
    String? iconUrl,
    String? type,
    Map<String, dynamic>? criteria,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      code: code ?? this.code,
      titleRu: titleRu ?? this.titleRu,
      titleKk: titleKk ?? this.titleKk,
      titleEn: titleEn ?? this.titleEn,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      descriptionKk: descriptionKk ?? this.descriptionKk,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      iconUrl: iconUrl ?? this.iconUrl,
      type: type ?? this.type,
      criteria: criteria ?? this.criteria,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}