import 'package:flutter/material.dart';
import '../../models/lesson_topic.dart';

class VocabularyScreen extends StatefulWidget {
  final LessonTopic topic;

  const VocabularyScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<VocabularyWord> words = [
    VocabularyWord(
      id: '1',
      kazakh: 'Сәлем',
      russian: 'Привет',
      english: 'Hello',
      pronunciation: 'Сәлем',
      example: 'Сәлем, қалың қалай?',
      exampleTranslation: 'Привет, как дела?',
      isLearned: true,
    ),
    VocabularyWord(
      id: '2',
      kazakh: 'Танысу',
      russian: 'Знакомиться',
      english: 'Meet',
      pronunciation: 'Таныс-у',
      example: 'Менімен танысыңыз',
      exampleTranslation: 'Знакомьтесь со мной',
      isLearned: false,
    ),
    VocabularyWord(
      id: '3',
      kazakh: 'Есім',
      russian: 'Имя',
      english: 'Name',
      pronunciation: 'Е-сім',
      example: 'Менің есімім Асем',
      exampleTranslation: 'Меня зовут Асем',
      isLearned: false,
    ),
    VocabularyWord(
      id: '4',
      kazakh: 'Жас',
      russian: 'Возраст',
      english: 'Age',
      pronunciation: 'Жас',
      example: 'Сіздің жасыңыз нешеде?',
      exampleTranslation: 'Сколько вам лет?',
      isLearned: false,
    ),
    VocabularyWord(
      id: '5',
      kazakh: 'Мектеп',
      russian: 'Школа',
      english: 'School',
      pronunciation: 'Мек-теп',
      example: 'Мен мектепке барамын',
      exampleTranslation: 'Я иду в школу',
      isLearned: false,
    ),
    VocabularyWord(
      id: '6',
      kazakh: 'Жұмыс',
      russian: 'Работа',
      english: 'Work',
      pronunciation: 'Жұ-мыс',
      example: 'Менің жұмысым қызықты',
      exampleTranslation: 'Моя работа интересная',
      isLearned: false,
    ),
  ];

  bool showTranslation = true;

  @override
  Widget build(BuildContext context) {
    final learnedWords = words.where((w) => w.isLearned).length;
    final totalWords = words.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topic.title} - Сөздікқор'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              showTranslation ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF4ECDC4),
            ),
            onPressed: () {
              setState(() {
                showTranslation = !showTranslation;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(learnedWords, totalWords),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return _buildWordCard(words[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startQuiz,
        backgroundColor: const Color(0xFF4ECDC4),
        icon: const Icon(Icons.quiz),
        label: const Text('Тест тапсыру'),
      ),
    );
  }

  Widget _buildProgressHeader(int learned, int total) {
    final progress = total > 0 ? learned / total : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Үйренген сөздер',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222B45),
                ),
              ),
              Text(
                '$learned/$total',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ECDC4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4ECDC4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(VocabularyWord word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: () => _toggleWordLearned(word),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word.kazakh,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222B45),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '[${word.pronunciation}]',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            word.isLearned
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: word.isLearned ? Colors.green : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () => _toggleWordLearned(word),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                            color: Color(0xFF4ECDC4),
                          ),
                          onPressed: () => _playPronunciation(word),
                        ),
                      ],
                    ),
                  ],
                ),
                if (showTranslation) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.translate,
                              size: 16,
                              color: Color(0xFF4ECDC4),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              word.russian,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF222B45),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '• ${word.english}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.format_quote,
                            size: 16,
                            color: Color(0xFF8F9BB3),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Мысал:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8F9BB3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.example,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      if (showTranslation) ...[
                        const SizedBox(height: 4),
                        Text(
                          word.exampleTranslation,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleWordLearned(VocabularyWord word) {
    setState(() {
      word.isLearned = !word.isLearned;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          word.isLearned ? 'Сөз үйренілді!' : 'Сөз үйренілмеді деп белгіленді',
        ),
        backgroundColor: word.isLearned ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _playPronunciation(VocabularyWord word) {
    // Здесь можно добавить воспроизведение аудио
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Дыбыстау: ${word.pronunciation}'),
        backgroundColor: const Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _startQuiz() {
    final learnedWords = words.where((w) => w.isLearned).toList();

    if (learnedWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Алдымен сөздерді үйреніңіз!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Тест тапсыру'),
        content: Text(
            '${learnedWords.length} үйренген сөз бойынша тест тапсырасыз ба?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Жоқ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Здесь можно добавить навигацию к экрану теста
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Тест экраны әзірлену үстінде...'),
                  backgroundColor: Color(0xFF4ECDC4),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
            ),
            child: const Text('Ия'),
          ),
        ],
      ),
    );
  }
}

class VocabularyWord {
  final String id;
  final String kazakh;
  final String russian;
  final String english;
  final String pronunciation;
  final String example;
  final String exampleTranslation;
  bool isLearned;

  VocabularyWord({
    required this.id,
    required this.kazakh,
    required this.russian,
    required this.english,
    required this.pronunciation,
    required this.example,
    required this.exampleTranslation,
    this.isLearned = false,
  });
}
