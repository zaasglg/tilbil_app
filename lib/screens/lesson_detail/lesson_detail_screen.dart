import 'package:flutter/material.dart';
import '../../models/lesson_topic.dart';
import 'vocabulary_screen.dart';
import 'vocabulary_webview_screen.dart';
import 'trainer_webview_screen.dart';
import 'lesson_webview_screen.dart';
import 'quiz_webview_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonTopic topic;

  const LessonDetailScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late List<LessonSectionData> sections;

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    sections = [
      const LessonSectionData(
        section: LessonSection.vocabulary,
        totalItems: 25,
        completedItems: 8,
        description: 'Жаңа сөздерді үйреніңіз',
      ),
      const LessonSectionData(
        section: LessonSection.trainer,
        totalItems: 15,
        completedItems: 5,
        description: 'Жаттығулармен дағдыларыңызды жетілдіріңіз',
      ),
      const LessonSectionData(
        section: LessonSection.lesson,
        totalItems: 8,
        completedItems: 2,
        description: 'Видео сабақтарды көріңіз',
      ),
      const LessonSectionData(
        section: LessonSection.quiz,
        totalItems: 10,
        completedItems: 0,
        description: 'Білімді тексеру үшін саюақ',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.topic.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.topic.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopicInfo(),
          const SizedBox(height: 30),
          _buildProgressSection(),
          const SizedBox(height: 30),
          _buildSectionsTitle(),
          const SizedBox(height: 20),
          _buildSectionsList(),
        ],
      ),
    );
  }

  Widget _buildTopicInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.topic.level,
                  style: const TextStyle(
                    color: Color(0xFF4ECDC4),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              if (widget.topic.isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.topic.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222B45),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Бұл сабақта сіз жаңа сөздерді үйреніп, дағдыларыңызды жетілдіре аласыз',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final totalProgress = sections.fold<double>(
          0.0,
          (sum, section) => sum + section.progress,
        ) /
        sections.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4ECDC4).withOpacity(0.1),
            const Color(0xFF44A08D).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Жалпы прогресс',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222B45),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4ECDC4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(totalProgress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ECDC4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsTitle() {
    return const Text(
      'Сабақ бөлімдері',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF222B45),
      ),
    );
  }

  Widget _buildSectionsList() {
    return Column(
      children: sections.map((section) => _buildSectionCard(section)).toList(),
    );
  }

  Widget _buildSectionCard(LessonSectionData sectionData) {
    final IconData sectionIcon;
    final Color sectionColor;

    switch (sectionData.section) {
      case LessonSection.vocabulary:
        sectionIcon = Icons.book;
        sectionColor = const Color(0xFF4ECDC4);
        break;
      case LessonSection.trainer:
        sectionIcon = Icons.fitness_center;
        sectionColor = const Color(0xFFFF6B6B);
        break;
      case LessonSection.lesson:
        sectionIcon = Icons.play_circle_fill;
        sectionColor = const Color(0xFF4DABF7);
        break;
      case LessonSection.quiz:
        sectionIcon = Icons.quiz;
        sectionColor = const Color(0xFF9775FA);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: sectionData.isLocked ? null : () => _onSectionTap(sectionData),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: sectionColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        sectionIcon,
                        color: sectionColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sectionData.section.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222B45),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sectionData.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (sectionData.isLocked)
                      Icon(
                        Icons.lock,
                        color: Colors.grey[400],
                        size: 20,
                      )
                    else if (sectionData.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: sectionData.progress,
                          minHeight: 6,
                          backgroundColor: sectionColor.withOpacity(0.1),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(sectionColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${sectionData.completedItems}/${sectionData.totalItems}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSectionTap(LessonSectionData sectionData) {
    switch (sectionData.section) {
      case LessonSection.vocabulary:
        _showSectionOptions(
          sectionData.section.title,
          [
            SectionOption(
              title: 'Офлайн сөздікқор',
              description: 'Қолданбадағы сөздікқор',
              icon: Icons.book,
              color: const Color(0xFF4ECDC4),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VocabularyScreen(topic: widget.topic),
                  ),
                );
              },
            ),
            SectionOption(
              title: 'Онлайн сөздікқор',
              description: 'Веб-сайттағы сөздікқор',
              icon: Icons.language,
              color: const Color(0xFF44A08D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VocabularyWebViewScreen(topic: widget.topic),
                  ),
                );
              },
            ),
          ],
        );
        break;
      case LessonSection.trainer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainerWebViewScreen(topic: widget.topic),
          ),
        );
        break;
      case LessonSection.lesson:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonWebViewScreen(topic: widget.topic),
          ),
        );
        break;
      case LessonSection.quiz:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWebViewScreen(topic: widget.topic),
          ),
        );
        break;
    }
  }

  void _showSectionOptions(String title, List<SectionOption> options) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.map((option) => _buildOptionTile(option)).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(SectionOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: option.color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            option.onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionOption {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SectionOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
