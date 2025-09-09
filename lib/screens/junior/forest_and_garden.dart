import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';
import 'dart:math';

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

class ForestAndGardenScreen extends StatefulWidget {
  const ForestAndGardenScreen({super.key});

  @override
  State<ForestAndGardenScreen> createState() => _ForestAndGardenScreenState();
}

class _ForestAndGardenScreenState extends State<ForestAndGardenScreen> {
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
                Task1TreeTypes(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2FlowerNames(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3PlantParts(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4TreeFruits(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5PlantGrowth(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6Seasons(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7GardenTools(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8PlantCare(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9ForestAnimals(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10PlantRiddle(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1TreeTypes extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1TreeTypes(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1TreeTypes> createState() => _Task1TreeTypesState();
}

class _Task1TreeTypesState extends State<Task1TreeTypes> {
  late List<Map<String, String>> options;
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = [
      {'name': 'қайың', 'emoji': '🌳'},
      {'name': 'қарағай', 'emoji': '🌲'},
      {'name': 'алма ағашы', 'emoji': '🌳'},
    ]..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'қарағай';
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
                'Қандай ағаш жылда жасыл тұрады?',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option['name']!),
                        width: 280,
                        height: 70,
                        color: _getButtonColor(option['name']!),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(option['emoji']!,
                                style: const TextStyle(fontSize: 30)),
                            const SizedBox(width: 16),
                            Text(
                              option['name']!,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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

  Color _getButtonColor(String option) {
    if (selectedOption == null) return const Color(0xFF87CEEB);
    if (selectedOption == option) {
      return isCorrect! ? const Color(0xFF58CC02) : Colors.red;
    }
    return const Color(0xFF87CEEB);
  }
}

class Task2FlowerNames extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2FlowerNames(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2FlowerNames> createState() => _Task2FlowerNamesState();
}

class _Task2FlowerNamesState extends State<Task2FlowerNames> {
  late List<String> options;
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['раушан', 'лале', 'қызғалдақ']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'раушан';
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
                'Бұл қандай гүл?',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 60),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: const Text('🌹', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

// Task3 to Task10 classes follow the same pattern
class Task3PlantParts extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3PlantParts(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task3PlantParts> createState() => _Task3PlantPartsState();
}

class _Task3PlantPartsState extends State<Task3PlantParts> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['тамыр', 'жапырақ', 'гүл']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'тамыр';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Өсімдіктің жер астындағы бөлігі не деп аталады?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

// Similar pattern for Task4-Task10
class Task4TreeFruits extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4TreeFruits(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task4TreeFruits> createState() => _Task4TreeFruitsState();
}

class _Task4TreeFruitsState extends State<Task4TreeFruits> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['алма', 'банан', 'апельсин']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'алма';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Қандай жеміс ағаштан өседі?',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 60),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🍎', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task5PlantGrowth extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5PlantGrowth(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task5PlantGrowth> createState() => _Task5PlantGrowthState();
}

class _Task5PlantGrowthState extends State<Task5PlantGrowth> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['су және күн сәулесі', 'тек су', 'тек топырақ']
      ..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'су және күн сәулесі';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Өсімдіктер өсу үшін неге мұқтаж?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 280,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task6Seasons extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6Seasons(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task6Seasons> createState() => _Task6SeasonsState();
}

class _Task6SeasonsState extends State<Task6Seasons> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['көктем', 'жаз', 'күз']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'көктем';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Жапырақтар қашан түсе бастайды?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task7GardenTools extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7GardenTools(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task7GardenTools> createState() => _Task7GardenToolsState();
}

class _Task7GardenToolsState extends State<Task7GardenTools> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['күрек', 'қасық', 'қалам']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'күрек';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Топырақты қопару үшін не қолданады?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task8PlantCare extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8PlantCare(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task8PlantCare> createState() => _Task8PlantCareState();
}

class _Task8PlantCareState extends State<Task8PlantCare> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['суару', 'кесу', 'ойлау']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'суару';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Өсімдіктерді қалай күтеміз?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task9ForestAnimals extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9ForestAnimals(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task9ForestAnimals> createState() => _Task9ForestAnimalsState();
}

class _Task9ForestAnimalsState extends State<Task9ForestAnimals> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['қоян', 'арыстан', 'жылан']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'қоян';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
              const Text('Ормандаго қай жануар сәбіз жейді?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}

class Task10PlantRiddle extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10PlantRiddle(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task10PlantRiddle> createState() => _Task10PlantRiddleState();
}

class _Task10PlantRiddleState extends State<Task10PlantRiddle> {
  late ConfettiController _confettiController;
  late List<String> options;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    options = ['ағаш', 'гүл', 'шөп']..shuffle(Random());

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'ағаш';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) _confettiController.play();
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
                  'Жұмбақ: Биік те, қатты, жапырақты. Көлеңкеде серуенгелуге қолайлы. Бұл не?',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 200,
                        height: 60,
                        color: selectedOption == null
                            ? const Color(0xFF87CEEB)
                            : (selectedOption == option
                                ? (isCorrect!
                                    ? const Color(0xFF58CC02)
                                    : Colors.red)
                                : const Color(0xFF87CEEB)),
                        child: Text(option,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                  isCorrect: isCorrect!, onContinue: _continue)),
      ],
    );
  }
}
