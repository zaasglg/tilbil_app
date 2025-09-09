import 'package:chiclet/chiclet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
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
                decoration: const BoxDecoration(
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

class SoundHuntersScreen extends StatefulWidget {
  const SoundHuntersScreen({super.key});

  @override
  State<SoundHuntersScreen> createState() => _SoundHuntersScreenState();
}

class _SoundHuntersScreenState extends State<SoundHuntersScreen> {
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
                Task1ListenAndFind(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2FindVowels(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3BuildWord(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4FindLessVowels(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5BuildSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6SaySound(onCorrect: _nextTask),
                Task7BuildFromLetters(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8ThickThin(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9RepeatSound(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10Riddle(onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1ListenAndFind extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1ListenAndFind(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1ListenAndFind> createState() => _Task1ListenAndFindState();
}

class _Task1ListenAndFindState extends State<Task1ListenAndFind> {
  final List<String> letters = ['м', 'а', 'т'];
  late ConfettiController _confettiController;
  String? selectedLetter;
  bool? isCorrect;
  bool showNotification = false;

  // Audio player for segment playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    letters.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _checkAnswer(String letter) {
    setState(() {
      selectedLetter = letter;
      isCorrect = letter == 'а';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
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
      widget.onNext();
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
                'Дыбысты тыңдап тап',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? const Color(0xFF45A049)
                        : const Color(0xFF58CC02),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58CC02).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AnimatedButton(
                    onPressed: () {
                      soundService.playSegment(9500, 10500);
                    },
                    width: 120,
                    height: 120,
                    color: Colors.transparent,
                    child: _isPlaying
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.volume_up,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: letters.map((letter) {
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _checkAnswer(letter),
                    width: 90,
                    height: 90,
                    color: _getButtonColor(letter),
                    child: Text(
                      letter,
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }).toList(),
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

  Color _getButtonColor(String letter) {
    if (selectedLetter == null) return const Color(0xFF87CEEB);

    if (selectedLetter == letter) {
      return isCorrect! ? const Color(0xFF58CC02) : Colors.red;
    }
    return const Color(0xFF87CEEB);
  }
}

class Task2FindVowels extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2FindVowels(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2FindVowels> createState() => _Task2FindVowelsState();
}

class _Task2FindVowelsState extends State<Task2FindVowels> {
  final List<String> letters = ['а', 'с', 'ө', 'н', 'ү', 'т', 'о'];
  final Set<String> vowels = {'а', 'ө', 'ү', 'о'};
  final Set<String> selectedLetters = {};
  late ConfettiController _confettiController;
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    letters.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectLetter(String letter) {
    setState(() {
      if (vowels.contains(letter)) {
        selectedLetters.add(letter);
        if (selectedLetters.length == vowels.length) {
          isCorrect = true;
          showNotification = true;
          _playSound(true);
          _confettiController.play();
        }
      } else {
        isCorrect = false;
        showNotification = true;
        _playSound(false);
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
      widget.onNext();
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Дауысты дыбысты тап',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: letters.map((letter) {
                  bool isSelected = selectedLetters.contains(letter);
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectLetter(letter),
                    width: 60,
                    height: 60,
                    color: isSelected
                        ? const Color(0xFF58CC02)
                        : const Color(0xFF87CEEB),
                    child: Text(
                      letter,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }).toList(),
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

class Task3BuildWord extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3BuildWord(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3BuildWord> createState() => _Task3BuildWordState();
}

class _Task3BuildWordState extends State<Task3BuildWord> {
  final List<String> letters = ['б', 'а', 'л', 'а', 'т', 'о', 'р', 'қ'];
  final List<String> correctWords = [
    'бала',
    'тор',
    'ала',
    'бал',
    'бата',
    'ор',
    'бор',
    'тоқ',
    'ат',
    'ара',
    'ақ'
  ];
  List<String> builtWord = [];
  bool isWordIncorrect = false;
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    letters.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _addLetter(String letter) {
    setState(() {
      builtWord.add(letter);
      isWordIncorrect = false;
    });

    String word = builtWord.join();

    if (correctWords.contains(word) &&
        _canBuildWord(word) &&
        word.length >= 2) {
      bool isExactMatch = true;
      for (String correctWord in correctWords) {
        if (correctWord.startsWith(word) &&
            correctWord.length > word.length &&
            _canBuildWord(correctWord)) {
          isExactMatch = false;
          break;
        }
      }

      if (isExactMatch) {
        setState(() {
          isCorrect = true;
          showNotification = true;
        });
        _playSound(true);
        _confettiController.play();
      }
    } else if (!_canLeadToCorrectWord(word)) {
      setState(() {
        isWordIncorrect = true;
        isCorrect = false;
        showNotification = true;
      });
      _playSound(false);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  bool _canBuildWord(String word) {
    List<String> availableLetters = List.from(letters);
    for (String char in word.split('')) {
      if (availableLetters.contains(char)) {
        availableLetters.remove(char);
      } else {
        return false;
      }
    }
    return true;
  }

  bool _canLeadToCorrectWord(String currentWord) {
    for (String correctWord in correctWords) {
      if (correctWord.startsWith(currentWord) && _canBuildWord(correctWord)) {
        return true;
      }
    }
    return false;
  }

  void _clearWord() {
    setState(() {
      builtWord.clear();
      isWordIncorrect = false;
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөз құрастыр',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isWordIncorrect ? Colors.red : Colors.blue,
                      width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    builtWord.join(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: letters.map((letter) {
                    return AnimatedButton(
                      onPressed:
                          showNotification ? () {} : () => _addLetter(letter),
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: Text(
                        letter,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: showNotification ? () {} : _clearWord,
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: const Icon(Icons.clear, color: Colors.white, size: 30),
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

class Task4FindLessVowels extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4FindLessVowels(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task4FindLessVowels> createState() => _Task4FindLessVowelsState();
}

class _Task4FindLessVowelsState extends State<Task4FindLessVowels> {
  final List<Map<String, dynamic>> words = [
    {'word': 'алма', 'vowels': 2, 'image': 'assets/images/apple.jpg'},
    {'word': 'дала', 'vowels': 2, 'image': 'assets/images/derevnia.jpg'},
    {'word': 'гүл', 'vowels': 1, 'image': 'assets/images/flower.jpg'},
  ];
  String? selectedWord;
  bool? isCorrect;
  bool showNotification = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    words.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectWord(String word) {
    setState(() {
      selectedWord = word;
      isCorrect = word == 'гүл';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
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
      widget.onNext();
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Дауысты дыбысы аз сөзді тап',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: words.take(2).map((wordData) {
                      String word = wordData['word'];
                      Color backgroundColor = Colors.white;
                      Color borderColor = const Color(0xFFE5E5E5);

                      if (selectedWord == word) {
                        if (isCorrect!) {
                          backgroundColor = const Color(0xFF58CC02);
                          borderColor = const Color(0xFF58CC02);
                        } else {
                          backgroundColor = const Color(0xFFFF4B4B);
                          borderColor = const Color(0xFFFF4B4B);
                        }
                      }

                      return GestureDetector(
                        onTap:
                            showNotification ? () {} : () => _selectWord(word),
                        child: Container(
                          width: 150,
                          height: 160,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                wordData['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                word,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: words.skip(2).map((wordData) {
                      String word = wordData['word'];
                      Color backgroundColor = Colors.white;
                      Color borderColor = const Color(0xFFE5E5E5);

                      if (selectedWord == word) {
                        if (isCorrect!) {
                          backgroundColor = const Color(0xFF58CC02);
                          borderColor = const Color(0xFF58CC02);
                        } else {
                          backgroundColor = const Color(0xFFFF4B4B);
                          borderColor = const Color(0xFFFF4B4B);
                        }
                      }

                      return GestureDetector(
                        onTap:
                            showNotification ? () {} : () => _selectWord(word),
                        child: Container(
                          width: 150,
                          height: 160,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                wordData['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                word,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
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

class Task5BuildSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5BuildSentence(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task5BuildSentence> createState() => _Task5BuildSentenceState();
}

class _Task5BuildSentenceState extends State<Task5BuildSentence> {
  final List<Map<String, String>> words = [
    {'word': 'өрік'},
    {'word': 'ауылда'},
    {'word': 'терді'},
    {'word': 'апа'},
  ];
  List<String> sentence = [];
  final List<String> correctOrder = ['апа', 'ауылда', 'өрік', 'терді'];
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    words.shuffle();
    correctOrder.clear();
    correctOrder.addAll(words.map((e) => e['word']!));
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _addToSentence(String word) {
    setState(() {
      sentence.add(word);
    });

    if (sentence.length == correctOrder.length) {
      setState(() {
        isCorrect = sentence.join(' ') == correctOrder.join(' ');
        showNotification = true;
      });
      _playSound(isCorrect!);
      if (isCorrect!) {
        _confettiController.play();
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
      widget.onNext();
    }
  }

  void _clearSentence() {
    setState(() {
      sentence.clear();
    });
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөйлем құрастыр',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    sentence.join(' '),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: words.map((wordData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ChicletAnimatedButton(
                        backgroundColor: Colors.lightBlue,
                        onPressed: showNotification
                            ? () {}
                            : () => _addToSentence(wordData['word']!),
                        width: 200,
                        height: 60,
                        // color: Colors.white,
                        child: Text(
                          wordData['word']!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _clearSentence,
                width: 60,
                height: 60,
                color: Colors.grey,
                child: const Icon(Icons.clear, color: Colors.white, size: 30),
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

class Task6SaySound extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6SaySound({super.key, required this.onCorrect});
  @override
  State<Task6SaySound> createState() => _Task6SaySoundState();
}

class _Task6SaySoundState extends State<Task6SaySound> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onCorrect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Task7BuildFromLetters extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7BuildFromLetters(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task7BuildFromLetters> createState() => _Task7BuildFromLettersState();
}

class _Task7BuildFromLettersState extends State<Task7BuildFromLetters> {
  final List<String> letters = ['ж', 'е', 'ә'];
  List<String> word = [];
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    letters.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _addLetter(String letter) {
    setState(() {
      word.add(letter);
    });

    if (word.length == 3) {
      setState(() {
        isCorrect = word.join() == 'әже';
        showNotification = true;
      });
      _playSound(isCorrect!);
      if (isCorrect!) {
        _confettiController.play();
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
      widget.onNext();
    }
  }

  void _clearWord() {
    setState(() {
      word.clear();
    });
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Әріптерден сөз құрастыр',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    word.join(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: letters.map((letter) {
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _addLetter(letter),
                    width: 60,
                    height: 60,
                    color: Colors.white,
                    child: Text(
                      letter,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _clearWord,
                width: 60,
                height: 60,
                color: Colors.grey,
                child: const Icon(Icons.clear, color: Colors.white, size: 30),
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

class Task8ThickThin extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8ThickThin(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task8ThickThin> createState() => _Task8ThickThinState();
}

class _Task8ThickThinState extends State<Task8ThickThin> {
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Жуан';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
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
      widget.onNext();
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Жуан/Жіңішке',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'қала',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Жуан', 'Жіңішке'].map((answer) {
                  Color backgroundColor = Colors.white;

                  if (selectedAnswer == answer) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectAnswer(answer),
                    width: 120,
                    height: 50,
                    color: backgroundColor,
                    child: Text(
                      answer,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
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

class Task9RepeatSound extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9RepeatSound(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task9RepeatSound> createState() => _Task9RepeatSoundState();
}

class _Task9RepeatSoundState extends State<Task9RepeatSound> {
  final List<String> letters = ['А', 'О', 'Ы', 'І'];
  int clickedCount = 0;
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    letters.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playSound(String letter) {
    // setState(() {
    //   clickedCount++;
    // });

    print(letter);

    switch (letter) {
      case "А":
        soundService.playSegment(9500, 10500);
        break;
      case "О":
        soundService.playSegment(20500, 21300);
        break;
      case "Ы":
        soundService.playSegment(21400, 22600);
        break;
      case "І":
        soundService.playSegment(22700, 23800);
        break;
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Дыбысты қайталау',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: letters.map((letter) {
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _playSound(letter),
                    width: 70,
                    height: 70,
                    color: Colors.white,
                    child: Text(
                      letter,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              AnimatedButton(
                onPressed: () {
                  setState(() {
                    isCorrect = true;
                    showNotification = true;
                  });
                },
                width: 200,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text(
                  'Жалғастыру',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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

class Task10Riddle extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10Riddle(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task10Riddle> createState() => _Task10RiddleState();
}

class _Task10RiddleState extends State<Task10Riddle> {
  final List<String> options = ['дауысты дыбыс', 'дауыссыз дыбыс', 'сөз'];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    options.shuffle();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'дауысты дыбыс';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
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
      widget.onNext();
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Жұмбақ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Аузымды ашсам – ән саламын,\nЖабылсам – үнсіз қаламын.\nМен кіммін?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: options.map((option) {
                    Color backgroundColor = Colors.white;

                    if (selectedAnswer == option) {
                      if (isCorrect!) {
                        backgroundColor = const Color(0xFF58CC02);
                      } else {
                        backgroundColor = const Color(0xFFFF4B4B);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _selectAnswer(option),
                        width: 300,
                        height: 60,
                        color: backgroundColor,
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
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
