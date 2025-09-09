import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import '../../widgets/animated_button.dart';
import 'dart:math';

import '../junior/sound_hunters.dart';

class SinonimAntonimOmonim extends StatefulWidget {
  const SinonimAntonimOmonim({Key? key}) : super(key: key);

  @override
  _SinonimAntonimOmonimState createState() => _SinonimAntonimOmonimState();
}

class _SinonimAntonimOmonimState extends State<SinonimAntonimOmonim> {
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
        backgroundColor: const Color(0xFFF0F8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.library_books,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            const SizedBox(height: 20),
            const Text(
              'Синоним, антоним, омонимді үйрендің!',
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
                Task1FindSynonym(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2FindAntonym(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3MatchSynonyms(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4MatchAntonyms(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5FindHomonym(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6CompleteSentence(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7FindOddWord(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8FindHomonymInText(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9CompleteSynonymChain(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10FindSynonymAntonym(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Find synonym for "жылы" (warm)
class Task1FindSynonym extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1FindSynonym(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task1FindSynonymState createState() => _Task1FindSynonymState();
}

class _Task1FindSynonymState extends State<Task1FindSynonym> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  String? selectedAnswer;
  final String correctAnswer = 'Ыстық';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                '"Жылы" сөзіне синоним тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Күн бүгін өте жылы болды. Кеше тым салқын еді.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Суық', 'Ыстық', 'Қатты'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: showNotification
                              ? () {}
                              : () => _selectAnswer(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: selectedAnswer == option
                              ? (showNotification && isCorrect == true
                                  ? const Color(0xFF58CC02)
                                  : showNotification && isCorrect == false
                                      ? Colors.red
                                      : const Color(0xFF58CC02))
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
                            fontWeight: FontWeight.bold),
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

// Task 2: Find antonym for "ашық" (open/clear)
class Task2FindAntonym extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2FindAntonym(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task2FindAntonymState createState() => _Task2FindAntonymState();
}

class _Task2FindAntonymState extends State<Task2FindAntonym> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  String? selectedAnswer;
  final String correctAnswer = 'Жабық';
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
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
    });
  }

  void _playSound(bool isCorrect) async {
    try {
      await _audioPlayer.play(
          AssetSource(isCorrect ? 'audio/correct.mp3' : 'audio/incorrect.mp3'));
    } catch (e) {
      // ignore
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      _playSound(true);
    } else {
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
                '"Ашық" сөзіне антоним тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Таңертең күн ашық болды, түстен кейін бұлт басты.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Жабық', 'Тұнық', 'Қасаң'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: showNotification
                              ? () {}
                              : () => _selectAnswer(option),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          color: selectedAnswer == option
                              ? (showNotification && isCorrect == true
                                  ? const Color(0xFF58CC02)
                                  : showNotification && isCorrect == false
                                      ? Colors.red
                                      : const Color(0xFF58CC02))
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
                            fontWeight: FontWeight.bold),
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

// Task 3: Match words with their synonyms
class Task3MatchSynonyms extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3MatchSynonyms(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task3MatchSynonymsState createState() => _Task3MatchSynonymsState();
}

class _Task3MatchSynonymsState extends State<Task3MatchSynonyms> {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  Map<String, String> matches = {};
  final Map<String, String> correctMatches = {
    'Әдемі': 'Сұлу',
    'Күшті': 'Мықты',
    'Бақытты': 'Қуанышты',
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectMatch(String word, String synonym) {
    if (showNotification) return;
    setState(() {
      matches[word] = synonym;
    });
  }

  void _playSound(bool isCorrect) async {
    try {
      await _audioPlayer.play(
          AssetSource(isCorrect ? 'audio/correct.mp3' : 'audio/incorrect.mp3'));
    } catch (e) {
      // ignore
    }
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

    if (isCorrect!) {
      _confettiController.play();
      _playSound(true);
    } else {
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
                'Сөздерді синонимдермен сәйкестендір',
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
                              children: correctMatches.values.map((synonym) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: AnimatedButton(
                                      onPressed: () =>
                                          _selectMatch(word, synonym),
                                      width: double.infinity,
                                      height: 50,
                                      color: matches[word] == synonym
                                          ? const Color(0xFF58CC02)
                                          : const Color(0xFF87CEEB),
                                      child: Text(
                                        synonym,
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
                  onPressed: matches.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: matches.length == 3
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

// Task 4: Match antonym pairs
class Task4MatchAntonyms extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4MatchAntonyms(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task4MatchAntonymsState createState() => _Task4MatchAntonymsState();
}

class _Task4MatchAntonymsState extends State<Task4MatchAntonyms> {
  late ConfettiController _confettiController;
  Set<String> selectedPairs = {};
  final Set<String> correctPairs = {'Үлкен-Кішкентай', 'Ұзын-Қысқа'};
  bool showNotification = false;
  bool? isCorrect;

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

  void _selectPair(String pair) {
    if (showNotification) return;
    setState(() {
      if (selectedPairs.contains(pair)) {
        selectedPairs.remove(pair);
      } else {
        selectedPairs.add(pair);
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedPairs.containsAll(correctPairs) &&
          selectedPairs.length == correctPairs.length;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Антоним жұптарды тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Сөздер: Үлкен, Ұзын, Кішкентай, Қысқа',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Қарама-қарсы мағыналы жұптарды таңда:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    ...['Үлкен-Кішкентай', 'Ұзын-Қысқа', 'Үлкен-Ұзын']
                        .map((pair) {
                      final isSelected = selectedPairs.contains(pair);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onPressed: () => _selectPair(pair),
                          width: screenWidth / 1.2,
                          height: 60,
                          color: isSelected
                              ? const Color(0xFF58CC02)
                              : const Color(0xFF87CEEB),
                          child: Text(
                            pair,
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
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: selectedPairs.length == 2 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selectedPairs.length == 2
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

// Task 5: Find homonym in text
class Task5FindHomonym extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5FindHomonym(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task5FindHomonymState createState() => _Task5FindHomonymState();
}

class _Task5FindHomonymState extends State<Task5FindHomonym> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Тас';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Омоним сөзді тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Ол тас лақтырып, өзеннің тасқынын тамашалады.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Бірдей айтылатын, бірақ мағынасы бөлек сөзді таңда',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: ['Тас', 'Өзен', 'Тамаша'].map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: AnimatedButton(
                        onPressed: () => _selectAnswer(option),
                        width: screenWidth / 1.2,
                        height: 60,
                        color: selectedAnswer == option
                            ? (isCorrect!
                                ? const Color(0xFF58CC02)
                                : Colors.red)
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

// Task 6: Complete sentence with synonym
class Task6CompleteSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6CompleteSentence(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task6CompleteSentenceState createState() => _Task6CompleteSentenceState();
}

class _Task6CompleteSentenceState extends State<Task6CompleteSentence> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Зерек';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Сөйлемді толықтыр',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  '"Менің досым өте _____ бала." (Мәні: ақылды)',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: ['Жақсы', 'Зерек', 'Әдемі'].map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: AnimatedButton(
                        onPressed: () => _selectAnswer(option),
                        width: screenWidth / 1.2,
                        height: 60,
                        color: selectedAnswer == option
                            ? (isCorrect!
                                ? const Color(0xFF58CC02)
                                : Colors.red)
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

// Task 7: Find the odd word out
class Task7FindOddWord extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7FindOddWord(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task7FindOddWordState createState() => _Task7FindOddWordState();
}

class _Task7FindOddWordState extends State<Task7FindOddWord> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Қатты';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Артық сөзді тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Сөздер: Суық, Қатты, Ыстық, Жылы\nҚайсысы антоним қатарынан емес?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: ['Қатты', 'Суық', 'Жылы'].map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: AnimatedButton(
                        onPressed: () => _selectAnswer(option),
                        width: screenWidth / 1.2,
                        height: 60,
                        color: selectedAnswer == option
                            ? (isCorrect!
                                ? const Color(0xFF58CC02)
                                : Colors.red)
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

// Task 8: Find homonym in text passage
class Task8FindHomonymInText extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8FindHomonymInText(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task8FindHomonymInTextState createState() => _Task8FindHomonymInTextState();
}

class _Task8FindHomonymInTextState extends State<Task8FindHomonymInText> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Қаз';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Мәтіндегі омонимді тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  '"Ауылға жаңа қаз келді. Біз жерден су қаздық."',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Бірдей айтылып, мағынасы бөлек сөз:',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: ['Қаз', 'Су', 'Жаңа'].map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: AnimatedButton(
                        onPressed: () => _selectAnswer(option),
                        width: screenWidth / 1.2,
                        height: 60,
                        color: selectedAnswer == option
                            ? (isCorrect!
                                ? const Color(0xFF58CC02)
                                : Colors.red)
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

// Task 9: Complete synonym chain
class Task9CompleteSynonymChain extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9CompleteSynonymChain(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task9CompleteSynonymChainState createState() =>
      _Task9CompleteSynonymChainState();
}

class _Task9CompleteSynonymChainState extends State<Task9CompleteSynonymChain> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Қорқақ';
  bool showNotification = false;
  bool? isCorrect;

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
    if (showNotification) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Синоним тізбегін толықтыр',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Батыл – Ержүрек – ... ?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      height: 1.5,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Үшінші синонимді таңда немесе антонимді тап:',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: ['Қорқақ', 'Еркін', 'Жайбасар'].map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: AnimatedButton(
                        onPressed: () => _selectAnswer(option),
                        width: screenWidth / 1.2,
                        height: 60,
                        color: selectedAnswer == option
                            ? (isCorrect!
                                ? const Color(0xFF58CC02)
                                : Colors.red)
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

// Task 10: Find both synonym and antonym
class Task10FindSynonymAntonym extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10FindSynonymAntonym(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task10FindSynonymAntonymState createState() =>
      _Task10FindSynonymAntonymState();
}

class _Task10FindSynonymAntonymState extends State<Task10FindSynonymAntonym> {
  late ConfettiController _confettiController;
  String? selectedSynonym;
  String? selectedAntonym;
  final String correctSynonym = 'Қуанышты';
  final String correctAntonym = 'Сабырлы';
  bool showNotification = false;
  bool? isCorrect;

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

  void _selectSynonym(String synonym) {
    if (showNotification) return;
    setState(() {
      selectedSynonym = synonym;
    });
  }

  void _selectAntonym(String antonym) {
    if (showNotification) return;
    setState(() {
      selectedAntonym = antonym;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedSynonym == correctSynonym &&
          selectedAntonym == correctAntonym;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
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
                'Синоним және антоним тап',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Сөздер: Ашулы, Көңілді, Қуанышты, Сабырлы',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '"Көңілді" сөзіне синоним:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children:
                            ['Ашулы', 'Қуанышты', 'Сабырлы'].map((option) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: AnimatedButton(
                                onPressed: () => _selectSynonym(option),
                                width: double.infinity,
                                height: 50,
                                color: selectedSynonym == option
                                    ? const Color(0xFF58CC02)
                                    : const Color(0xFF87CEEB),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '"Ашулы" сөзіне антоним:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children:
                            ['Көңілді', 'Қуанышты', 'Сабырлы'].map((option) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: AnimatedButton(
                                onPressed: () => _selectAntonym(option),
                                width: double.infinity,
                                height: 50,
                                color: selectedAntonym == option
                                    ? const Color(0xFF58CC02)
                                    : const Color(0xFF87CEEB),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: AnimatedButton(
                          onPressed: selectedSynonym != null &&
                                  selectedAntonym != null &&
                                  !showNotification
                              ? _checkAnswer
                              : () {},
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 55,
                          color: selectedSynonym != null &&
                                  selectedAntonym != null &&
                                  !showNotification
                              ? const Color(0xFF58CC02)
                              : Colors.grey,
                          child: const Text(
                            'Тексеру',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showNotification)
                AnswerNotification(
                  isCorrect: isCorrect!,
                  onContinue: _continue,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
