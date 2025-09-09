import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
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
        width: double.infinity,
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
              child: SafeArea(
                top: false,
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

class BastauyshPenBayandayushScreen extends StatefulWidget {
  @override
  _BastauyshPenBayandayushScreenState createState() =>
      _BastauyshPenBayandayushScreenState();
}

class _BastauyshPenBayandayushScreenState
    extends State<BastauyshPenBayandayushScreen> {
  int currentTask = 1;
  int correctAnswers = 0;

  void _nextTask() {
    setState(() {
      if (currentTask < 10) {
        currentTask++;
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _onCorrectAnswer() {
    setState(() {
      correctAnswers++;
    });
    _nextTask();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Тамаша!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Сіз барлық тапсырмаларды аяқтадыңыз!\nДұрыс жауаптар: $correctAnswers/10',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            currentTask = 1;
                            correctAnswers = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Қайта',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Аяқтау',
                            style: TextStyle(
                                color: Color(0xFF4CAF50), fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                      widthFactor: currentTask / 10,
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
            child: _buildCurrentTask(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTask() {
    switch (currentTask) {
      case 1:
        return Task1FindSubject(onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 2:
        return Task2FindPredicate(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 3:
        return Task3MatchSubjectPredicate(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 4:
        return Task4CompleteSentence(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 5:
        return Task5IdentifyBoth(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 6:
        return Task6BuildSentence(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 7:
        return Task7FindMissingSubject(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 8:
        return Task8FindMissingPredicate(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 9:
        return Task9AnalyzeSentence(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      case 10:
        return Task10CreateSentence(
            onCorrect: _onCorrectAnswer, onNext: _nextTask);
      default:
        return Container();
    }
  }
}

// Task 1: Find Subject
class Task1FindSubject extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1FindSubject(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task1FindSubjectState createState() => _Task1FindSubjectState();
}

class _Task1FindSubjectState extends State<Task1FindSubject> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Балапандар';
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
                'Сөйлемдегі бастауышты табыңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Балапандар ұяда отыр.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Балапандар', 'ұяда', 'отыр'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 2: Find Predicate
class Task2FindPredicate extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2FindPredicate(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task2FindPredicateState createState() => _Task2FindPredicateState();
}

class _Task2FindPredicateState extends State<Task2FindPredicate> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'оқиды';
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
                'Сөйлемдегі баяндауышты табыңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Әлия кітап оқиды.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Әлия', 'кітап', 'оқиды'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

// Task 3-10 would follow similar patterns with different content
// For brevity, I'll implement remaining tasks as simple choice tasks

class Task3MatchSubjectPredicate extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task3MatchSubjectPredicate(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task3MatchSubjectPredicateState createState() =>
      _Task3MatchSubjectPredicateState();
}

class _Task3MatchSubjectPredicateState
    extends State<Task3MatchSubjectPredicate> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Мысық - мияулайды';
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
                'Дұрыс жұпты таңдаңыз',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Мысық - мияулайды', 'Ит - ұшады', 'Балық - жүгіреді']
                        .map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

// Task 4-10 follow similar pattern...
class Task4CompleteSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task4CompleteSentence(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task4CompleteSentenceState createState() => _Task4CompleteSentenceState();
}

class _Task4CompleteSentenceState extends State<Task4CompleteSentence> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'ойнайды';
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
                'Сөйлемді толықтырыңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Балалар ауладағы допты ___.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['ойнайды', 'көреді', 'жинайды'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

// Tasks 5-10 follow similar structure
class Task5IdentifyBoth extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task5IdentifyBoth(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task5IdentifyBothState createState() => _Task5IdentifyBothState();
}

class _Task5IdentifyBothState extends State<Task5IdentifyBoth> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Арман - бастауыш, жүгіреді - баяндауыш';
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
                'Бастауыш пен баяндауышты анықтаңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Арман мектепке жүгіреді.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...[
                      'Арман - бастауыш, жүгіреді - баяндауыш',
                      'мектепке - бастауыш, Арман - баяндауыш',
                      'жүгіреді - бастауыш, мектепке - баяндауыш'
                    ].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

// Task 6-10 implementations
class Task6BuildSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task6BuildSentence(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task6BuildSentenceState createState() => _Task6BuildSentenceState();
}

class _Task6BuildSentenceState extends State<Task6BuildSentence> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Ана тамақ пісіреді';
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
                'Дұрыс сөйлем құраңыз',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...[
                      'Ана тамақ пісіреді',
                      'тамақ Ана пісіреді',
                      'пісіреді Ана тамақ'
                    ].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

class Task7FindMissingSubject extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task7FindMissingSubject(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task7FindMissingSubjectState createState() =>
      _Task7FindMissingSubjectState();
}

class _Task7FindMissingSubjectState extends State<Task7FindMissingSubject> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Балалар';
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
                'Жетіспеген бастауышты табыңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  '____ ойын ойнайды.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Балалар', 'ойын', 'ойнайды'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

class Task8FindMissingPredicate extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task8FindMissingPredicate(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task8FindMissingPredicateState createState() =>
      _Task8FindMissingPredicateState();
}

class _Task8FindMissingPredicateState extends State<Task8FindMissingPredicate> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'жүзеді';
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
                'Жетіспеген баяндауышты табыңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Балық суда ____.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['жүзеді', 'суда', 'Балық'].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

class Task9AnalyzeSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task9AnalyzeSentence(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task9AnalyzeSentenceState createState() => _Task9AnalyzeSentenceState();
}

class _Task9AnalyzeSentenceState extends State<Task9AnalyzeSentence> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = '2 бастауыш, 2 баяндауыш';
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
                'Сөйлемді талдаңыз',
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
                        blurRadius: 5),
                  ],
                ),
                child: const Text(
                  'Қасым оқиды, Айша жазады.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...[
                      '2 бастауыш, 2 баяндауыш',
                      '1 бастауыш, 2 баяндауыш',
                      '2 бастауыш, 1 баяндауыш'
                    ].map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

class Task10CreateSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;
  const Task10CreateSentence(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);
  @override
  _Task10CreateSentenceState createState() => _Task10CreateSentenceState();
}

class _Task10CreateSentenceState extends State<Task10CreateSentence> {
  late ConfettiController _confettiController;
  String? selectedAnswer;
  final String correctAnswer = 'Күн жарқырайды';
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
                'Дұрыс сөйлем таңдаңыз',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    ...['Күн жарқырайды', 'жарқырайды Күн', 'жарқырайды жарық']
                        .map((option) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: showNotification
                                ? null
                                : () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (showNotification && isCorrect == true
                                      ? const Color(0xFF58CC02)
                                      : showNotification && isCorrect == false
                                          ? Colors.red
                                          : const Color(0xFF58CC02))
                                  : const Color(0xFF87CEEB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: selectedAnswer != null && !showNotification
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAnswer != null && !showNotification
                                  ? const Color(0xFF58CC02)
                                  : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
