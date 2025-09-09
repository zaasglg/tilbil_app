import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:confetti/confetti.dart';
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
                            widget.isCorrect ? 'Дұрыс!' : 'Қате!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                        child: Center(
                          child: Text(
                            'Жалғастыру',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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

class JiktikSeptikJalgauScreen extends StatefulWidget {
  const JiktikSeptikJalgauScreen({super.key});

  @override
  State<JiktikSeptikJalgauScreen> createState() =>
      _JiktikSeptikJalgauScreenState();
}

class _JiktikSeptikJalgauScreenState extends State<JiktikSeptikJalgauScreen> {
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
                backgroundColor: Colors.white,
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
                Task1ListenAndChoose(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2PutInCase(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3WriteWithPossessive(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4CompleteSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5ListenAndChooseCase(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6FillIn(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7MakeSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8FindAffix(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9ListenAndWrite(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10AddAffixes(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1ListenAndChoose extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1ListenAndChoose(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1ListenAndChoose> createState() => _Task1ListenAndChooseState();
}

class _Task1ListenAndChooseState extends State<Task1ListenAndChoose> {
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
      isCorrect = answer == '-мын';
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
                'Тыңдау (Жіктік жалғау) – «Дұрыс жалғауды тап»',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02),
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
                      soundService.playSegment(206000, 211000);
                      // soundService.stopAudio();
                    },
                    width: 120,
                    height: 120,
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.volume_up,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['-мын', '-сың', '-мыз'].map((option) {
                  Color color = Colors.white;
                  if (selectedAnswer == option) {
                    color = isCorrect! ? const Color(0xFF58CC02) : Colors.red;
                  }
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectAnswer(option),
                    width: 120,
                    height: 60,
                    color: color,
                    child: Text(option,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task2PutInCase extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2PutInCase(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2PutInCase> createState() => _Task2PutInCaseState();
}

class _Task2PutInCaseState extends State<Task2PutInCase> {
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
      isCorrect = answer == 'Досқа';
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
                '«Дос» сөзін барыс септігіне қой.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Доспен', 'Досқа', 'Досты'].map((option) {
                  Color color = Colors.white;
                  if (selectedAnswer == option) {
                    color = isCorrect! ? const Color(0xFF58CC02) : Colors.red;
                  }
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectAnswer(option),
                    width: 120,
                    height: 60,
                    color: color,
                    child: Text(option,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task3WriteWithPossessive extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3WriteWithPossessive(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3WriteWithPossessive> createState() =>
      _Task3WriteWithPossessiveState();
}

class _Task3WriteWithPossessiveState extends State<Task3WriteWithPossessive> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer.toLowerCase() == 'кітабым';
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
                '«Суретке қарап жаз» 🖊 Суретте – бір оқушының кітабы. «Кітап» сөзін бірінші жақтағы тәуелдік жалғауымен жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Жауабыңызды жазыңыз',
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task4CompleteSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4CompleteSentence(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4CompleteSentence> createState() => _Task4CompleteSentenceState();
}

class _Task4CompleteSentenceState extends State<Task4CompleteSentence> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer.toLowerCase() == 'сен ән айтасың';
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
                '"Сен ән айта…" – сөйлемін аяқтап айт.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Сөйлеміңізді жазыңыз',
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task5ListenAndChooseCase extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5ListenAndChooseCase(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5ListenAndChooseCase> createState() =>
      _Task5ListenAndChooseCaseState();
}

class _Task5ListenAndChooseCaseState extends State<Task5ListenAndChooseCase> {
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
      isCorrect = answer == 'Табыс септік';
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
                '🎧 Тыңда: "Мен кітапты оқыдым" – сөйлеміндегі «кітапты» қай септік екенін таңда:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Табыс септік', 'Ілік септік', 'Шығыс септік']
                    .map((option) {
                  Color color = Colors.white;
                  if (selectedAnswer == option) {
                    color = isCorrect! ? const Color(0xFF58CC02) : Colors.red;
                  }
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectAnswer(option),
                    width: 150,
                    height: 60,
                    color: color,
                    child: Text(option,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task6FillIn extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6FillIn({super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6FillIn> createState() => _Task6FillInState();
}

class _Task6FillInState extends State<Task6FillIn> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer == '–і' || answer == '-і';
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
                'үйім, үйің, үй__ (ол – оның үйі). Бос жерге дұрыс жалғауды жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Жалғауды жазыңыз',
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task7MakeSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7MakeSentence(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7MakeSentence> createState() => _Task7MakeSentenceState();
}

class _Task7MakeSentenceState extends State<Task7MakeSentence> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer.toLowerCase().contains('мектепке') &&
          answer.toLowerCase().contains('барамын');
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
                '«мектеп, бару» барыс септік қолданып сөйлем құра.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Сөйлеміңізді жазыңыз',
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task8FindAffix extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8FindAffix(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8FindAffix> createState() => _Task8FindAffixState();
}

class _Task8FindAffixState extends State<Task8FindAffix> {
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
      isCorrect = answer == 'Ойнайды';
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
                '«Ойна» етістігінің 3-жақ жекеше жіктік жалғаулы нұсқасын тап.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Ойнаймын', 'Ойнайды', 'Ойнайсың'].map((option) {
                  Color color = Colors.white;
                  if (selectedAnswer == option) {
                    color = isCorrect! ? const Color(0xFF58CC02) : Colors.red;
                  }
                  return AnimatedButton(
                    onPressed:
                        showNotification ? () {} : () => _selectAnswer(option),
                    width: 120,
                    height: 60,
                    color: color,
                    child: Text(option,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task9ListenAndWrite extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9ListenAndWrite(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9ListenAndWrite> createState() => _Task9ListenAndWriteState();
}

class _Task9ListenAndWriteState extends State<Task9ListenAndWrite> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer.toLowerCase() == 'дәптерің';
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
                'Тыңда: "Бұл – сенің дәптерің" - сөйлеміндегі тәуелдік жалғаулы сөзді жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Жауабыңызды жазыңыз',
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}

class Task10AddAffixes extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10AddAffixes(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10AddAffixes> createState() => _Task10AddAffixesState();
}

class _Task10AddAffixesState extends State<Task10AddAffixes> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
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
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer1 = _controller1.text.trim();
    String answer2 = _controller2.text.trim();
    String answer3 = _controller3.text.trim();
    setState(() {
      isCorrect = answer1.toLowerCase() == 'кітабым' &&
          answer2.toLowerCase() == 'қалаға' &&
          answer3.toLowerCase() == 'мұғалімге';
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
                'Экранда 3 сөз: қала, кітап, мұғалім.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 10),
              const Text(
                '– «Менің» → тәуелдік жалғауын қос.',
                style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 10),
              const Text(
                '– «Кімге?» → барыс септігін қос.',
                style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Кітап: ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: TextField(
                      controller: _controller1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Менің',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Қала: ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: TextField(
                      controller: _controller2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Кімге?',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Мұғалім: ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: TextField(
                      controller: _controller3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Кімге?',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: showNotification ? () {} : _checkAnswer,
                width: 150,
                height: 50,
                color: const Color(0xFF58CC02),
                child: const Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
                isCorrect: isCorrect!, onContinue: _continue),
          ),
      ],
    );
  }
}
