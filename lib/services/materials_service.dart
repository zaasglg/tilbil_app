import 'package:flutter/foundation.dart';
import '../models/material_models.dart';

class MaterialsService extends ChangeNotifier {
  List<VideoMaterial> _videos = [];
  List<StoryMaterial> _stories = [];

  List<VideoMaterial> get videos => _videos;
  List<StoryMaterial> get stories => _stories;

  MaterialsService() {
    _loadMockData();
  }

  void _loadMockData() {
    _videos = [
      VideoMaterial(
        id: 'video_1',
        title: 'Зверополис',
        titleKk: 'Зверополис',
        titleRu: 'Зверополис',
        description: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionKk: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionRu: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        videoUrl:
            'https://tilqural.kz/assets/videos/1751765d8836017652e82fbc56ea4330.mp4',
        thumbnailUrl:
            'https://tilqural.kz/assets/images/videos/85b62d4a27ea43297eb1ab349b6e06c6.jpg?515c8c1b0cfe6f0c0b614ffd802e3266)',
        difficulty: 'Бастапқы деңгей',
        duration: 180,
      ),
      VideoMaterial(
        id: 'video_2',
        title: 'Ральф против интернета',
        titleKk: 'Ральф против интернета',
        titleRu: 'Ральф против интернета',
        description: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionKk: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionRu: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        videoUrl: 'https://tilqural.kz/assets/videos/0f5ea5605ba08e55f5b849e7c5ccdd08.mp4',
        thumbnailUrl:
            'https://tilqural.kz/assets/images/videos/cd66a7a18d37d7e5dd969c249e9a1ecb.jpg?63562f9471470caef245263c44cb2e76',
        difficulty: 'Бастапқы деңгей',
        duration: 240,
      ),
      VideoMaterial(
        id: 'video_3',
        title: 'Вверх',
        titleKk: 'Вверх',
        titleRu: 'Вверх',
        description: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionKk: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionRu: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        videoUrl: 'https://tilqural.kz/assets/videos/35f6cf8d4a6f6c8d103d88695e34dff2.mp4',
        thumbnailUrl:
            'https://tilqural.kz/assets/images/videos/36fdb1a35cd2f54f95cf2119fb5bc7ed.jpg?df7845cd1fcbc1140767b331ac834459',
        difficulty: 'Бастапқы деңгей',
        duration: 300,
      ),
      VideoMaterial(
        id: 'video_4',
        title: 'Рапунцель',
        titleKk: 'Рапунцель',
        titleRu: 'Рапунцель',
        description: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionKk: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        descriptionRu: 'Бейнероликті аяғына дейін мұқият көріп, сөздеріне мән бер',
        videoUrl: 'https://tilqural.kz/assets/videos/d1d8b9823dfd700090c92089f6cf19d5.mp4',
        thumbnailUrl:
            'https://tilqural.kz/assets/images/videos/8b6e33345ac8d5ffd9cf0d107a7d9e9d.jpg?99593bb2e80fbb1b0d3845c65e3f782e',
        difficulty: 'Бастапқы деңгей',
        duration: 300,
      ),
      
    ];

    _stories = [
      StoryMaterial(
        id: 'story_1',
        title: 'Б.Соқпақбаев. Менің атым Қожа',
        titleKk: 'Б.Соқпақбаев. Менің атым Қожа',
        titleRu: 'Б.Соқпақбаев. Менің атым Қожа',
        content:
            'Once upon a time, in the vast steppes of Kazakhstan, there lived a young hunter...',
        contentKk:
            'Ертеде Қазақстанның кең далаларында жас аңшы өмір сүрген...',
        contentRu:
            'Давным-давно в бескрайних степях Казахстана жил молодой охотник...',
        audioUrl: 'https://tilqural.kz/assets/audio/texts/2e0a273deb476d0f5bec87ab0c8176b5.mp3',
        difficulty: 'Бастапқы деңгей',
        vocabulary: ['аңшы', 'дала', 'бүркітші', 'алтын'],
      ),
    ];
  }

  List<VideoMaterial> getVideosByDifficulty(String difficulty) {
    return _videos.where((video) => video.difficulty == difficulty).toList();
  }

  List<StoryMaterial> getStoriesByDifficulty(String difficulty) {
    return _stories.where((story) => story.difficulty == difficulty).toList();
  }

  void markVideoAsCompleted(String videoId) {
    final index = _videos.indexWhere((video) => video.id == videoId);
    if (index != -1) {
      _videos[index] = VideoMaterial(
        id: _videos[index].id,
        title: _videos[index].title,
        titleKk: _videos[index].titleKk,
        titleRu: _videos[index].titleRu,
        description: _videos[index].description,
        descriptionKk: _videos[index].descriptionKk,
        descriptionRu: _videos[index].descriptionRu,
        videoUrl: _videos[index].videoUrl,
        thumbnailUrl: _videos[index].thumbnailUrl,
        difficulty: _videos[index].difficulty,
        duration: _videos[index].duration,
        isCompleted: true,
      );
      notifyListeners();
    }
  }

  void markStoryAsCompleted(String storyId) {
    final index = _stories.indexWhere((story) => story.id == storyId);
    if (index != -1) {
      _stories[index] = StoryMaterial(
        id: _stories[index].id,
        title: _stories[index].title,
        titleKk: _stories[index].titleKk,
        titleRu: _stories[index].titleRu,
        content: _stories[index].content,
        contentKk: _stories[index].contentKk,
        contentRu: _stories[index].contentRu,
        audioUrl: _stories[index].audioUrl,
        difficulty: _stories[index].difficulty,
        vocabulary: _stories[index].vocabulary,
        isCompleted: true,
      );
      notifyListeners();
    }
  }
}
