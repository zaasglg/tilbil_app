import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:til_bil_app/services/sound_service.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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
        margin: const EdgeInsets.only(top: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.isCorrect ? 'Өте жақсы!' : 'Қате!',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 80),
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
            Positioned(
              right: 20,
              top: -40,
              child: ClipOval(
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
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionGameScreen extends StatefulWidget {
  @override
  _ActionGameScreenState createState() => _ActionGameScreenState();
}

class _ActionGameScreenState extends State<ActionGameScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  bool showFeedback = false;
  bool? isCorrect;
  late AnimationController _progressController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<String> task4Words = ['ішемін', 'мен', 'су'];
  List<String> task4UserSentence = [];
  List<String> task7Words = ['үйге', 'Айдана', 'жатыр', 'бара'];
  List<String> task7UserSentence = [];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressController.forward();
    task4Words.shuffle();
    task7Words.shuffle();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _playCorrectSound() {
    _playSound('audio/correct.mp3');
  }

  void _playIncorrectSound() {
    _playSound('audio/incorrect.mp3');
  }

  void _nextTask() {
    if (currentTask < 10) {
      setState(() {
        currentTask++;
        isAnswered = false;
        selectedAnswer = null;
        showFeedback = false;

        if (currentTask == 4) {
          task4Words.shuffle();
          task4UserSentence.clear();
        }
        if (currentTask == 7) {
          task7Words.shuffle();
          task7UserSentence.clear();
        }
      });

      _progressController.reset();
      _progressController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _checkAnswer(String answer) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      showFeedback = true;
    });

    bool isCorrect = false;
    switch (currentTask) {
      case 1:
        isCorrect = answer == 'алма';
        break;
      case 2:
        isCorrect = answer == 'Су ішіп отыр';
        break;
      case 3:
        isCorrect = answer == 'ойыншық ойнап отыр';
        break;
      case 5:
        isCorrect = answer == 'үстел';
        break;
      case 6:
        isCorrect = answer == 'Қали жүзім жеп отыр';
        break;
      case 8:
        isCorrect = answer == 'ішіп';
        break;
      case 9:
        isCorrect = answer == 'алыста тұрған ағаш';
        break;
      case 10:
        isCorrect = answer == 'Әлия нан жеп отыр';
        break;
    }

    if (isCorrect) {
      score += 10;
      _playCorrectSound();
    } else {
      _playIncorrectSound();
    }

    // store for notification overlay
    this.isCorrect = isCorrect;

    // Wait for user to press notification's continue button to advance
  }

  void _checkSentenceBuilding(int taskNum) {
    String userSentence = taskNum == 4
        ? task4UserSentence.join(' ')
        : task7UserSentence.join(' ');

    String correctSentence =
        taskNum == 4 ? 'Мен су ішемін' : 'Айдана үйге бара жатыр';
    bool isCorrect = userSentence == correctSentence;

    if (isCorrect) {
      score += 10;
      _playCorrectSound();
    } else {
      _playIncorrectSound();
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });

    // store for notification overlay
    this.isCorrect = isCorrect;

    // Wait for user to press notification's continue button to advance
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Табыс!',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Сіз барлық тапсырмаларды орындадыңыз!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Жинаған ұпайыңыз: $score/100',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF58CC02),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ChicletAnimatedButton(
                    backgroundColor: CupertinoColors.activeGreen,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        'Жақсы',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding:
              const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF58CC02), Color(0xFF4CAF50)],
            ),
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
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: currentTask / 10.0,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 12,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$currentTask/10',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildCurrentTask(),
                if (showFeedback && isCorrect != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnswerNotification(
                      isCorrect: isCorrect!,
                      onContinue: _onNotificationContinue,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNotificationContinue() {
    // advance to next task and reset flags
    setState(() {
      showFeedback = false;
      isAnswered = false;
      selectedAnswer = null;
      isCorrect = null;
    });

    _nextTask();
  }

  Widget _buildCurrentTask() {
    switch (currentTask) {
      case 1:
        return _buildTask1();
      case 2:
        return _buildTask2();
      case 3:
        return _buildTask3();
      case 4:
        return _buildTask4();
      case 5:
        return _buildTask5();
      case 6:
        return _buildTask6();
      case 7:
        return _buildTask7();
      case 8:
        return _buildTask8();
      case 9:
        return _buildTask9();
      case 10:
        return _buildTask10();
      default:
        return Container();
    }
  }

  Widget _buildTask1() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Тыңда да дұрыс суретті таңда',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF58CC02),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    // play the short segment (matches sound_hunters behavior)
                    soundService.playSegment(9500, 10500);
                  },
                  child: const Center(
                    child: Icon(Icons.volume_up, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFruitOption('алма', '🍎', 'алма'),
              const SizedBox(height: 15),
              _buildFruitOption('банан', '🍌', 'банан'),
              const SizedBox(height: 15),
              _buildFruitOption('жүзім', '🍇', 'жүзім'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask2() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Суретте Даниярдың не істеп жатқанын тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
                ]),
            child: const Center(
                child: Image(
                    image: AssetImage("/assets/images/drink_water.avif"))),
          ),
          const SizedBox(height: 40),
          ...['Тамақтанып отыр', 'Су ішіп отыр', 'Үйге бара жатыр']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ChicletAnimatedButton(
                      onPressed:
                          isAnswered ? () {} : () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: selectedAnswer == option
                              ? (option == 'Су ішіп отыр'
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFFFF4B4B))
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(option,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: selectedAnswer == option
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTask3() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Ойыншықпен ойнап отырған Айымның суретін тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Column(
            children: [
              _buildActionOption('су ішіп отыр', '👧💧', 'су ішіп отыр'),
              const SizedBox(height: 15),
              _buildActionOption('кітап оқып отыр', '👧📚', 'кітап оқып отыр'),
              const SizedBox(height: 15),
              _buildActionOption(
                  'ойыншық ойнап отыр', '👧🧸', 'ойыншық ойнап отыр'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask4() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Сөздерден дұрыс сөйлем құрастыршы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[200]!)),
            child: Center(
                child: Text(task4UserSentence.join(' '),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: task4Words
                .where((word) => !task4UserSentence.contains(word))
                .map(
                  (word) => SizedBox(
                    width: double.infinity,
                    child: ChicletAnimatedButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          task4UserSentence.add(word);
                          if (task4UserSentence.length == 3) {
                            Timer(const Duration(milliseconds: 500),
                                () => _checkSentenceBuilding(4));
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(word,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          if (task4UserSentence.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ChicletAnimatedButton(
                onPressed: () => setState(() => task4UserSentence.clear()),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text('Тазалау',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask5() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Артық сөзді тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: ['бару', 'келу', 'үстел', 'ішу']
                .map(
                  (word) => SizedBox(
                    width: double.infinity,
                    child: ChicletAnimatedButton(
                      onPressed: isAnswered ? () {} : () => _checkAnswer(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Text(word,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: selectedAnswer == word
                                    ? Colors.white
                                    : Colors.white)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTask6() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Қалидың не істеп отырғанын дауыстап аташы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
                ]),
            child: const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('👦', style: TextStyle(fontSize: 60)),
                  Text('🍇', style: TextStyle(fontSize: 40))
                ])),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 80.0,
            child: ChicletAnimatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        '🎤 Микрофонға "Қали жүзім жеп отыр" деп айтыңыз')));
                Timer(const Duration(seconds: 2),
                    () => _checkAnswer('Қали жүзім жеп отыр'));
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.mic, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text('Айту',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600))
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask7() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Сөздерден дұрыс сөйлем құрашы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[200]!)),
            child: Center(
                child: Text(task7UserSentence.join(' '),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: task7Words
                .where((word) => !task7UserSentence.contains(word))
                .map(
                  (word) => SizedBox(
                    width: double.infinity,
                    child: ChicletAnimatedButton(
                      onPressed: () {
                        setState(() {
                          task7UserSentence.add(word);
                          if (task7UserSentence.length == 4) {
                            Timer(const Duration(milliseconds: 500),
                                () => _checkSentenceBuilding(7));
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(word,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          if (task7UserSentence.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ChicletAnimatedButton(
                onPressed: () => setState(() => task7UserSentence.clear()),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text('Тазалау',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask8() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Түсіп қалған сөзді тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                ]),
            child: const Text('Бала тәтті компот ________ отыр',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 40),
          ...['ішіп', 'жеп', 'көріп']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ChicletAnimatedButton(
                      onPressed:
                          isAnswered ? () {} : () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        child: Text(option,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: selectedAnswer == option
                                    ? Colors.white
                                    : Colors.white),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTask9() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Анау тұрған затты тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Column(
            children: [
              _buildDistanceOption(
                  'жақын тұрған кесе', '🥣', 'жақын тұрған кесе'),
              const SizedBox(height: 15),
              _buildDistanceOption(
                  'ортада тұрған алма', '🍎', 'ортада тұрған алма'),
              const SizedBox(height: 15),
              _buildDistanceOption(
                  'алыста тұрған ағаш', '🌳', 'алыста тұрған ағаш'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask10() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Суретте кім нан жеп отырғанын тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Column(
            children: [
              _buildPersonOption(
                  'Әлия нан жеп отыр', '👧🍞', 'Әлия нан жеп отыр'),
              const SizedBox(height: 15),
              _buildPersonOption(
                  'Айдар су ішіп отыр', '👦💧', 'Айдар су ішіп отыр'),
              const SizedBox(height: 15),
              _buildPersonOption('Анасы балаға ойыншық беріп отыр', '👩🧸',
                  'Анасы балаға ойыншық беріп отыр'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFruitOption(String label, String emoji, String value) {
    return SizedBox(
      width: double.infinity,
      child: ChicletAnimatedButton(
        onPressed: isAnswered ? () {} : () => _checkAnswer(value),
        backgroundColor: Colors.green,
        height: 100,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 5),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selectedAnswer == value
                          ? Colors.white
                          : Colors.black),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionOption(String label, String emoji, String value) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ChicletAnimatedButton(
        onPressed: isAnswered ? () {} : () => _checkAnswer(value),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 15),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedAnswer == value
                              ? Colors.white
                              : Colors.black))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceOption(String label, String emoji, String value) {
    return SizedBox(
      width: double.infinity,
      height: 80.0,
      child: ChicletAnimatedButton(
        onPressed: isAnswered ? () {} : () => _checkAnswer(value),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 15),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedAnswer == value
                              ? Colors.white
                              : Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonOption(String label, String emoji, String value) {
    return SizedBox(
      width: double.infinity,
      height: 80.0,
      child: ChicletAnimatedButton(
        onPressed: isAnswered ? () {} : () => _checkAnswer(value),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 15),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedAnswer == value
                              ? Colors.white
                              : Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
