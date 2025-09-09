import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chiclet/chiclet.dart';
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

class MagicSyllablesLand extends StatefulWidget {
  const MagicSyllablesLand({super.key});

  @override
  State<MagicSyllablesLand> createState() => _MagicSyllablesLandState();
}

class _MagicSyllablesLandState extends State<MagicSyllablesLand> {
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
                Task1ListenAndCount(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2FindStartingLetter(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3BuildWordFromLetters(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4FindOddSyllable(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5RepeatWords(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6MatchSyllables(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7FillMissingLetters(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8MatchSyllables2(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9ArrangeSyllables(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10TypeWord(onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Task1ListenAndCount extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task1ListenAndCount(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1ListenAndCount> createState() => _Task1ListenAndCountState();
}

class _Task1ListenAndCountState extends State<Task1ListenAndCount> {
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

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'үш буын';
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
                'Тыңдап, буынға бөліп жаз',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ChicletAnimatedButton(
                onPressed: () {
                  soundService.playSegment(11200, 13000);
                },
                width: 120,
                height: 120,
                backgroundColor: const Color(0xFF58CC02),
                borderRadius: 60,
                child:
                    const Icon(Icons.volume_up, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 30),
              const Text('Қанша буыннан тұрады?',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),

              // ТРИ БОЛЬШИХ ЯРКИХ КНОПКИ - ДОЛЖНЫ БЫТЬ ВИДНЫ!
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Кнопка 1
                    ChicletAnimatedButton(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      onPressed: showNotification
                          ? () {}
                          : () => _checkAnswer('үш буын'),
                      backgroundColor: Colors.blue,
                      child: const Text(
                        'үш буын',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Кнопка 2
                    ChicletAnimatedButton(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      onPressed: showNotification
                          ? () {}
                          : () => _checkAnswer('екі буын'),
                      backgroundColor: Colors.orange,
                      child: const Text(
                        'екі буын',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Кнопка 3
                    ChicletAnimatedButton(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      onPressed: showNotification
                          ? () {}
                          : () => _checkAnswer('төрт буын'),
                      backgroundColor: Colors.purple,
                      child: const Text(
                        'төрт буын',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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

class Task2FindStartingLetter extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task2FindStartingLetter(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2FindStartingLetter> createState() =>
      _Task2FindStartingLetterState();
}

class _Task2FindStartingLetterState extends State<Task2FindStartingLetter> {
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

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'алма';
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
    List<Map<String, String>> options = [
      {'name': 'алма', 'emoji': '🍎'},
      {'name': 'үй', 'emoji': '🏠'},
      {'name': 'тасбақа', 'emoji': '🐢'},
      {'name': 'күн', 'emoji': '☀️'},
    ];

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
                '«А» дыбысынан басталатын сөзді тапшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return ChicletAnimatedButton(
                        onPressed: showNotification
                            ? () {}
                            : () => _checkAnswer(option['name']!),
                        width: 160,
                        height: 160,
                        backgroundColor: _getButtonColor(option['name']!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(option['emoji']!,
                                style: const TextStyle(fontSize: 50)),
                            const SizedBox(height: 12),
                            Text(
                              option['name']!,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
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

  Color _getButtonColor(String option) {
    if (selectedAnswer == null) return const Color(0xFF87CEEB);

    if (selectedAnswer == option) {
      return isCorrect! ? const Color(0xFF58CC02) : Colors.red;
    }
    return const Color(0xFF87CEEB);
  }
}

class Task3BuildWordFromLetters extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3BuildWordFromLetters(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3BuildWordFromLetters> createState() =>
      _Task3BuildWordFromLettersState();
}

class _Task3BuildWordFromLettersState extends State<Task3BuildWordFromLetters> {
  List<String> availableLetters = ['с', 'т', 'а'];
  List<String> arrangedLetters = [];
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

  void _checkAnswer() {
    final formedWord = arrangedLetters.join();
    setState(() {
      isCorrect = formedWord == 'тас';
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

  void _removeLetter(String letter) {
    setState(() {
      arrangedLetters.remove(letter);
      availableLetters.add(letter);
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
                'Әріптерден сөз құрастыршы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? Colors.blue[50]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: candidateData.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: arrangedLetters.isEmpty
                          ? const Center(
                              child: Text(
                                'Әріптерді мұнда апарыңыз',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: arrangedLetters.map((letter) {
                                  return GestureDetector(
                                    onTap: () => _removeLetter(letter),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        letter,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    );
                  },
                  onWillAccept: (data) =>
                      data != null && !arrangedLetters.contains(data),
                  onAccept: (data) {
                    setState(() {
                      arrangedLetters.add(data);
                      availableLetters.remove(data);
                    });
                  },
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: availableLetters.map((letter) {
                    return Draggable<String>(
                      data: letter,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (arrangedLetters.length == 3) ...[
                const SizedBox(height: 20),
                ChicletAnimatedButton(
                  onPressed: _checkAnswer,
                  width: 200,
                  height: 60,
                  backgroundColor: const Color(0xFF58CC02),
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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

class Task4FindOddSyllable extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4FindOddSyllable(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4FindOddSyllable> createState() => _Task4FindOddSyllableState();
}

class _Task4FindOddSyllableState extends State<Task4FindOddSyllable> {
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String syllable) {
    setState(() {
      isCorrect = syllable == '-ду';
      showNotification = true;
    });
    _playSound(isCorrect!);
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
    final syllables = ['-най', '-ғай', '-ду', '-за'];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Артық буынды тапшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: syllables
                    .map((syllable) => ChicletAnimatedButton(
                          onPressed: () => _checkAnswer(syllable),
                          width: 150,
                          height: 80,
                          backgroundColor: Colors.orange,
                          child: Text(
                            syllable,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))
                    .toList(),
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

class Task5RepeatWords extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5RepeatWords(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5RepeatWords> createState() => _Task5RepeatWordsState();
}

class _Task5RepeatWordsState extends State<Task5RepeatWords> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Экранда көрсетілген сөзді қайталашы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const Text(
            'үй-рек, жү-рек',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ChicletAnimatedButton(
            onPressed: () => widget.onCorrect(),
            width: 200,
            height: 60,
            backgroundColor: const Color(0xFF58CC02),
            child: const Text(
              'Келесі тапсырма',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Task6MatchSyllables extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6MatchSyllables(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6MatchSyllables> createState() => _Task6MatchSyllablesState();
}

class _Task6MatchSyllablesState extends State<Task6MatchSyllables> {
  Map<String, String> pairs = {'–ақ': '–қу', '– күй': '–ші'};
  Map<String, String?> dropped = {};
  List<String> usedSyllables = [];
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    bool allCorrect = true;
    pairs.forEach((key, value) {
      if (dropped[key] != value) {
        allCorrect = false;
      }
    });
    setState(() {
      isCorrect = allCorrect;
      showNotification = true;
    });
    _playSound(isCorrect!);
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
        dropped.clear();
        usedSyllables.clear();
        showNotification = false;
        isCorrect = null;
      });
    }
  }

  String? _getDroppedKeyForValue(String value) {
    for (var entry in dropped.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var left = pairs.keys.toList();
    var right = pairs.values.toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Буынды сәйкестендір',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Сол жақтағы буынды оң жақтағы сәйкес буынға апарыңыз',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: left
                        .map((syllable) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: dropped.containsKey(syllable)
                                  ? Container(
                                      width: 120,
                                      height: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: Text(
                                        syllable,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : Draggable<String>(
                                      data: syllable,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: 120,
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF58CC02),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            syllable,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: Container(
                                        width: 120,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      child: Container(
                                        width: 120,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF58CC02),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          syllable,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                  Column(
                    children: right
                        .map((syllable) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: DragTarget<String>(
                                builder:
                                    (context, candidateData, rejectedData) {
                                  String? matchedKey =
                                      _getDroppedKeyForValue(syllable);
                                  bool hasData = matchedKey != null;
                                  bool isCorrectMatch =
                                      hasData && pairs[matchedKey] == syllable;

                                  return Container(
                                    width: 120,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: hasData
                                          ? (isCorrectMatch
                                              ? Colors.green[100]
                                              : Colors.red[100])
                                          : candidateData.isNotEmpty
                                              ? Colors.blue[100]
                                              : Colors.grey[100],
                                      border: Border.all(
                                        color: hasData
                                            ? (isCorrectMatch
                                                ? Colors.green
                                                : Colors.red)
                                            : candidateData.isNotEmpty
                                                ? Colors.blue
                                                : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: hasData
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                matchedKey,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                syllable,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            syllable,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  );
                                },
                                onWillAccept: (data) {
                                  return data != null &&
                                      !dropped.containsKey(data);
                                },
                                onAccept: (data) {
                                  setState(() {
                                    // Remove previous connection if exists
                                    dropped.removeWhere(
                                        (key, value) => value == syllable);
                                    dropped[data] = syllable;
                                    usedSyllables.add(data);
                                  });
                                  if (dropped.length == pairs.length) {
                                    Future.delayed(
                                        const Duration(milliseconds: 800), () {
                                      _checkAnswer();
                                    });
                                  }
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              if (dropped.isNotEmpty && dropped.length < pairs.length)
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Жалғастырыңыз... (${dropped.length}/${pairs.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
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

class Task7FillMissingLetters extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7FillMissingLetters(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7FillMissingLetters> createState() =>
      _Task7FillMissingLettersState();
}

class _Task7FillMissingLettersState extends State<Task7FillMissingLetters> {
  String? selectedLetter;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String letter) {
    setState(() {
      selectedLetter = letter;
      isCorrect = letter == 'м';
      showNotification = true;
    });
    _playSound(isCorrect!);
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
    if (isCorrect == true) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final letters = ['м', 'д', 'т'];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Жетпей тұрған әріптерді тауып қойшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'ал_а, _ойын, _оншақ',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: letters
                    .map((letter) => ChicletAnimatedButton(
                          onPressed: () => _checkAnswer(letter),
                          width: 80,
                          height: 80,
                          backgroundColor: Colors.green,
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))
                    .toList(),
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

class Task8MatchSyllables2 extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8MatchSyllables2(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8MatchSyllables2> createState() => _Task8MatchSyllables2State();
}

class _Task8MatchSyllables2State extends State<Task8MatchSyllables2> {
  Map<String, String> pairs = {'- қай': '-шы', '-са': '-ғат'};
  Map<String, String?> dropped = {};
  List<String> usedSyllables = [];
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    bool allCorrect = true;
    pairs.forEach((key, value) {
      if (dropped[key] != value) {
        allCorrect = false;
      }
    });
    setState(() {
      isCorrect = allCorrect;
      showNotification = true;
    });
    _playSound(isCorrect!);
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
    if (isCorrect == true) {
      widget.onCorrect();
    } else {
      setState(() {
        dropped.clear();
        usedSyllables.clear();
        showNotification = false;
        isCorrect = null;
      });
    }
  }

  String? _getDroppedKeyForValue(String value) {
    for (var entry in dropped.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var left = pairs.keys.toList();
    var right = pairs.values.toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Буынды сәйкестендір',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Сол жақтағы буынды оң жақтағы сәйкес буынға апарыңыз',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: left
                        .map((syllable) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: dropped.containsKey(syllable)
                                  ? Container(
                                      width: 120,
                                      height: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: Text(
                                        syllable,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : Draggable<String>(
                                      data: syllable,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: 120,
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            syllable,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: Container(
                                        width: 120,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      child: Container(
                                        width: 120,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          syllable,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                  Column(
                    children: right
                        .map((syllable) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: DragTarget<String>(
                                builder:
                                    (context, candidateData, rejectedData) {
                                  String? matchedKey =
                                      _getDroppedKeyForValue(syllable);
                                  bool hasData = matchedKey != null;
                                  bool isCorrectMatch =
                                      hasData && pairs[matchedKey] == syllable;

                                  return Container(
                                    width: 120,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: hasData
                                          ? (isCorrectMatch
                                              ? Colors.green[100]
                                              : Colors.red[100])
                                          : candidateData.isNotEmpty
                                              ? Colors.orange[100]
                                              : Colors.grey[100],
                                      border: Border.all(
                                        color: hasData
                                            ? (isCorrectMatch
                                                ? Colors.green
                                                : Colors.red)
                                            : candidateData.isNotEmpty
                                                ? Colors.orange
                                                : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: hasData
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                matchedKey,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                syllable,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            syllable,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  );
                                },
                                onWillAccept: (data) {
                                  return data != null &&
                                      !dropped.containsKey(data);
                                },
                                onAccept: (data) {
                                  setState(() {
                                    // Remove previous connection if exists
                                    dropped.removeWhere(
                                        (key, value) => value == syllable);
                                    dropped[data] = syllable;
                                    usedSyllables.add(data);
                                  });
                                  if (dropped.length == pairs.length) {
                                    Future.delayed(
                                        const Duration(milliseconds: 800), () {
                                      _checkAnswer();
                                    });
                                  }
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              if (dropped.isNotEmpty && dropped.length < pairs.length)
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Жалғастырыңыз... (${dropped.length}/${pairs.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
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

class Task9ArrangeSyllables extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9ArrangeSyllables(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9ArrangeSyllables> createState() => _Task9ArrangeSyllablesState();
}

class _Task9ArrangeSyllablesState extends State<Task9ArrangeSyllables> {
  List<String> syllables = ['сал', 'та', 'нат'];
  List<String> arranged = [];
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    setState(() {
      isCorrect = arranged.join('').toLowerCase() == 'салтанат';
      showNotification = true;
    });
    _playSound(isCorrect!);
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
    if (isCorrect == true) {
      widget.onCorrect();
    } else {
      setState(() {
        arranged.clear();
        syllables = ['сал', 'та', 'нат'];
        showNotification = false;
        isCorrect = null;
      });
    }
  }

  void _removeSyllable(String syllable) {
    setState(() {
      arranged.remove(syllable);
      if (!syllables.contains(syllable)) {
        syllables.add(syllable);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Буындарды ретке келтірші',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                '"Салтанат" сөзін құрастырыңыз',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Drop zone for arranged syllables
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? Colors.blue[50]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: candidateData.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: arranged.isEmpty
                          ? const Center(
                              child: Text(
                                'Буындарды мұнда апарыңыз',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: arranged.map((syllable) {
                                  return GestureDetector(
                                    onTap: () => _removeSyllable(syllable),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        syllable,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    );
                  },
                  onWillAccept: (data) =>
                      data != null && !arranged.contains(data),
                  onAccept: (data) {
                    setState(() {
                      arranged.add(data);
                      syllables.remove(data);
                    });
                    // Auto check when all syllables are arranged
                    if (arranged.length == 3) {
                      Future.delayed(const Duration(milliseconds: 800), () {
                        _checkAnswer();
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Available syllables to drag
              Container(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: syllables
                      .map((syllable) => Draggable<String>(
                            data: syllable,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  syllable,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Text(
                                syllable,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                syllable,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Progress indicator
              if (arranged.isNotEmpty && arranged.length < 3)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Жалғастырыңыз... (${arranged.length}/3)',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
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

class Task10TypeWord extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10TypeWord(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10TypeWord> createState() => _Task10TypeWordState();
}

class _Task10TypeWordState extends State<Task10TypeWord> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool? isCorrect;
  bool showNotification = false;

  Future<void> _playWord() async {
    // Placeholder for audio path
    // await _audioPlayer.play(AssetSource('audio/aspan.mp3'));
    soundService.playSegment(13000, 14200);
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = _controller.text.toLowerCase() == 'аспан';
      showNotification = true;
    });
    _playSound(isCorrect!);
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөзді тыңдап, соны теріп жазшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: ChicletAnimatedButton(
                  onPressed: _playWord,
                  width: 120,
                  height: 120,
                  backgroundColor: const Color(0xFF58CC02),
                  borderRadius: 60,
                  child: const Icon(
                    Icons.volume_up,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B4B4B)),
                decoration: InputDecoration(
                  hintText: 'Сөзді жаз',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              ChicletAnimatedButton(
                onPressed: _checkAnswer,
                width: 200,
                height: 60,
                backgroundColor: const Color(0xFF58CC02),
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                    fontSize: 16,
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
