import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:chiclet/chiclet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:til_bil_app/services/sound_service.dart';

class AnswerNotification extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onContinue;

  const AnswerNotification({
    super.key,
    required this.isCorrect,
    required this.onContinue,
  });

  @override
  State<AnswerNotification> createState() => _AnswerNotificationState();
}

class _AnswerNotificationState extends State<AnswerNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding:
            const EdgeInsets.only(top: 40), // Space for the overflowing Lottie
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // This is the colored notification box
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.isCorrect
                    ? const Color(0xFF58CC02)
                    : const Color(0xFFFF4B4B),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.isCorrect
                                ? 'Өте жақсы!'.toUpperCase()
                                : 'Қате!'.toUpperCase(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 80), // Space for Lottie
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ChicletAnimatedButton(
                        width: double.infinity,
                        height: 60.0,
                        backgroundColor: Colors.white,
                        buttonColor: Colors.grey,
                        onPressed: widget.onContinue,
                        // borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: Text(
                            'Жалғастыру',
                            style: TextStyle(
                              color: widget.isCorrect
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFFFF4B4B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned Lottie
            Positioned(
              right: 20,
              top: -40, // Half of height 80
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset(
                  widget.isCorrect
                      ? 'assets/lottie/correct.json'
                      : 'assets/lottie/incorrect.json',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SentenceBuilderScreen extends StatefulWidget {
  const SentenceBuilderScreen({super.key});

  @override
  State<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {
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
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            const SizedBox(height: 20),
            const Text(
              'Сен жарайсың!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '10-нан $_correctAnswers сұраққа дұрыс жауап бердің!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B4B4B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 34),
            SizedBox(
              width: double.infinity,
              child: ChicletAnimatedButton(
                height: 60.0,
                backgroundColor: CupertinoColors.activeGreen,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Text(
                    'Жақсы!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
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
                Task1BuildWord(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2MatchPhrases(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3ConnectWords(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4SpeechRecognition(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5ColorDescription(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6AnimalName(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7NatureDescription(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8BuildTwoWords(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9ColorAndObject(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10TimeDescription(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1BuildWord extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1BuildWord(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1BuildWord> createState() => _Task1BuildWordState();
}

class _Task1BuildWordState extends State<Task1BuildWord> {
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String combinedWord = '';
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _onAccept(String word) {
    setState(() {
      combinedWord += word;
      if (combinedWord == 'үшбұрыш') {
        isCorrect = true;
        showNotification = true;
        _playSound(true);
        _confettiController.play();
        _confettiControllerLeft.play();
        _confettiControllerRight.play();
      }
    });
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        combinedWord = '';
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Сөзді құрастыр',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Drag targets for the words
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Draggable<String>(
                    data: 'үш',
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'үш',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'үш',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF87CEEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'үш',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Draggable<String>(
                    data: 'бұрыш',
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'бұрыш',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'бұрыш',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'бұрыш',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Drop target
              DragTarget<String>(
                onAccept: _onAccept,
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: combinedWord.isEmpty
                          ? Colors.white
                          : const Color(0xFF58CC02),
                      border: Border.all(
                        color: combinedWord.isEmpty
                            ? Colors.grey[300]!
                            : const Color(0xFF58CC02),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        combinedWord.isEmpty
                            ? 'Сөздерді осында сүйреп апарыңыз'
                            : combinedWord,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: combinedWord.isEmpty
                              ? Colors.grey[500]
                              : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              if (combinedWord.isNotEmpty && combinedWord != 'үшбұрыш')
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          combinedWord = '';
                        });
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: const Center(
                        child: Text(
                          'Тазалау',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
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

class Task2MatchPhrases extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2MatchPhrases(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2MatchPhrases> createState() => _Task2MatchPhrasesState();
}

class _Task2MatchPhrasesState extends State<Task2MatchPhrases> {
  final List<String> options = ['ақ гүл', 'қара мысық', 'сары шаш'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'ақ гүл';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Дұрыс тіркесті тап',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_florist,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Суретке сәйкес сөз тіркесін таңда:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task3ConnectWords extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3ConnectWords(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3ConnectWords> createState() => _Task3ConnectWordsState();
}

class _Task3ConnectWordsState extends State<Task3ConnectWords> {
  final List<String> options = ['түйеқұс', 'арыстан', 'піл'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'түйеқұс';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Жануарды тап',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Суретте көрсетілген жануарды таңда:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task4SpeechRecognition extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4SpeechRecognition(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4SpeechRecognition> createState() => _Task4SpeechRecognitionState();
}

class _Task4SpeechRecognitionState extends State<Task4SpeechRecognition> {
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String spokenText = '';
  bool isListening = false;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() => isListening = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        spokenText = 'қызыл алма';
        isListening = false;
        isCorrect = spokenText.contains('қызыл алма');
        showNotification = true;
      });
      _playSound(isCorrect!);
      if (isCorrect!) {
        _confettiController.play();
        _confettiControllerLeft.play();
        _confettiControllerRight.play();
      }
    });
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        spokenText = '';
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Дауыстап айт',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.apple,
                    size: 100,
                    color: Colors.red[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Суретте көрсетілгенді дауыстап айт:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Text(
                    spokenText.isEmpty ? 'Тыңдалуда...' : spokenText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _startListening,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isListening
                        ? const Color(0xFFFF4B4B)
                        : const Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isListening ? Icons.stop : Icons.mic,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showNotification)
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

// Remaining task classes with similar structure
class Task5ColorDescription extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5ColorDescription(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5ColorDescription> createState() => _Task5ColorDescriptionState();
}

class _Task5ColorDescriptionState extends State<Task5ColorDescription> {
  final List<String> options = ['алтын күн', 'күміс ай', 'көк аспан'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'алтын күн';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Дауыстап сипатта',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.wb_sunny,
                    size: 100,
                    color: Colors.orange[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task6AnimalName extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6AnimalName(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6AnimalName> createState() => _Task6AnimalNameState();
}

class _Task6AnimalNameState extends State<Task6AnimalName> {
  final List<String> options = ['қоңыр қоян', 'ақ қоян', 'сұр қоян'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'қоңыр қоян';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Жануарды сипатта',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.cruelty_free,
                    size: 100,
                    color: Colors.brown[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task7NatureDescription extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7NatureDescription(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7NatureDescription> createState() => _Task7NatureDescriptionState();
}

class _Task7NatureDescriptionState extends State<Task7NatureDescription> {
  final List<String> options = ['көк тау', 'ақ бұлт', 'жасыл шөп'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'көк тау';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Табиғатты сипатта',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.landscape,
                    size: 100,
                    color: Colors.blue[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task8BuildTwoWords extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8BuildTwoWords(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8BuildTwoWords> createState() => _Task8BuildTwoWordsState();
}

class _Task8BuildTwoWordsState extends State<Task8BuildTwoWords> {
  final Map<String, String> pairs = {'жасыл': 'шөп', 'ақ': 'қар'};
  final List<String> selectedPairs = [];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _selectPair(String key, String value) {
    if (pairs[key] == value) {
      setState(() {
        selectedPairs.add('$key-$value');
      });
      if (selectedPairs.length == 2) {
        setState(() {
          isCorrect = true;
          showNotification = true;
        });
        _playSound(true);
        _confettiController.play();
        _confettiControllerLeft.play();
        _confettiControllerRight.play();
      }
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedPairs.clear();
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Сөз тіркестерін құра',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: pairs.keys
                        .map((key) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GestureDetector(
                                onTap: () => _selectPair(key, pairs[key]!),
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF58CC02),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      key,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  Column(
                    children: pairs.values
                        .map((value) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task9ColorAndObject extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9ColorAndObject(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9ColorAndObject> createState() => _Task9ColorAndObjectState();
}

class _Task9ColorAndObjectState extends State<Task9ColorAndObject> {
  final List<String> options = ['көк балық', 'тәтті нан', 'алтын күн'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'көк балық';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Дұрыс тіркесті тап',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Логикалық дұрыс тіркесті таңда:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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

class Task10TimeDescription extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10TimeDescription(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10TimeDescription> createState() => _Task10TimeDescriptionState();
}

class _Task10TimeDescriptionState extends State<Task10TimeDescription> {
  final List<String> options = ['алтын сағат', 'темір сағат', 'күміс сағат'];
  late ConfettiController _confettiController;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'алтын сағат';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      setState(() {
        selectedAnswer = null;
        showNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti widgets
        Positioned(
          bottom: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerLeft,
            blastDirection: -math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confettiControllerRight,
            blastDirection: -3 * math.pi / 4,
            maxBlastForce: 50,
            minBlastForce: 30,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.02,
            colors: const [
              Color(0xFF58CC02),
              Color(0xFF89E219),
              Color(0xFF1CB0F6),
              Color(0xFFCE82FF),
              Color(0xFFFFC800),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Заттарды сипатта',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.access_time,
                    size: 100,
                    color: Colors.amber[400],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: selectedAnswer == option
                                    ? (isCorrect == true
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFFFF4B4B))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedAnswer == option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        if (showNotification)
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
