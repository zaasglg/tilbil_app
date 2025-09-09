import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_button/animated_button.dart';
import 'dart:math';
import '../../widgets/animated_button.dart';
import '../junior/sound_hunters.dart';

class SozTaptaryScreen extends StatefulWidget {
  const SozTaptaryScreen({super.key});

  @override
  State<SozTaptaryScreen> createState() => _SozTaptaryScreenState();
}

class _SozTaptaryScreenState extends State<SozTaptaryScreen> {
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
              'Сөз таптарын үйрендің!',
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
                Task1SelectNouns(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2SelectAdjectives(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3ChooseAdverb(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4MatchParts(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5FindOdd(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6BuildSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7ChooseNoun(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8IdentifyPart(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9IdentifyVerb(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10FindAdverb(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Select nouns
class Task1SelectNouns extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1SelectNouns(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task1SelectNouns> createState() => _Task1SelectNounsState();
}

class _Task1SelectNounsState extends State<Task1SelectNouns> {
  final Set<String> selectedWords = {};
  final Set<String> correctWords = {'бала', 'бақша'};
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

  void _selectWord(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.add(word);
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedWords.containsAll(correctWords) &&
          selectedWords.length == correctWords.length;
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
                '"Бала бақшада ойнап жүр. Күн шуақты." Мәтіндегі зат есімдерді таңда.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['бала', 'бақша', 'ойнау', 'шуақты'].map((option) {
                      final isSelected = selectedWords.contains(option);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: () => _selectWord(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: isSelected
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedWords.isNotEmpty && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedWords.isNotEmpty && !showNotification
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

// Task 2: Select adjectives
class Task2SelectAdjectives extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2SelectAdjectives(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task2SelectAdjectives> createState() => _Task2SelectAdjectivesState();
}

class _Task2SelectAdjectivesState extends State<Task2SelectAdjectives> {
  final Set<String> selectedWords = {};
  final Set<String> correctWords = {'әсем', 'қызыл'};
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

  void _selectWord(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.add(word);
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedWords.containsAll(correctWords) &&
          selectedWords.length == correctWords.length;
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
                '"Әсем қызыл гүлдер жайқалып тұр." Сын есімдерді белгіле.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['әсем', 'қызыл', 'гүлдер', 'тұр'].map((option) {
                      final isSelected = selectedWords.contains(option);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: () => _selectWord(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: isSelected
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedWords.isNotEmpty && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedWords.isNotEmpty && !showNotification
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

// Task 3: Choose adverb
class Task3ChooseAdverb extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3ChooseAdverb(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task3ChooseAdverb> createState() => _Task3ChooseAdverbState();
}

class _Task3ChooseAdverbState extends State<Task3ChooseAdverb> {
  String? selectedAnswer;
  final String correctAnswer = 'Асығып';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                '"Құмырсқа __ барады." Үстеу таңдау керек.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['Асығып', 'биік', 'орман'].map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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

// Task 4: Match parts
class Task4MatchParts extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4MatchParts(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task4MatchParts> createState() => _Task4MatchPartsState();
}

class _Task4MatchPartsState extends State<Task4MatchParts> {
  Map<String, String> matches = {};
  final Map<String, String> correctMatches = {
    'жүгірді': 'Етістік',
    'әдемі': 'Сын есім',
    'қала': 'Зат есім',
    'баяу': 'Үстеу',
  };
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

  void _selectMatch(String word, String part) {
    setState(() {
      matches[word] = part;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String word in correctMatches.keys) {
        if (matches[word] != correctMatches[word]) {
          isCorrect = false;
          break;
        }
      }
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                'Берілген сөздерді сөз таптарына сәйкестендір.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctMatches.keys.map((word) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$word →',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                'Зат есім',
                                'Етістік',
                                'Сын есім',
                                'Үстеу'
                              ].map((part) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: AnimatedButton(
                                      onPressed: () => _selectMatch(word, part),
                                      width: double.infinity,
                                      height: 50,
                                      color: matches[word] == part
                                          ? const Color(0xFF58CC02)
                                          : const Color(0xFF87CEEB),
                                      child: Text(
                                        part,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: matches.length == 4 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: matches.length == 4
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

// Task 5: Find odd
class Task5FindOdd extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5FindOdd(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task5FindOdd> createState() => _Task5FindOddState();
}

class _Task5FindOddState extends State<Task5FindOdd> {
  String? selectedAnswer;
  final String correctAnswer = 'жазу';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                'Алма, кітап, жазу, мектеп. Артық сөз қайсы?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['алма', 'кітап', 'жазу', 'мектеп'].map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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

// Task 6: Build sentence
class Task6BuildSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6BuildSentence(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task6BuildSentence> createState() => _Task6BuildSentenceState();
}

class _Task6BuildSentenceState extends State<Task6BuildSentence> {
  List<String> sentence = [];
  final List<String> words = ['жылдам', 'оқушы', 'жүгірді'];
  final List<String> correctOrder = ['оқушы', 'жылдам', 'жүгірді'];
  bool showNotification = false;
  bool? isCorrect;
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
                'Берілген сөздерден мағыналы сөйлем құра.',
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
                child: Text(
                  sentence.isEmpty ? 'Сөйлем құрыңыз' : sentence.join(' '),
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: words.map((word) {
                        return AnimatedButton(
                          onPressed: sentence.contains(word)
                              ? () {}
                              : () => _addToSentence(word),
                          width: 100,
                          height: 50,
                          color: sentence.contains(word)
                              ? Colors.grey
                              : const Color(0xFF87CEEB),
                          child: Text(
                            word,
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
                      onPressed: sentence.isNotEmpty ? _clearSentence : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      color: sentence.isNotEmpty ? Colors.red : Colors.grey,
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

// Task 7: Choose noun
class Task7ChooseNoun extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7ChooseNoun(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task7ChooseNoun> createState() => _Task7ChooseNounState();
}

class _Task7ChooseNounState extends State<Task7ChooseNoun> {
  String? selectedAnswer;
  final String correctAnswer = 'Аружан';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                '"Кеше __ орманға барды." Бұл жерге зат есім қою керек.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['қалың', 'Аружан', 'ұшты'].map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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

// Task 8: Identify part
class Task8IdentifyPart extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8IdentifyPart(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task8IdentifyPart> createState() => _Task8IdentifyPartState();
}

class _Task8IdentifyPartState extends State<Task8IdentifyPart> {
  String? selectedAnswer;
  final String correctAnswer = 'сын есім';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                '"Марат биік тауға шықты." "биік" қай сөз табы?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['зат есім', 'сын есім', 'етістік', 'үстеу']
                        .map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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

// Task 9: Identify verb
class Task9IdentifyVerb extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9IdentifyVerb(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task9IdentifyVerb> createState() => _Task9IdentifyVerbState();
}

class _Task9IdentifyVerbState extends State<Task9IdentifyVerb> {
  String? selectedAnswer;
  final String correctAnswer = 'жүгірді';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                'Әдемі, жүгірді, тәтті, сары. Қайсысы етістік?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['әдемі', 'жүгірді', 'тәтті', 'сары'].map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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

// Task 10: Find adverb
class Task10FindAdverb extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10FindAdverb(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  State<Task10FindAdverb> createState() => _Task10FindAdverbState();
}

class _Task10FindAdverbState extends State<Task10FindAdverb> {
  String? selectedAnswer;
  final String correctAnswer = 'жылы';
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
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
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
                '"Көктем келді. Алаңда балалар ойнап жүр. Ауа жылы." Мәтіндегі үстеуді тап.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    ...['көктем', 'келді', 'жылы', 'ауа'].map((option) {
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
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onPressed: selectedAnswer != null && !showNotification
                          ? _checkAnswer
                          : () {},
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      color: selectedAnswer != null && !showNotification
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
