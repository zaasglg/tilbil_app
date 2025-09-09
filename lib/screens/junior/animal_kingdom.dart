import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';

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

class AnimalKingdomScreen extends StatefulWidget {
  const AnimalKingdomScreen({super.key});

  @override
  State<AnimalKingdomScreen> createState() => _AnimalKingdomScreenState();
}

class _AnimalKingdomScreenState extends State<AnimalKingdomScreen> {
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
                Task1AnimalSounds(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2AnimalNames(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3AnimalHabitats(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4AnimalFood(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5AnimalBabies(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6AnimalSizes(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7AnimalGroups(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8AnimalFeatures(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9AnimalMovement(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10AnimalRiddle(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1AnimalSounds extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1AnimalSounds(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1AnimalSounds> createState() => _Task1AnimalSoundsState();
}

class _Task1AnimalSoundsState extends State<Task1AnimalSounds> {
  final List<Map<String, String>> animals = [
    {'name': 'мысық', 'emoji': '🐱'},
    {'name': 'ит', 'emoji': '🐕'},
    {'name': 'тауық', 'emoji': '🐔'},
  ];
  late ConfettiController _confettiController;
  String? selectedAnimal;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String animal) {
    setState(() {
      selectedAnimal = animal;
      isCorrect = animal == 'мысық';
      showNotification = true;
    });
    _playSound(isCorrect!);
    if (isCorrect!) {
      _confettiController.play();
    }
  }

  void _playSound(bool correct) {
    if (correct) {
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  Color _getButtonColor(String animal) {
    if (selectedAnimal == null) return const Color(0xFF87CEEB);
    if (selectedAnimal == animal) {
      return isCorrect! ? const Color(0xFF58CC02) : Colors.red;
    }
    return const Color(0xFF87CEEB);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

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
            colors: const [Colors.purple],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Қай жануардың дыбысы?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () async {
                        await _audioPlayer.play(AssetSource('audio/cat.mp3'));
                      },
                      child: const Center(
                        child: Icon(Icons.volume_up,
                            size: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: animals.map((animal) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(animal['name']!),
                        width: 200,
                        height: 80,
                        color: _getButtonColor(animal['name']!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(animal['emoji']!,
                                style: const TextStyle(fontSize: 30)),
                            const SizedBox(height: 3),
                            Text(
                              animal['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
}

class Task2AnimalNames extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2AnimalNames(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2AnimalNames> createState() => _Task2AnimalNamesState();
}

class _Task2AnimalNamesState extends State<Task2AnimalNames> {
  final List<Map<String, String>> options = [
    {'name': 'қасқыр', 'emoji': '🐺'},
    {'name': 'түлкі', 'emoji': '🦊'},
    {'name': 'аю', 'emoji': '🐻'},
  ];
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'түлкі';
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
                'Қандай жануар суретте бейнеленген?',
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
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    '🦊',
                    style: TextStyle(fontSize: 100),
                  ),
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
                            : () => _checkAnswer(option['name']!),
                        width: 250,
                        height: 60,
                        color: _getButtonColor(option['name']!),
                        child: Text(
                          option['name']!,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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

// Additional task classes with similar structure...
class Task3AnimalHabitats extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3AnimalHabitats(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3AnimalHabitats> createState() => _Task3AnimalHabitatsState();
}

class _Task3AnimalHabitatsState extends State<Task3AnimalHabitats> {
  final List<String> options = ['теңіз', 'орман', 'дала'];
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'орман';
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
                'Қасқыр қайда тұрады?',
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
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    '🐺',
                    style: TextStyle(fontSize: 100),
                  ),
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
                        color: _getButtonColor(option),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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

// Placeholder classes for remaining tasks - following same pattern
class Task4AnimalFood extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4AnimalFood(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task4AnimalFood> createState() => _Task4AnimalFoodState();
}

class _Task4AnimalFoodState extends State<Task4AnimalFood> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'шөп';
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
                'Сиыр не жейді?',
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
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🐄', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['шөп', 'ет', 'балық'].map((option) {
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

class Task5AnimalBabies extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5AnimalBabies(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task5AnimalBabies> createState() => _Task5AnimalBabiesState();
}

class _Task5AnimalBabiesState extends State<Task5AnimalBabies> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'балапан';
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
                'Тауықтың балапаны қалай аталады?',
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
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🐔', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['балапан', 'бұзау', 'көшет'].map((option) {
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

class Task6AnimalSizes extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6AnimalSizes(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task6AnimalSizes> createState() => _Task6AnimalSizesState();
}

class _Task6AnimalSizesState extends State<Task6AnimalSizes> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'піл';
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
                'Қай жануар ең үлкен?',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 80),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    {'name': 'піл', 'emoji': '🐘'},
                    {'name': 'тышқан', 'emoji': '🐭'},
                    {'name': 'мысық', 'emoji': '🐱'},
                  ].map((animal) {
                    return AnimatedButton(
                      onPressed: showNotification
                          ? () {}
                          : () => _checkAnswer(animal['name']!),
                      width: 90,
                      height: 110,
                      color: selectedOption == null
                          ? const Color(0xFF87CEEB)
                          : (selectedOption == animal['name']
                              ? (isCorrect!
                                  ? const Color(0xFF58CC02)
                                  : Colors.red)
                              : const Color(0xFF87CEEB)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(animal['emoji']!,
                              style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 5),
                          Text(animal['name']!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
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

class Task7AnimalGroups extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7AnimalGroups(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task7AnimalGroups> createState() => _Task7AnimalGroupsState();
}

class _Task7AnimalGroupsState extends State<Task7AnimalGroups> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'жабайы';
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
                'Арыстан қандай жануар?',
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
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🦁', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['үй', 'жабайы', 'теңіз'].map((option) {
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

class Task8AnimalFeatures extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8AnimalFeatures(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task8AnimalFeatures> createState() => _Task8AnimalFeaturesState();
}

class _Task8AnimalFeaturesState extends State<Task8AnimalFeatures> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'ұзын мойын';
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
                'Керіктің ерекшелігі неде?',
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
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🦒', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      ['ұзын мойын', 'үлкен құлақ', 'ұзын түк'].map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 220,
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
                                fontSize: 18,
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

class Task9AnimalMovement extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9AnimalMovement(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task9AnimalMovement> createState() => _Task9AnimalMovementState();
}

class _Task9AnimalMovementState extends State<Task9AnimalMovement> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'жүзеді';
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
                'Балық қалай қозғалады?',
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
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text('🐟', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['жүзеді', 'жүгіреді', 'ұшады'].map((option) {
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

class Task10AnimalRiddle extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10AnimalRiddle(
      {super.key, required this.onCorrect, required this.onNext});
  @override
  State<Task10AnimalRiddle> createState() => _Task10AnimalRiddleState();
}

class _Task10AnimalRiddleState extends State<Task10AnimalRiddle> {
  late ConfettiController _confettiController;
  String? selectedOption;
  bool? isCorrect;
  bool showNotification = false;

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

  void _checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'түйе';
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
                'Жұмбақ: Өркешті үлкен, сулы құйрығы бар, шөлде жүреді. Бұл кім?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['түйе', 'жылқы', 'піл'].map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 250,
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
