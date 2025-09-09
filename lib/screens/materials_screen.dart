import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../services/materials_service.dart';
import '../services/language_service.dart';
import '../models/material_models.dart';
import 'video_player_screen.dart';
import 'story_reader_screen.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MaterialsService _materialsService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _materialsService = MaterialsService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _materialsService,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return Text(
                _getTitle(languageService.currentLocale.languageCode),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF1CB0F6),
            labelColor: const Color(0xFF1CB0F6),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Consumer<LanguageService>(
                builder: (context, languageService, child) {
                  return Tab(
                    text: _getVideosTabTitle(
                        languageService.currentLocale.languageCode),
                  );
                },
              ),
              Consumer<LanguageService>(
                builder: (context, languageService, child) {
                  return Tab(
                    text: _getStoriesTabTitle(
                        languageService.currentLocale.languageCode),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVideosTab(),
            _buildStoriesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    return Consumer2<MaterialsService, LanguageService>(
      builder: (context, materialsService, languageService, child) {
        final videos = materialsService.videos;

        if (videos.isEmpty) {
          return _buildEmptyState(
            'assets/icons/Play.svg',
            _getNoVideosMessage(languageService.currentLocale.languageCode),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return _buildVideoCard(
                video, languageService.currentLocale.languageCode);
          },
        );
      },
    );
  }

  Widget _buildStoriesTab() {
    return Consumer2<MaterialsService, LanguageService>(
      builder: (context, materialsService, languageService, child) {
        final stories = materialsService.stories;

        if (stories.isEmpty) {
          return _buildEmptyState(
            'assets/icons/BookOpenText.svg',
            _getNoStoriesMessage(languageService.currentLocale.languageCode),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return _buildStoryCard(
                story, languageService.currentLocale.languageCode);
          },
        );
      },
    );
  }

  Widget _buildVideoCard(VideoMaterial video, String languageCode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(video: video),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        video.thumbnailUrl,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 80,
                            color: const Color(0xFF1CB0F6).withOpacity(0.1),
                            child: const Icon(
                              Icons.video_library,
                              color: Color(0xFF1CB0F6),
                              size: 32,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 120,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Play overlay
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    if (video.isCompleted)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1CB0F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.getTitle(languageCode),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.getDescription(languageCode),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(StoryMaterial story, String languageCode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryReaderScreen(story: story),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF1CB0F6).withOpacity(0.1),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      color: Color(0xFF1CB0F6),
                      size: 20,
                    ),
                    if (story.isCompleted)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1CB0F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  story.getTitle(languageCode),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        chipColor = const Color(0xFF1CB0F6);
        break;
      case 'intermediate':
        chipColor = const Color(0xFF1CB0F6);
        break;
      case 'advanced':
        chipColor = const Color(0xFFFF9600);
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String iconPath, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 80,
            width: 80,
            colorFilter: ColorFilter.mode(
              Colors.grey[400]!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Материалдар';
      case 'ru':
        return 'Материалы';
      default:
        return 'Materials';
    }
  }

  String _getVideosTabTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Бейнелер';
      case 'ru':
        return 'Видео';
      default:
        return 'Videos';
    }
  }

  String _getStoriesTabTitle(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Ертегілер';
      case 'ru':
        return 'Сказки';
      default:
        return 'Stories';
    }
  }

  String _getNoVideosMessage(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Бейне материалдар жоқ';
      case 'ru':
        return 'Нет видео материалов';
      default:
        return 'No video materials available';
    }
  }

  String _getNoStoriesMessage(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Ертегілер жоқ';
      case 'ru':
        return 'Нет сказок';
      default:
        return 'No stories available';
    }
  }

  String _getVocabularyText(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'сөз';
      case 'ru':
        return 'слов';
      default:
        return 'words';
    }
  }
}
