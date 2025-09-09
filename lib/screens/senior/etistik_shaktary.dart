import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import '../../widgets/animated_button.dart';
import 'dart:math';

import '../junior/sound_hunters.dart';

class EtistikShaktary extends StatefulWidget {
  const EtistikShaktary({Key? key}) : super(key: key);

  @override
  _EtistikShaktaryState createState() => _EtistikShaktaryState();
}

class _EtistikShaktaryState extends State<EtistikShaktary> {
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
              Icons.school,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            const SizedBox(height: 20),
            const Text(
              'Етістік шақтарын үйрендің!',
              style: TextStyle(
                fontSize: 24,
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
                Task1IdentifyVerbs(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2ListenVerbs(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3ConvertTenses(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4FindPastTense(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5ConvertToPresent(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6CreateSentences(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7CategorizeVerbs(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8PresentTenseVerbs(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9SpeakingTask(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10AudioStory(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Identify verbs and their tenses from text
class Task1IdentifyVerbs extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1IdentifyVerbs(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task1IdentifyVerbsState createState() => _Task1IdentifyVerbsState();
}

class _Task1IdentifyVerbsState extends State<Task1IdentifyVerbs> {
  late ConfettiController _confettiController;
  Map<String, String> selections = {};
  final Map<String, String> correctAnswers = {
    'отырғызды': 'өткен шақ',
    'әкеледі': 'келер шақ',
    'қопсытып жатыр': 'осы шақ',
  };
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _selectTense(String verb, String tense) {
    if (showNotification) return;
    setState(() {
      selections[verb] = tense;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (selections[verb] != correctAnswers[verb]) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Етістіктерді тауып, шақ түрін анықта',
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
                  'Аружан бақшада гүл отырғызды. Ертең ол жаңа көшеттер әкеледі. Қазір ол топырақты қопсытып жатыр.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(verb,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'өткен шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Өткен шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'осы шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Осы шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'келер шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Келер шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                              ],
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
                  onPressed: selections.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selections.length == 3
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

// Task 2: Listen and identify verbs and tenses
class Task2ListenVerbs extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2ListenVerbs(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task2ListenVerbsState createState() => _Task2ListenVerbsState();
}

class _Task2ListenVerbsState extends State<Task2ListenVerbs> {
  late ConfettiController _confettiController;
  Map<String, String> selections = {};
  final Map<String, String> correctAnswers = {
    'жазып отыр': 'осы шақ',
    'бардық': 'өткен шақ',
    'келеді': 'келер шақ',
  };
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _playAudio() {
    SystemSound.play(SystemSoundType.click);
  }

  void _selectTense(String verb, String tense) {
    if (showNotification) return;
    setState(() {
      selections[verb] = tense;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (selections[verb] != correctAnswers[verb]) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Тыңдап, етістіктерді анықта',
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: _playAudio,
                      child: const Icon(Icons.volume_up,
                          size: 50, color: Colors.white),
                    ),
                  ),
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
                  'Сөйлемдер:\n1. Данияр хат жазып отыр.\n2. Біз кеше орманға бардық.\n3. Ертең достарымыз келеді.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(verb,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: (screenWidth - 48 - 24) /
                                      3, // Адаптивная ширина
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'өткен шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Өткен шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'осы шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Осы шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'келер шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: selections[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Келер шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                              ],
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
                  onPressed: selections.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selections.length == 3
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

// Task 3: Convert three verbs to all tenses
class Task3ConvertTenses extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3ConvertTenses(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task3ConvertTensesState createState() => _Task3ConvertTensesState();
}

class _Task3ConvertTensesState extends State<Task3ConvertTenses> {
  late ConfettiController _confettiController;
  Map<String, Map<String, String>> verbForms = {
    'жүгіру': {'келер шақ': '', 'осы шақ': '', 'өткен шақ': ''},
    'оқу': {'келер шақ': '', 'осы шақ': '', 'өткен шақ': ''},
    'бару': {'келер шақ': '', 'осы шақ': '', 'өткен шақ': ''},
  };
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateVerbForm(String verb, String tense, String form) {
    setState(() {
      verbForms[verb]![tense] = form;
    });
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = _isFormComplete();
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      _playSound(true);
    } else {
      _playSound(false);
    }
  }

  bool _isFormComplete() {
    for (String verb in verbForms.keys) {
      for (String tense in verbForms[verb]!.keys) {
        if (verbForms[verb]![tense]!.trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _continue() {
    widget.onCorrect(); // Always correct for writing tasks
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
                'Үш етістікті әр шақта жаз',
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
                  'Мысалы: жүгіремін (келер шақ), жүгіріп жүрмін (осы шақ), жүгірдім (өткен шақ)',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: verbForms.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verb.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF58CC02)),
                            ),
                            const SizedBox(height: 16),
                            ...verbForms[verb]!.keys.map((tense) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tense,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      onChanged: (value) =>
                                          _updateVerbForm(verb, tense, value),
                                      decoration: InputDecoration(
                                        hintText: 'Етістік түрін енгіз',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
                  onPressed: _isFormComplete() ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color:
                      _isFormComplete() ? const Color(0xFF58CC02) : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
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
              isCorrect: true, // Always show success for writing tasks
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 4: Find past tense verbs
class Task4FindPastTense extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4FindPastTense(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task4FindPastTenseState createState() => _Task4FindPastTenseState();
}

class _Task4FindPastTenseState extends State<Task4FindPastTense> {
  late ConfettiController _confettiController;
  Set<String> selectedVerbs = {};
  final Set<String> correctAnswers = {'жауды', 'оқыды'};
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectVerb(String verb) {
    if (showNotification) return;
    setState(() {
      if (selectedVerbs.contains(verb)) {
        selectedVerbs.remove(verb);
      } else {
        selectedVerbs.add(verb);
      }
    });
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedVerbs.containsAll(correctAnswers) &&
          selectedVerbs.length == correctAnswers.length;
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
                'Өткен шақтағы етістіктерді тап',
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
                  '1. Қар кеше жауды.\n2. Біз қазір сабақ оқып отырмыз.\n3. Ертең ауылға аттанамыз.\n4. Атам жастайынан көп кітап оқыды.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Өткен шақтағы етістіктерді таңда:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: ['жауды', 'оқып отырмыз', 'аттанамыз', 'оқыды']
                          .map((verb) {
                        final isSelected = selectedVerbs.contains(verb);
                        return AnimatedButton(
                          onPressed: () => _selectVerb(verb),
                          width: (screenWidth - 48 - 36) / 2,
                          height: 50,
                          color: isSelected
                              ? const Color(0xFF58CC02)
                              : const Color(0xFF87CEEB),
                          child: Text(
                            verb,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: selectedVerbs.isNotEmpty ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selectedVerbs.isNotEmpty
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

// Task 5: Convert verbs to present tense
class Task5ConvertToPresent extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5ConvertToPresent(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task5ConvertToPresentState createState() => _Task5ConvertToPresentState();
}

class _Task5ConvertToPresentState extends State<Task5ConvertToPresent> {
  late ConfettiController _confettiController;
  Map<String, String> conversions = {};
  final Map<String, String> correctAnswers = {
    'жазды': 'жазып отыр',
    'барды': 'барып жатыр',
    'айтты': 'айтып отыр',
    'оқыды': 'оқып отыр',
  };
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateConversion(String verb, String conversion) {
    setState(() {
      conversions[verb] = conversion;
    });
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = conversions.length == 4;
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
    widget.onCorrect(); // Always correct for writing tasks
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
                'Етістіктерді осы шаққа айналдыр',
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
                  'Мысалы: жазды → жазып отыр',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$verb →',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              onChanged: (value) =>
                                  _updateConversion(verb, value),
                              decoration: InputDecoration(
                                hintText: 'Осы шақтағы түрін жаз',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                              ),
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
                  onPressed: conversions.length == 4 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: conversions.length == 4
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
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
              isCorrect: true, // Always show success for writing tasks
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 6: Create sentences with pictures
class Task6CreateSentences extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6CreateSentences(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task6CreateSentencesState createState() => _Task6CreateSentencesState();
}

class _Task6CreateSentencesState extends State<Task6CreateSentences> {
  late ConfettiController _confettiController;
  final TextEditingController _presentController = TextEditingController();
  final TextEditingController _futureController = TextEditingController();
  bool showNotification = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _presentController.dispose();
    _futureController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    _playSound(true);
  }

  void _continue() {
    widget.onCorrect();
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
                'Суретке қарап сөйлем құра',
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
                  'Осы шақта 3 сөйлем, келер шақта 3 сөйлем құра.\nМысалы: Балалар футбол ойнап жатыр.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Осы шақ (3 сөйлем):',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _presentController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: 'Балалар ойнап жатыр...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Келер шақ (3 сөйлем):',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _futureController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: 'Ертең олар барады...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _presentController.text.trim().length > 10 &&
                          _futureController.text.trim().length > 10
                      ? _checkAnswer
                      : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: _presentController.text.trim().length > 10 &&
                          _futureController.text.trim().length > 10
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
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
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 7: Categorize verbs by tense from text
class Task7CategorizeVerbs extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7CategorizeVerbs(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task7CategorizeVerbsState createState() => _Task7CategorizeVerbsState();
}

class _Task7CategorizeVerbsState extends State<Task7CategorizeVerbs> {
  late ConfettiController _confettiController;
  Map<String, String> verbTenses = {};
  final Map<String, String> correctAnswers = {
    'шықтық': 'өткен шақ',
    'болды': 'өткен шақ',
    'терді': 'өткен шақ',
    'бағалайды': 'келер шақ',
  };
  bool showNotification = false;
  bool? isCorrect;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _assignTense(String verb, String tense) {
    if (showNotification) return;
    setState(() {
      verbTenses[verb] = tense;
    });
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (verbTenses[verb] != correctAnswers[verb]) {
          isCorrect = false;
          break;
        }
      }
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
                'Етістіктерді шақ түріне бөл',
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
                  'Бүгін біз табиғатқа шықтық. Күн ашық болды. Балалар гүл терді. Ертең мұғалім суреттерді көріп, бағалайды.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(verb,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: (screenWidth - 48 - 24) /
                                      3, // Адаптивная ширина
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'өткен шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: verbTenses[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Өткен шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'осы шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: verbTenses[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Осы шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth - 48 - 24) / 3,
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'келер шақ'),
                                    width: (screenWidth - 48 - 24) / 3,
                                    height: 45,
                                    color: verbTenses[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Келер шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                              ],
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
                  onPressed: verbTenses.length == 4 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: verbTenses.length == 4
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

// Task 8: Create present tense verbs and convert them
class Task8PresentTenseVerbs extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8PresentTenseVerbs(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task8PresentTenseVerbsState createState() => _Task8PresentTenseVerbsState();
}

class _Task8PresentTenseVerbsState extends State<Task8PresentTenseVerbs> {
  late ConfettiController _confettiController;
  final TextEditingController _verbsController = TextEditingController();
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
    _verbsController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    SystemSound.play(SystemSoundType.click);
  }

  void _continue() {
    widget.onCorrect();
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
                '4 етістік ойлап, шақ түрлерін жаз',
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
                  'Мысалы: оқып отыр → оқыды → оқиды',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _verbsController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText:
                          '1. Ойнап жатыр → ойнады → ойнайды\n2. Жазып отыр → жазды → жазады\n...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _verbsController.text.trim().length > 30
                      ? _checkAnswer
                      : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: _verbsController.text.trim().length > 30
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
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
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 9: Speaking task about weekly activities
class Task9SpeakingTask extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9SpeakingTask(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task9SpeakingTaskState createState() => _Task9SpeakingTaskState();
}

class _Task9SpeakingTaskState extends State<Task9SpeakingTask> {
  late ConfettiController _confettiController;
  bool isRecording = false;
  bool hasRecorded = false;
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

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
        hasRecorded = true;
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    SystemSound.play(SystemSoundType.click);
  }

  void _continue() {
    widget.onCorrect();
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
                'Айтылым: Апталық жоспарыңды айт',
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
                  'Өткен аптада не істегеніңді, қазір не істеп жатқаныңды және алдағы аптада не істейтініңді 3-3 сөйлеммен айтып бер.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? Colors.red
                              : const Color(0xFF58CC02),
                          shape: BoxShape.circle,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: _toggleRecording,
                            child: Icon(
                              isRecording ? Icons.stop : Icons.mic,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isRecording
                            ? 'Жазылуда...'
                            : hasRecorded
                                ? 'Жазылды!'
                                : 'Айтуды бастау',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Мысал:\nӨткен шақ: Мен атамның үйіне бардым...\nОсы шақ: Қазір сабақ оқып отырмын...\nКелер шақ: Келесі аптада қалаға барамын...',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: hasRecorded ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: hasRecorded ? const Color(0xFF58CC02) : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
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
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 10: Listen to audio story and identify verb tenses
class Task10AudioStory extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10AudioStory(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task10AudioStoryState createState() => _Task10AudioStoryState();
}

class _Task10AudioStoryState extends State<Task10AudioStory> {
  late ConfettiController _confettiController;
  Map<String, String> verbTenses = {};
  final Map<String, String> correctAnswers = {
    'бардым': 'өткен шақ',
    'көрдім': 'өткен шақ',
    'қарап отырмын': 'осы шақ',
    'көрсетемін': 'келер шақ',
  };
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

  void _playAudio() {
    SystemSound.play(SystemSoundType.click);
  }

  void _assignTense(String verb, String tense) {
    if (showNotification) return;
    setState(() {
      verbTenses[verb] = tense;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (verbTenses[verb] != correctAnswers[verb]) {
          isCorrect = false;
          break;
        }
      }
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
                'Әңгімені тыңдап, етістіктерді анықта',
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: _playAudio,
                      child: const Icon(Icons.volume_up,
                          size: 50, color: Colors.white),
                    ),
                  ),
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
                  'Әңгіме: Кеше мен зообаққа бардым. Арыстанды көрдім. Қазір суретіне қарап отырмын. Ертең достарыма көрсетемін.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(verb,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'өткен шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: verbTenses[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Өткен шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'осы шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: verbTenses[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Осы шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _assignTense(verb, 'келер шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: verbTenses[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text('Келер шақ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                              ],
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
                  onPressed: verbTenses.length == 4 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: verbTenses.length == 4
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
