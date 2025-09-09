import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_button/animated_button.dart';
import 'dart:math';
import '../../widgets/animated_button.dart';
import '../junior/sound_hunters.dart';

class TynysBelgileriScreen extends StatefulWidget {
  const TynysBelgileriScreen({super.key});

  @override
  State<TynysBelgileriScreen> createState() => _TynysBelgileriScreenState();
}

class _TynysBelgileriScreenState extends State<TynysBelgileriScreen> {
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
              Icons.library_books,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            const SizedBox(height: 20),
            const Text(
              'Тыныс белгілерін үйрендің!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '10-нан $_correctAnswers тапсырманы орындадың!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B4B4B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: const Center(
                    child: Text(
                      'Жарайсың!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                      color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentPage + 1) / 10,
                      child: Container(
                        decoration: BoxDecoration(
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
                Task1ListenAndAddPunctuation(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2AddPunctuation(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3WriteSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4ArrangeSentences(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5FindMissingPunctuation(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6FindMainIdea(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7ListenAndWrite(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8WritePlan(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9AddPunctuationToText(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10ReadWithPauses(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Listen and add punctuation
class Task1ListenAndAddPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1ListenAndAddPunctuation(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1ListenAndAddPunctuation> createState() =>
      _Task1ListenAndAddPunctuationState();
}

class _Task1ListenAndAddPunctuationState
    extends State<Task1ListenAndAddPunctuation> {
  final TextEditingController _controller = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    setState(() => _isPlaying = true);
    // Note: You'll need to add the actual audio file for this task
    // await _audioPlayer.play(AssetSource('audio/task1_punctuation.mp3'));
    await Future.delayed(const Duration(seconds: 3)); // Simulate audio duration
    setState(() => _isPlaying = false);
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim();
    final correctAnswer = 'Мен дүкенге бардым, бірақ нан алмадым.';
    setState(() {
      isCorrect = userAnswer == correctAnswer;
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Сөйлемді тыңдап, тыныс белгісін қойып жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Сөйлемді осында жазыңыз...',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: _isPlaying ? null : _playAudio,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.volume_up,
                        color: const Color(0xFF58CC02),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controller.text.isNotEmpty && !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controller.text.isNotEmpty && !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 2: Add punctuation to text
class Task2AddPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2AddPunctuation(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2AddPunctuation> createState() => _Task2AddPunctuationState();
}

class _Task2AddPunctuationState extends State<Task2AddPunctuation> {
  final TextEditingController _controller = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;
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
    final userAnswer = _controller.text.trim();
    final correctAnswer = 'Бүгін біз мектепке ерте келдік.';
    setState(() {
      isCorrect = userAnswer == correctAnswer;
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Мәтінді оқып, тыныс белгісін қой.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Бүгін біз мектепке ерте келдік',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Тыныс белгісін қойып жазыңыз...',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controller.text.isNotEmpty && !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controller.text.isNotEmpty && !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 3: Write sentence with given words
class Task3WriteSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3WriteSentence(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3WriteSentence> createState() => _Task3WriteSentenceState();
}

class _Task3WriteSentenceState extends State<Task3WriteSentence> {
  final TextEditingController _controller = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;
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
    final userAnswer = _controller.text.trim();
    final correctAnswer = 'Қар жапалақтап жауды.';
    setState(() {
      isCorrect = userAnswer == correctAnswer;
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Берілген сөздермен сөйлем жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Қар, жапалақтап, жауды',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Сөйлемді жазыңыз...',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controller.text.isNotEmpty && !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controller.text.isNotEmpty && !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 4: Arrange sentences in order
class Task4ArrangeSentences extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4ArrangeSentences(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4ArrangeSentences> createState() => _Task4ArrangeSentencesState();
}

class _Task4ArrangeSentencesState extends State<Task4ArrangeSentences> {
  List<String> arrangedSentences = [];
  final List<String> sentences = [
    'Аспан бұлттанып кетті.',
    'Кенет жаңбыр жауа бастады.',
    'Балалар саябақта ойнады.',
  ];
  bool showNotification = false;
  bool? isCorrect;
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

  void _addSentence(String sentence) {
    setState(() {
      if (!arrangedSentences.contains(sentence)) {
        arrangedSentences.add(sentence);
      }
    });

    if (arrangedSentences.length == sentences.length) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    final correctOrder = [
      'Балалар саябақта ойнады.',
      'Аспан бұлттанып кетті.',
      'Кенет жаңбыр жауа бастады.',
    ];
    setState(() {
      isCorrect = arrangedSentences.join() == correctOrder.join();
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

  void _clearArrangement() {
    setState(() {
      arrangedSentences.clear();
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Сөйлемдерді ретімен қой.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: arrangedSentences.map((sentence) {
                    return Text(
                      '${arrangedSentences.indexOf(sentence) + 1}. $sentence',
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sentences.map((sentence) {
                        return AnimatedButton(
                          onPressed: arrangedSentences.contains(sentence)
                              ? () {}
                              : () => _addSentence(sentence),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: arrangedSentences.contains(sentence)
                              ? Colors.grey
                              : const Color(0xFF87CEEB),
                          child: Text(
                            sentence,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: arrangedSentences.isNotEmpty
                          ? _clearArrangement
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      color: arrangedSentences.isNotEmpty
                          ? Colors.red
                          : Colors.grey,
                      child: const Text(
                        'Тазалау',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
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

// Task 5: Find missing punctuation
class Task5FindMissingPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5FindMissingPunctuation(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5FindMissingPunctuation> createState() =>
      _Task5FindMissingPunctuationState();
}

class _Task5FindMissingPunctuationState
    extends State<Task5FindMissingPunctuation> {
  String? selectedAnswer;
  final List<String> options = [
    'нүкте',
    'үтір',
    'сұрақ белгісі',
    'леп белгісі'
  ];
  bool showNotification = false;
  bool? isCorrect;
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
      isCorrect = answer == 'үтір';
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Қай тыныс белгі жоқ?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Бүгін біз ауылға бардық онда әжем тұрады.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...options.map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: () => _selectAnswer(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: selectedAnswer == option
                              ? const Color(0xFF58CC02)
                              : const Color(0xFF87CEEB),
                          child: Text(
                            option,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }).toList(),
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

// Task 6: Find main idea
class Task6FindMainIdea extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6FindMainIdea(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6FindMainIdea> createState() => _Task6FindMainIdeaState();
}

class _Task6FindMainIdeaState extends State<Task6FindMainIdea> {
  String? selectedAnswer;
  final List<String> options = [
    'Бала ұйықтап қалды',
    'Таңертең табиғат әсем болды',
    'Құстар ұя салды'
  ];
  bool showNotification = false;
  bool? isCorrect;
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
      isCorrect = answer == 'Таңертең табиғат әсем болды';
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Негізгі ойды таңда.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Таңертең күн шықты. Құстар сайрады. Бала үйінен далаға жүгіріп шықты.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...options.map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: () => _selectAnswer(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: selectedAnswer == option
                              ? const Color(0xFF58CC02)
                              : const Color(0xFF87CEEB),
                          child: Text(
                            option,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }).toList(),
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

// Task 7: Listen and write
class Task7ListenAndWrite extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7ListenAndWrite(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7ListenAndWrite> createState() => _Task7ListenAndWriteState();
}

class _Task7ListenAndWriteState extends State<Task7ListenAndWrite> {
  final TextEditingController _controller = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    setState(() => _isPlaying = true);
    // Note: You'll need to add the actual audio file for this task
    // await _audioPlayer.play(AssetSource('audio/task7_punctuation.mp3'));
    await Future.delayed(const Duration(seconds: 3)); // Simulate audio duration
    setState(() => _isPlaying = false);
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim();
    final correctAnswer = 'Анасы ас әзірледі, ал әкесі бақшаны суғарды.';
    setState(() {
      isCorrect = userAnswer == correctAnswer;
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Тыңдап жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Естіген сөйлемді жазыңыз...',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: _isPlaying ? null : _playAudio,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.volume_up,
                        color: const Color(0xFF58CC02),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controller.text.isNotEmpty && !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controller.text.isNotEmpty && !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 8: Write plan
class Task8WritePlan extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8WritePlan(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8WritePlan> createState() => _Task8WritePlanState();
}

class _Task8WritePlanState extends State<Task8WritePlan> {
  final List<TextEditingController> _controllers =
      List.generate(3, (_) => TextEditingController());
  bool showNotification = false;
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswers = _controllers.map((c) => c.text.trim()).toList();
    final correctAnswers = [
      'Ауылға бару',
      'Өзен жағасында серуен',
      'От басында ән айту'
    ];
    setState(() {
      isCorrect = userAnswers.join() == correctAnswers.join();
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Мәтінге 3 тармақты жоспар жаз.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Кеше біз ауылға бардық. Өзен жағасында серуендедік. Кешке от жағып, ән айттық.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            hintText: '${index + 1}. тармақ',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controllers.every((c) => c.text.isNotEmpty) &&
                        !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controllers.every((c) => c.text.isNotEmpty) &&
                        !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 9: Add punctuation to text
class Task9AddPunctuationToText extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9AddPunctuationToText(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9AddPunctuationToText> createState() =>
      _Task9AddPunctuationToTextState();
}

class _Task9AddPunctuationToTextState extends State<Task9AddPunctuationToText> {
  final TextEditingController _controller = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;
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
    final userAnswer = _controller.text.trim();
    final correctAnswer =
        'Аспанда бұлт жиналды, жел күшейді. Жаңбыр жауа бастады. Балалар үйге қарай жүгірді.';
    setState(() {
      isCorrect = userAnswer == correctAnswer;
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Тыныс белгілерін қой.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Аспанда бұлт жиналды жел күшейді жаңбыр жауа бастады Балалар үйге қарай жүгірді',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Тыныс белгілерін қойып жазыңыз...',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                onPressed: _controller.text.isNotEmpty && !showNotification
                    ? _checkAnswer
                    : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color: _controller.text.isNotEmpty && !showNotification
                    ? const Color(0xFF58CC02)
                    : Colors.grey,
                child: const Text(
                  'Тексеру',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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

// Task 10: Read with pauses
class Task10ReadWithPauses extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10ReadWithPauses(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10ReadWithPauses> createState() => _Task10ReadWithPausesState();
}

class _Task10ReadWithPausesState extends State<Task10ReadWithPauses> {
  bool showNotification = false;
  bool? isCorrect;
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

  void _completeTask() {
    setState(() {
      isCorrect = true;
      showNotification = true;
    });
    _playSound(true);
    _confettiController.play();
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
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
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
              const SizedBox(height: 20),
              const Text(
                'Мәтінді дұрыс паузамен дауыстап оқы.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Көктем келді, күн жылынды. Далада құстардың әні естіледі.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Пауза мен интонация сақталуы керек.',
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 40),
              AnimatedButton(
                onPressed: !showNotification ? _completeTask : () {},
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                color:
                    !showNotification ? const Color(0xFF58CC02) : Colors.grey,
                child: const Text(
                  'Оқып болдым',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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
