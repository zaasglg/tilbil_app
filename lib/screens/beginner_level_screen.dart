import 'package:flutter/material.dart';
import '../models/lesson_topic.dart';
import 'lesson_detail/lesson_detail_screen.dart';

class BeginnerLevelScreen extends StatelessWidget {
  BeginnerLevelScreen({Key? key}) : super(key: key);

  final List<LessonTopic> topics = [
    LessonTopic(
      id: '1',
      title: 'Сәлем, танысайық',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/063ee9aeb9f60efa02823e51450f82ce.jpg?6ff5014f68149258fa72c5cb8d380d45',
      level: 'A1',
      progress: 0.25,
      vocabularyCount: 25,
      exerciseCount: 15,
      lessonCount: 8,
    ),
    LessonTopic(
      id: '2',
      title: 'Менің отбасым',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/a63cd9e38964634741a5a3fe89055308.jpg?2f88ede56e4e851e2e8998c136d2a4e1',
      level: 'A1',
      progress: 0.15,
      vocabularyCount: 30,
      exerciseCount: 18,
      lessonCount: 10,
    ),
    LessonTopic(
      id: '3',
      title: 'Жасың нешеде',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/c1011ef61ed9937904f4938c63d014ea.jpg?066629654893336d6ea08ebf4113c27e',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 20,
      exerciseCount: 12,
      lessonCount: 6,
    ),
    LessonTopic(
      id: '4',
      title: 'Құттықтау',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/75b44b0e9c2e5d305fa323c6c51d3476.jpg?eb44609a896ad503fe04cabfec9b1c6a',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 22,
      exerciseCount: 14,
      lessonCount: 7,
    ),
    LessonTopic(
      id: '5',
      title: 'Келбет',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/aaa036e4cb16038f90e128d8e39c714f.jpg?f186818af74507e8790dc3a302283433',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 28,
      exerciseCount: 16,
      lessonCount: 9,
    ),
    LessonTopic(
      id: '6',
      title: 'Мінез',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/a42a2aa6c7440291c38ba9adc5892a56.jpg?3baeaa45dcc3a9edcf65fdb81fa95e62',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 24,
      exerciseCount: 13,
      lessonCount: 8,
    ),
    LessonTopic(
      id: '7',
      title: 'Мамандық',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/048731097de322302aff7e52151c991d.jpg?d1e25f4d079eb0de5690a520593af222',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 35,
      exerciseCount: 20,
      lessonCount: 12,
    ),
    LessonTopic(
      id: '8',
      title: 'Апта күндері',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/d6e7bc44feb1613d041d5385e5745b10.jpg?8d8122c8e8975416e40b674a372b57ff',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 14,
      exerciseCount: 10,
      lessonCount: 5,
    ),
    LessonTopic(
      id: '9',
      title: 'Мекенжай',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/938a195f8810cb9b31c6503221891897.jpg?9d7af7dec722d3758df7eab129676d15',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 26,
      exerciseCount: 15,
      lessonCount: 8,
    ),
    LessonTopic(
      id: '10',
      title: 'Менің үйім',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/948378d6a67ac0d7c7c6728581b072ab.jpg?0a04078e3dea959298e1607ebd40f1dc',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 32,
      exerciseCount: 18,
      lessonCount: 10,
    ),
    LessonTopic(
      id: '11',
      title: 'Уақыт',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/73608782f50eb6af17bb69bdcd662692.jpg?4dbe9159a89827455c492f72f82b2816',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 18,
      exerciseCount: 12,
      lessonCount: 6,
    ),
    LessonTopic(
      id: '12',
      title: 'Ауа райы',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/d722f2a14a84b7ad8053262f61a6106b.jpg?6f006c45081fa08bc369f122f7a933f0',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 21,
      exerciseCount: 14,
      lessonCount: 7,
    ),
    LessonTopic(
      id: '13',
      title: 'Түстер',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/b8292acafd72142128a3481ac4b0abff.jpg?43dcf21be7ef4b5732f37eba614dedd5',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 16,
      exerciseCount: 11,
      lessonCount: 5,
    ),
    LessonTopic(
      id: '14',
      title: 'Азық түлік',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/e7c0584255fa6f2981e510285a9e9e4f.jpg?ac73bf473ca801c3afdc355a595132bf',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 40,
      exerciseCount: 25,
      lessonCount: 15,
    ),
    LessonTopic(
      id: '15',
      title: 'Киім',
      imageUrl:
          'https://tilqural.kz/assets/images/lessons/85b62d4a27ea43297eb1ab349b6e06c6.jpg?a6353c2baa3fc282f7550eb3103767f1',
      level: 'A1',
      progress: 0.0,
      vocabularyCount: 29,
      exerciseCount: 17,
      lessonCount: 9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бастапқы деңгей'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          final topic = topics[index];
          return _BeginnerTopicCard(
            topic: topic,
            onTap: () => _navigateToLessonDetail(context, topic),
          );
        },
      ),
    );
  }

  void _navigateToLessonDetail(BuildContext context, LessonTopic topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(topic: topic),
      ),
    );
  }
}

class _BeginnerTopicCard extends StatelessWidget {
  final LessonTopic topic;
  final VoidCallback? onTap;
  const _BeginnerTopicCard({required this.topic, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        topic.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image,
                              color: Colors.grey, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF222B45),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            topic.level,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF8F9BB3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatItem(
                                  Icons.book, topic.vocabularyCount.toString()),
                              const SizedBox(width: 16),
                              _buildStatItem(Icons.fitness_center,
                                  topic.exerciseCount.toString()),
                              const SizedBox(width: 16),
                              _buildStatItem(Icons.play_circle_fill,
                                  topic.lessonCount.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (topic.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                // Прогресс-бар
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Прогресс',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8F9BB3),
                          ),
                        ),
                        Text(
                          '${(topic.progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: topic.progress,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F3F6),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4ECDC4)),
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

  Widget _buildStatItem(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF8F9BB3),
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8F9BB3),
          ),
        ),
      ],
    );
  }
}
