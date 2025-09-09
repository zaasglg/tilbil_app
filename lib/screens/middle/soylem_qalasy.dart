import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chiclet/chiclet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// Answer notification widget
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

class SoylemQalasyScreen extends StatefulWidget {
  const SoylemQalasyScreen({super.key});

  @override
  State<SoylemQalasyScreen> createState() => _SoylemQalasyScreenState();
}

class _SoylemQalasyScreenState extends State<SoylemQalasyScreen> {
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

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
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
                Task1CorrectSentence(onCorrect: _nextTask),
                Task2FindCapitalLetter(onCorrect: _nextTask),
                Task3ListenAndWrite(onCorrect: _nextTask),
                Task4CorrectPunctuation(onCorrect: _nextTask),
                Task5SentenceType(onCorrect: _nextTask),
                Task6CreateSentence(onCorrect: _nextTask),
                Task7SplitSentence(onCorrect: _nextTask),
                Task8RemoveExtra(onCorrect: _nextTask),
                Task9FillBlank1(onCorrect: _nextTask),
                Task10FillBlank2(onCorrect: _nextTask),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Task 1: Choose correctly written sentence
class Task1CorrectSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task1CorrectSentence({super.key, required this.onCorrect});

  @override
  State<Task1CorrectSentence> createState() => _Task1CorrectSentenceState();
}

class _Task1CorrectSentenceState extends State<Task1CorrectSentence> {
  final List<String> options = [
    'мен астанада тұрамын.',
    'Мен Астанада тұрамын',
    'Мен астанада тұрамын.'
  ];
  String? selectedAnswer;
  bool? isCorrect;
  bool showNotification = false;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Мен астанада тұрамын.';
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
    widget.onCorrect();
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
                'Бас әріпі мен тыныс белгісі дұрыс жазылған сөйлемді таңдашы',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Column(
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  String label = ['а)', 'ә)', 'б)'][index];

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
                    child: ElevatedButton(
                      onPressed:
                          showNotification ? null : () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: backgroundColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                        fixedSize: const Size(250, 60),
                        side: BorderSide(color: borderColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '$label $option',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
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
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 2: Find word that starts with capital letter
class Task2FindCapitalLetter extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task2FindCapitalLetter({super.key, required this.onCorrect});

  @override
  State<Task2FindCapitalLetter> createState() => _Task2FindCapitalLetterState();
}

class _Task2FindCapitalLetterState extends State<Task2FindCapitalLetter> {
  final List<String> options = ['Құстар', 'ұшты', 'жылы'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Құстар';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Бас әріптен басталатын сөзді тапшы',
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
              'құстар жылы жаққа ұшты',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = ['а)', 'ә)', 'б)'][index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswer == option
                        ? (isCorrect == true
                            ? const Color(0xFF58CC02)
                            : const Color(0xFFFF4B4B))
                        : Colors.white,
                    foregroundColor:
                        selectedAnswer == option ? Colors.white : Colors.black,
                    fixedSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '$label $option',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 3: Listen and write sentence
class Task3ListenAndWrite extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task3ListenAndWrite({super.key, required this.onCorrect});

  @override
  State<Task3ListenAndWrite> createState() => _Task3ListenAndWriteState();
}

class _Task3ListenAndWriteState extends State<Task3ListenAndWrite> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer == 'Мен бүгін кітапханаға бардым.';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Аудионы тыңдап, сөйлемді жазшы',
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
                      const SnackBar(
                          content: Text('🔊 Мен бүгін кітапханаға бардым')),
                    );
                  },
                  child: const Icon(Icons.volume_up,
                      size: 50, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isCorrect == null
                    ? const Color(0xFFE5E5E5)
                    : isCorrect!
                        ? const Color(0xFF58CC02)
                        : const Color(0xFFFF4B4B),
                width: 2,
              ),
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Сөйлемді жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: (_) => setState(() => isCorrect = null),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect == null
                    ? const Color(0xFF58CC02)
                    : isCorrect!
                        ? const Color(0xFF58CC02)
                        : const Color(0xFFFF4B4B),
                foregroundColor: Colors.white,
                fixedSize: const Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Тексеру',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Task 4: Choose correct punctuation
class Task4CorrectPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task4CorrectPunctuation({super.key, required this.onCorrect});

  @override
  State<Task4CorrectPunctuation> createState() =>
      _Task4CorrectPunctuationState();
}

class _Task4CorrectPunctuationState extends State<Task4CorrectPunctuation> {
  final List<String> options = [
    'нүкте (.)',
    'сұрақ белгісі (?)',
    'леп белгісі (!)'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'нүкте (.)';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлемді дұрыс тыныс белгісімен аяқта',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              'Сен мектепке барасың',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = ['а)', 'б)', 'в)'][index];

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
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: backgroundColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    side: BorderSide(color: borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    '$label $option',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 5: Identify sentence type
class Task5SentenceType extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task5SentenceType({super.key, required this.onCorrect});

  @override
  State<Task5SentenceType> createState() => _Task5SentenceTypeState();
}

class _Task5SentenceTypeState extends State<Task5SentenceType> {
  final List<String> options = ['Хабарлы', 'Сұраулы', 'Лепті'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Лепті';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлем түрін тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: const Text(
              'Күн қандай тамаша!',
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
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: backgroundColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    side: BorderSide(color: borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 6: Create sentence from picture
class Task6CreateSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6CreateSentence({super.key, required this.onCorrect});

  @override
  State<Task6CreateSentence> createState() => _Task6CreateSentenceState();
}

class _Task6CreateSentenceState extends State<Task6CreateSentence> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  bool? isCorrect;

  void _checkAnswer() {
    String sentence = _controllers.map((c) => c.text.trim()).join(' ');
    setState(() {
      isCorrect = sentence.toLowerCase() == 'балалар доп ойнап жүр';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Суретке қарап сөйлем құрастыршы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Center(
              child: Text(
                '🧒👦⚽🏃‍♂️\nБалалар доп ойнап жүр',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (_) => setState(() => isCorrect = null),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect == null
                  ? const Color(0xFF58CC02)
                  : isCorrect!
                      ? const Color(0xFF58CC02)
                      : const Color(0xFFFF4B4B),
              foregroundColor: Colors.white,
              fixedSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Task 7: Split sentence correctly
class Task7SplitSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task7SplitSentence({super.key, required this.onCorrect});

  @override
  State<Task7SplitSentence> createState() => _Task7SplitSentenceState();
}

class _Task7SplitSentenceState extends State<Task7SplitSentence> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer = _controller.text.trim();
    setState(() {
      isCorrect = answer == 'Асан мектепке барды. Ол сабаққа дайындалды.';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлемді екіге бөліп, дұрыстап жазшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Text(
              'Асан мектепке барды ол сабаққа дайындалды',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isCorrect == null
                    ? const Color(0xFFE5E5E5)
                    : isCorrect!
                        ? const Color(0xFF58CC02)
                        : const Color(0xFFFF4B4B),
                width: 2,
              ),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Екі сөйлемге бөліп жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: (_) => setState(() => isCorrect = null),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              fixedSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Task 8: Remove extra word
class Task8RemoveExtra extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8RemoveExtra({super.key, required this.onCorrect});

  @override
  State<Task8RemoveExtra> createState() => _Task8RemoveExtraState();
}

class _Task8RemoveExtraState extends State<Task8RemoveExtra> {
  final List<String> words = ['Жазда', 'күн', 'ыстықтап', 'ыстық', 'болады'];
  final List<bool> selectedWords = List.generate(5, (index) => false);
  bool? isCorrect;

  void _selectWord(int index) {
    setState(() {
      selectedWords[index] = !selectedWords[index];
      isCorrect = null;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedWords[2] &&
          selectedWords.where((selected) => selected).length == 1;
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Артық сөзді алып тасташы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.yellow, width: 2),
            ),
            child: const Text(
              'Жазда күн ыстықтап ыстық болады',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: words.asMap().entries.map((entry) {
              int index = entry.key;
              String word = entry.value;
              bool isSelected = selectedWords[index];

              return ElevatedButton(
                onPressed: () => _selectWord(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? const Color(0xFFFF4B4B) : Colors.white,
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  side: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  word,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect == null
                  ? const Color(0xFF58CC02)
                  : isCorrect!
                      ? const Color(0xFF58CC02)
                      : const Color(0xFFFF4B4B),
              foregroundColor: Colors.white,
              fixedSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Task 9: Fill blank 1
class Task9FillBlank1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task9FillBlank1({super.key, required this.onCorrect});

  @override
  State<Task9FillBlank1> createState() => _Task9FillBlank1State();
}

class _Task9FillBlank1State extends State<Task9FillBlank1> {
  final List<String> options = ['еліміздің', 'күннің', 'Астана'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'еліміздің';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Бос орынды толтырып жазшы',
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
              'Астана - _______ бас қаласы.',
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
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: backgroundColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    side: BorderSide(color: borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 10: Fill blank 2
class Task10FillBlank2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task10FillBlank2({super.key, required this.onCorrect});

  @override
  State<Task10FillBlank2> createState() => _Task10FillBlank2State();
}

class _Task10FillBlank2State extends State<Task10FillBlank2> {
  final List<String> options = ['жылдам', 'артқа', 'аспанға'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'жылдам';
    });

    if (isCorrect!) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onCorrect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Бос орынды толтырып жазшы',
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
              'Данияр үйіне _______ барды.',
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
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: backgroundColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    side: BorderSide(color: borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
