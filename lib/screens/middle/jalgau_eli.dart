import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:til_bil_app/screens/junior/sound_hunters.dart';
import 'package:audioplayers/audioplayers.dart';

class JalgauEliScreen extends StatefulWidget {
  const JalgauEliScreen({super.key});

  @override
  State<JalgauEliScreen> createState() => _JalgauEliScreenState();
}

class _JalgauEliScreenState extends State<JalgauEliScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextTask() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
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
                Task1ListenAndChoose(onCorrect: _nextTask),
                Task2PluralSuffixes(onCorrect: _nextTask),
                Task3PossessiveSuffixes(onCorrect: _nextTask),
                Task4IdentifyCase1(onCorrect: _nextTask),
                Task5IdentifyCase2(onCorrect: _nextTask),
                Task6CompleteSentence(onCorrect: _nextTask),
                Task7ListenAndIdentifyCase(onCorrect: _nextTask),
                Task8ReadPhrases(onCorrect: _nextTask),
                Task9CompleteSentence1(onCorrect: _nextTask),
                Task10CompleteSentence2(onCorrect: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Listen and choose correct word
class Task1ListenAndChoose extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task1ListenAndChoose({super.key, required this.onCorrect});

  @override
  State<Task1ListenAndChoose> createState() => _Task1ListenAndChooseState();
}

class _Task1ListenAndChooseState extends State<Task1ListenAndChoose> {
  final List<String> options = ['көшелер', 'көршіде', 'көршілер'];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'көршілер';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Тыңда да, дұрыс сөзді таңдашы',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58CC02).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🔊 көршілер')),
                        );
                      },
                      child: const Icon(Icons.volume_up,
                          size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      width: 250.0,
                      height: 60.0,
                      onPressed: () => _checkAnswer(option),
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 2: Add plural suffixes
class Task2PluralSuffixes extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task2PluralSuffixes({super.key, required this.onCorrect});

  @override
  State<Task2PluralSuffixes> createState() => _Task2PluralSuffixesState();
}

class _Task2PluralSuffixesState extends State<Task2PluralSuffixes> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> words = ['Оқушы', 'Қалам', 'Ағаш'];
  final List<String> correctAnswers = ['лар', 'дар', 'тар'];
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    bool allCorrect = true;
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.toLowerCase() != correctAnswers[i]) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      isCorrect = allCorrect;
      showNotification = true;
    });
    _playSound(allCorrect);
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Көптік жалғауын дұрыс қой',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${index + 1}. ${words[index]} →',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: controllers[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onChanged: (_) =>
                                  setState(() => isCorrect = null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              AnimatedButton(
                onPressed: _checkAnswer,
                width: 250.0,
                height: 60.0,
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
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 3: Add possessive suffixes
class Task3PossessiveSuffixes extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task3PossessiveSuffixes({super.key, required this.onCorrect});

  @override
  State<Task3PossessiveSuffixes> createState() =>
      _Task3PossessiveSuffixesState();
}

class _Task3PossessiveSuffixesState extends State<Task3PossessiveSuffixes> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> phrases = ['Менің кітап', 'Сенің дос', 'Оның сөмке'];
  final List<String> correctAnswers = ['ым', 'ың', 'сі'];
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    bool allCorrect = true;
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.toLowerCase() != correctAnswers[i]) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      isCorrect = allCorrect;
      showNotification = true;
    });
    _playSound(allCorrect);
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Тәуелдік жалғауын дұрыс қой',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${index + 1}. ${phrases[index]} →',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: controllers[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onChanged: (_) =>
                                  setState(() => isCorrect = null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              AnimatedButton(
                width: 250.0,
                height: 60.0,
                onPressed: _checkAnswer,
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
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 4: Identify case 1
class Task4IdentifyCase1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task4IdentifyCase1({super.key, required this.onCorrect});

  @override
  State<Task4IdentifyCase1> createState() => _Task4IdentifyCase1State();
}

class _Task4IdentifyCase1State extends State<Task4IdentifyCase1> {
  final List<String> options = [
    'Шығыс септік',
    'Барыс септік',
    'Көмектес септік'
  ];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Барыс септік';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Септік жалғауын анықташы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Text(
                  'Біз орманға бардық.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      onPressed: () => _checkAnswer(option),
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 5: Identify case 2
class Task5IdentifyCase2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task5IdentifyCase2({super.key, required this.onCorrect});

  @override
  State<Task5IdentifyCase2> createState() => _Task5IdentifyCase2State();
}

class _Task5IdentifyCase2State extends State<Task5IdentifyCase2> {
  final List<String> options = [
    'Шығыс септік',
    'Барыс септік',
    'Көмектес септік'
  ];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Шығыс септік';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Септік жалғауын анықташы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: const Text(
                  'Мен ауылдан келдім',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      onPressed: () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 6: Complete sentence with suffixes
class Task6CompleteSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6CompleteSentence({super.key, required this.onCorrect});

  @override
  State<Task6CompleteSentence> createState() => _Task6CompleteSentenceState();
}

class _Task6CompleteSentenceState extends State<Task6CompleteSentence> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer() {
    String answer1 = _controller1.text.toLowerCase().trim();
    String answer2 = _controller2.text.toLowerCase().trim();
    setState(() {
      isCorrect = answer1 == 'нен' && answer2 == 'тар';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөйлемдегі сөздерге дұрыс жалғау жалғап жазшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Дана мен Дариға дүкен',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    width: 60,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controller1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (_) => setState(() => isCorrect = null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('қызықты кітап',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    width: 60,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controller2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (_) => setState(() => isCorrect = null),
                    ),
                  ),
                  const Text(' сатып алды',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 40),
              AnimatedButton(
                onPressed: _checkAnswer,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  decoration: BoxDecoration(
                    color: isCorrect == null
                        ? const Color(0xFF58CC02)
                        : isCorrect!
                            ? const Color(0xFF58CC02)
                            : const Color(0xFFFF4B4B),
                    borderRadius: BorderRadius.circular(25),
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
        if (showNotification && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 7: Listen and identify case
class Task7ListenAndIdentifyCase extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task7ListenAndIdentifyCase({super.key, required this.onCorrect});

  @override
  State<Task7ListenAndIdentifyCase> createState() =>
      _Task7ListenAndIdentifyCaseState();
}

class _Task7ListenAndIdentifyCaseState
    extends State<Task7ListenAndIdentifyCase> {
  final List<String> options = ['жатыс септік', 'шығыс септік', 'барыс септік'];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'жатыс септік';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Аудионы тыңдап, қай септік екенін айтшы',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58CC02).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🔊 Дәптерімде')),
                        );
                      },
                      child: const Icon(Icons.volume_up,
                          size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      onPressed: () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 8: Read phrases (auto-skip)
class Task8ReadPhrases extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8ReadPhrases({super.key, required this.onCorrect});

  @override
  State<Task8ReadPhrases> createState() => _Task8ReadPhrasesState();
}

class _Task8ReadPhrasesState extends State<Task8ReadPhrases> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onCorrect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Экрандағы сөз тіркестерін дауыстап оқышы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Дананың кітабы',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58CC02)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Мараттың ойыншығы',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58CC02)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'орманға бару',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58CC02)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

// Task 9: Complete sentence 1
class Task9CompleteSentence1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task9CompleteSentence1({super.key, required this.onCorrect});

  @override
  State<Task9CompleteSentence1> createState() => _Task9CompleteSentence1State();
}

class _Task9CompleteSentence1State extends State<Task9CompleteSentence1> {
  final List<String> options = ['да', 'ға', 'нан'];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'да';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөйлемді толықтырып жазшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: const Text(
                  'Мен қала____ тұрамын.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      onPressed: () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

// Task 10: Complete sentence 2
class Task10CompleteSentence2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task10CompleteSentence2({super.key, required this.onCorrect});

  @override
  State<Task10CompleteSentence2> createState() =>
      _Task10CompleteSentence2State();
}

class _Task10CompleteSentence2State extends State<Task10CompleteSentence2> {
  final List<String> options = ['да', 'ға', 'нан'];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'да';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Сөйлемді толықтырып жазшы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: const Text(
                  'Күзде бақша__ жемістер піседі',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: options.map((option) {
                  Color backgroundColor = Colors.white;
                  Color borderColor = const Color(0xFFE5E5E5);

                  if (selectedAnswer == option) {
                    if (isCorrect!) {
                      backgroundColor = const Color(0xFF58CC02);
                      borderColor = const Color(0xFF58CC02);
                    } else {
                      backgroundColor = const Color(0xFFFF4B4B);
                      borderColor = const Color(0xFFFF4B4B);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedButton(
                      onPressed: () => _checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              isCorrect: isCorrect!,
              onContinue: () {
                if (isCorrect!) {
                  widget.onCorrect();
                } else {
                  setState(() {
                    showNotification = false;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}
