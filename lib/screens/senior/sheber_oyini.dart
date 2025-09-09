import 'package:chiclet/chiclet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';

import '../junior/sound_hunters.dart';

class SheberOyiniScreen extends StatefulWidget {
  const SheberOyiniScreen({super.key});

  @override
  State<SheberOyiniScreen> createState() => _SheberOyiniScreenState();
}

class _SheberOyiniScreenState extends State<SheberOyiniScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 0;
  int _correctAnswers = 0;

  void _nextTask() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _onCorrectAnswer() {
    setState(() {
      _correctAnswers++;
    });
    _nextTask();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Табыс!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Сіз $_correctAnswers/10 тапсырманы дұрыс орындадыңыз!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Сөйлем құру бойынша дағдыларыңыз өте жақсы!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Тамам',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF58CC02),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentPage + 1) / 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                Task1CreateFromImage(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2IdentifySentenceTypes(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3ListenAndCreate(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4MakeComplex(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5ChangeSentenceType(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6ImagineAndCreate(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7CorrectSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8ConnectSentences(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9CombineSentences(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10ListenAndContinue(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Create sentences from image
class Task1CreateFromImage extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1CreateFromImage(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1CreateFromImage> createState() => _Task1CreateFromImageState();
}

class _Task1CreateFromImageState extends State<Task1CreateFromImage> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final List<String> answers = [
    'Оқушылар мектеп алдында тұр.',
    'Оқушылар мектеп алдында тұр, ал ұстаз оларды күліп қарсы алды.',
    'Оқушылар мектеп алдында тұр, өйткені олар ұстаздарын құттықтауға келген.'
  ];

  final List<String> labels = [
    'Толық сөйлем',
    'Күрделі сөйлем',
    'Құрмалас сөйлем'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Суреттен сөйлем құра',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Мектеп алдында оқушылар тұр,\nқолдарында гүлдер, ұстаз күліп \n қарсы алып тұр.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Сөйлем түрін таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: ChicletAnimatedButton(
                                onPressed: showNotification
                                    ? () {}
                                    : () => _selectAnswer(index),
                                width: 300,
                                height: 50,
                                backgroundColor:
                                    selectedAnswer == answers[index]
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemBlue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    answers[index].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 2: Identify sentence types
class Task2IdentifySentenceTypes extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2IdentifySentenceTypes(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2IdentifySentenceTypes> createState() =>
      _Task2IdentifySentenceTypesState();
}

class _Task2IdentifySentenceTypesState
    extends State<Task2IdentifySentenceTypes> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  int currentQuestion = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'sentence': 'Ержан таңертең ерте тұрды.',
      'correctType': 'Толық сөйлем',
      'options': ['Толық сөйлем', 'Күрделі сөйлем', 'Құрмалас сөйлем']
    },
    {
      'sentence': 'Ол серуенге шығуға дайындалды, бірақ жаңбыр жауып кетті.',
      'correctType': 'Күрделі сөйлем',
      'options': ['Толық сөйлем', 'Күрделі сөйлем', 'Құрмалас сөйлем']
    },
    {
      'sentence': 'Сондықтан ол үйде отырып, кітап оқыды.',
      'correctType': 'Құрмалас сөйлем',
      'options': ['Толық сөйлем', 'Күрделі сөйлем', 'Құрмалас сөйлем']
    },
  ];

  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == questions[currentQuestion]['correctType'];
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    } else {
      _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
      HapticFeedback.heavyImpact();
    }
  }

  void _continue() {
    if (isCorrect!) {
      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          showNotification = false;
          isCorrect = null;
          selectedAnswer = null;
        });
      } else {
        widget.onCorrect();
      }
    } else {
      setState(() {
        showNotification = false;
        isCorrect = null;
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Сөйлем түрін тап',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Text(
                '${currentQuestion + 1}/3',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  question['sentence'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Сөйлем түрін таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: question['options'].map<Widget>((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: AnimatedButton(
                          onPressed: showNotification
                              ? () {}
                              : () => _selectAnswer(option),
                          width: 300,
                          height: 50,
                          color: selectedAnswer == option
                              ? (isCorrect!
                                  ? const Color(0xFF58CC02)
                                  : Colors.red)
                              : const Color(0xFF87CEEB),
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 3: Listen and create
class Task3ListenAndCreate extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3ListenAndCreate(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3ListenAndCreate> createState() => _Task3ListenAndCreateState();
}

class _Task3ListenAndCreateState extends State<Task3ListenAndCreate> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final List<String> answers = [
    'Балалар ауыл ішінде ойнап жүр.',
    'Ауыл сыртында мал жайылып жүр, ал балалар ауыл ішінде ойнап жүр.',
    'Ауыл сыртында мал жайылып жүр, өйткені күн жылы және жаймашуақ.'
  ];

  final List<String> labels = [
    'Толық сөйлем',
    'Күрделі сөйлем',
    'Құрмалас сөйлем'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/village_description.mp3'));
    } catch (e) {
      // Audio file not found, continue without audio
    }
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Тыңда және сөйлем құрастыр',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: _playAudio,
                      child: const Icon(Icons.volume_up,
                          size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Ауыл сыртында мал жайылып жүр,\nал ауылдың ішінде балалар ойнап жүр.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Сөйлем түрін таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 50,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 4: Make sentence complex
class Task4MakeComplex extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4MakeComplex(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4MakeComplex> createState() => _Task4MakeComplexState();
}

class _Task4MakeComplexState extends State<Task4MakeComplex> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String originalSentence = 'Бала сурет салып отыр.';
  final List<String> answers = [
    'Бала сурет салып отыр, ал сіңлісі кітап оқып отыр.',
    'Бала сурет салып отыр, өйткені оған сурет салу ұнайды.'
  ];
  final List<String> labels = ['Күрделі сөйлем', 'Құрмалас сөйлем'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Сөйлемді күрделендір',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  originalSentence,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Күрделендірілген нұсқаны таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 60,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 5: Change sentence type
class Task5ChangeSentenceType extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5ChangeSentenceType(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5ChangeSentenceType> createState() =>
      _Task5ChangeSentenceTypeState();
}

class _Task5ChangeSentenceTypeState extends State<Task5ChangeSentenceType> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String originalSentence =
      'Анасы ас әзірлеп жатыр, ал әкесі бау-бақшада жұмыс істеп жүр.';
  final List<String> answers = [
    'Анасы ас әзірлеп жатыр.',
    'Анасы ас әзірлеп жатыр, өйткені қонақ келеді.'
  ];
  final List<String> labels = ['Толық сөйлем', 'Құрмалас сөйлем'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Сөйлем түрін өзгерт',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Берілген күрделі сөйлем:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  originalSentence,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Өзгертілген нұсқаны таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 60,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 6: Imagine and create
class Task6ImagineAndCreate extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6ImagineAndCreate(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6ImagineAndCreate> createState() => _Task6ImagineAndCreateState();
}

class _Task6ImagineAndCreateState extends State<Task6ImagineAndCreate> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String scenario = 'Теңіз жағасында';
  final List<String> answers = [
    'Мен теңіз жағасында отырмын.',
    'Мен теңіз жағасында отырмын, ал досым суретке түсіп жүр.',
    'Мен теңіз жағасында отырмын, өйткені демалысқа келдік.'
  ];
  final List<String> labels = [
    'Толық сөйлем',
    'Күрделі сөйлем',
    'Құрмалас сөйлем'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Елестету арқылы сөйлем құру',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.beach_access,
                          size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        scenario,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Сөйлем түрін таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 50,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 7: Correct sentence
class Task7CorrectSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7CorrectSentence(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7CorrectSentence> createState() => _Task7CorrectSentenceState();
}

class _Task7CorrectSentenceState extends State<Task7CorrectSentence> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String incorrectSentence = 'Балалар мектепке барады және күн шуақты.';
  final List<String> answers = [
    'Балалар мектепке барады, өйткені күн шуақты.',
    'Балалар мектепке барады, ал күн шуақты.',
    'Балалар мектепке барады. Күн шуақты.'
  ];
  final String correctAnswer = 'Балалар мектепке барады, өйткені күн шуақты.';

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    } else {
      _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
      HapticFeedback.heavyImpact();
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        showNotification = false;
        isCorrect = null;
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Қате сөйлемді түзет',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Қате сөйлем:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  incorrectSentence,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Дұрыс нұсқаны таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: answers.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: AnimatedButton(
                          onPressed: showNotification
                              ? () {}
                              : () => _selectAnswer(answer),
                          width: 300,
                          height: 50,
                          color: selectedAnswer == answer
                              ? (isCorrect!
                                  ? const Color(0xFF58CC02)
                                  : Colors.red)
                              : const Color(0xFF87CEEB),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              answer,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 8: Connect sentences
class Task8ConnectSentences extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8ConnectSentences(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8ConnectSentences> createState() => _Task8ConnectSentencesState();
}

class _Task8ConnectSentencesState extends State<Task8ConnectSentences> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String originalSentence = 'Әлия дүкенге барды.';
  final List<String> answers = [
    'Әлия дүкенге барды, ал інісі үйде қалды.',
    'Әлия дүкенге барды, өйткені ол нан алмақшы болды.'
  ];
  final List<String> labels = ['Күрделі сөйлем', 'Құрмалас сөйлем'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Сөйлем қос',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  originalSentence,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Қосылған нұсқаны таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 60,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 9: Combine sentences
class Task9CombineSentences extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9CombineSentences(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9CombineSentences> createState() => _Task9CombineSentencesState();
}

class _Task9CombineSentencesState extends State<Task9CombineSentences> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final List<String> originalSentences = [
    'Күн шықты.',
    'Құстар ұшты.',
    'Гүлдер ашылды.'
  ];

  final List<String> answers = [
    'Күн шықты, құстар ұшты, ал гүлдер ашылды.',
    'Күн шықты, сондықтан құстар ұшты және гүлдер ашылды.'
  ];
  final List<String> labels = ['Күрделі сөйлем', 'Құрмалас сөйлем'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Сөйлемдерді біріктір',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Берілген сөйлемдер:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: originalSentences.map((sentence) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              sentence,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Біріктірілген нұсқаны таңдаңыз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 60,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 10: Listen and continue
class Task10ListenAndContinue extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10ListenAndContinue(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10ListenAndContinue> createState() =>
      _Task10ListenAndContinueState();
}

class _Task10ListenAndContinueState extends State<Task10ListenAndContinue> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  bool showNotification = false;
  bool? isCorrect;
  String? selectedAnswer;

  final String prompt = 'Асхат спорт алаңында жаттығып жатыр, ал достары…';
  final List<String> answers = [
    'Асхат спорт алаңында жаттығып жатыр, ал достары трибунадан қарап отыр.',
    'Асхат спорт алаңында жаттығып жатыр, өйткені ол жарысқа дайындалып жүр.'
  ];
  final List<String> labels = ['Күрделі сөйлем', 'Құрмалас сөйлем'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/sports_training.mp3'));
    } catch (e) {
      // Audio file not found, continue without audio
    }
  }

  void _selectAnswer(int index) {
    if (showNotification) return;

    setState(() {
      selectedAnswer = answers[index];
      isCorrect = true;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      HapticFeedback.lightImpact();
    }
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.57,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            minBlastForce: 20,
            maxBlastForce: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Тыңда және жалғастыр',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: _playAudio,
                      child: const Icon(Icons.volume_up,
                          size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  prompt,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Жалғастырып бітіріңіз:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AnimatedButton(
                              onPressed: showNotification
                                  ? () {}
                                  : () => _selectAnswer(index),
                              width: 300,
                              height: 60,
                              color: selectedAnswer == answers[index]
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFF87CEEB),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  answers[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}
