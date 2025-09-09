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

class OurHomeScreen extends StatefulWidget {
  const OurHomeScreen({super.key});

  @override
  State<OurHomeScreen> createState() => _OurHomeScreenState();
}

class _OurHomeScreenState extends State<OurHomeScreen> {
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
                Task1RoomTypes(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2Furniture(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3KitchenItems(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4BathroomItems(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5BedroomItems(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6LivingRoomItems(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7HomeRules(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8SafetyRules(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9HouseholdTasks(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10HomeRiddle(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1RoomTypes extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1RoomTypes(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1RoomTypes> createState() => _Task1RoomTypesState();
}

class _Task1RoomTypesState extends State<Task1RoomTypes> {
  final List<Map<String, String>> options = [
    {'name': 'ас үй', 'emoji': '🍳'},
    {'name': 'жуынатын бөлме', 'emoji': '🛁'},
    {'name': 'жатын бөлме', 'emoji': '🛏️'},
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
      isCorrect = option == 'ас үй';
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
                'Мұнда тамақ дайындайды. Бұл қай бөлме?',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
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

class Task2Furniture extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2Furniture(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2Furniture> createState() => _Task2FurnitureState();
}

class _Task2FurnitureState extends State<Task2Furniture> {
  final List<String> options = ['орындық', 'үстел', 'төсек'];
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
      isCorrect = option == 'орындық';
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
                'Бұнда отырады. Бұл не?',
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
                  child: const Text('🪑', style: TextStyle(fontSize: 100)),
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

class Task3KitchenItems extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3KitchenItems(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3KitchenItems> createState() => _Task3KitchenItemsState();
}

class _Task3KitchenItemsState extends State<Task3KitchenItems> {
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
      isCorrect = option == 'пеш';
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
              const Text('Ас үйде тамақ пісіретін зат қалай аталады?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['пеш', 'тоңазытқыш', 'ыдыс жуғыш'].map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 240,
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

class Task4BathroomItems extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4BathroomItems(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4BathroomItems> createState() => _Task4BathroomItemsState();
}

class _Task4BathroomItemsState extends State<Task4BathroomItems> {
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
      isCorrect = option == 'тіс щеткасы';
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
              const Text('Тісті тазалау үшін не қолданамыз?',
                  style: TextStyle(
                      fontSize: 26,
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
                  child: const Text('🪥', style: TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['тіс щеткасы', 'сүлгі', 'шам'].map((option) {
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

class Task5BedroomItems extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5BedroomItems(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5BedroomItems> createState() => _Task5BedroomItemsState();
}

class _Task5BedroomItemsState extends State<Task5BedroomItems> {
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
      isCorrect = option == 'жастық';
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
              const Text('Ұйықтаған кезде басты қайда қояды?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['жастық', 'көрпе', 'матрас'].map((option) {
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

class Task6LivingRoomItems extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6LivingRoomItems(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6LivingRoomItems> createState() => _Task6LivingRoomItemsState();
}

class _Task6LivingRoomItemsState extends State<Task6LivingRoomItems> {
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
      isCorrect = option == 'теледидар';
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
              const Text('Бұл бөлмеде фильм көреміз. Не қолданамыз?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['теледидар', 'тоңазытқыш', 'кітап'].map((option) {
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

class Task7HomeRules extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7HomeRules(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7HomeRules> createState() => _Task7HomeRulesState();
}

class _Task7HomeRulesState extends State<Task7HomeRules> {
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
      isCorrect = option == 'қолды жуу';
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
              const Text('Үйге келгенде алдымен не істеу керек?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      ['қолды жуу', 'теледидар көру', 'ұйықтау'].map((option) {
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

class Task8SafetyRules extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8SafetyRules(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8SafetyRules> createState() => _Task8SafetyRulesState();
}

class _Task8SafetyRulesState extends State<Task8SafetyRules> {
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
      isCorrect = option == 'жоқ';
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
              const Text('Электр аспаптарымен ойнауға болады ма?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['иә', 'жоқ', 'білмеймін'].map((option) {
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

class Task9HouseholdTasks extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9HouseholdTasks(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9HouseholdTasks> createState() => _Task9HouseholdTasksState();
}

class _Task9HouseholdTasksState extends State<Task9HouseholdTasks> {
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
      isCorrect = option == 'ыдысты жуу';
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
              const Text('Балалар үйде қандай жұмыс істей алады?',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['ыдысты жуу', 'пешпен жұмыс', 'химиялық заттар']
                      .map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option),
                        width: 260,
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

class Task10HomeRiddle extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10HomeRiddle(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10HomeRiddle> createState() => _Task10HomeRiddleState();
}

class _Task10HomeRiddleState extends State<Task10HomeRiddle> {
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
      isCorrect = option == 'есік';
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
                  'Жұмбақ: Ашылады да, жабылады да, адамдарды кіргізеді де, шығарады да. Бұл не?',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B4B))),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['есік', 'терезе', 'шкаф'].map((option) {
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
