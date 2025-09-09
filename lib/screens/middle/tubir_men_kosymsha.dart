import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chiclet/chiclet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:til_bil_app/services/sound_service.dart';

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

class TubirMenKosymshaScreen extends StatefulWidget {
  const TubirMenKosymshaScreen({super.key});

  @override
  State<TubirMenKosymshaScreen> createState() => _TubirMenKosymshaScreenState();
}

class _TubirMenKosymshaScreenState extends State<TubirMenKosymshaScreen> {
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
                Task1FindRoot(onCorrect: _nextTask),
                // Task2SayRoot(onCorrect: _nextTask),
                Task3FindCorrectSuffix(onCorrect: _nextTask),
                Task4CompleteSentence1(onCorrect: _nextTask),
                Task5CompleteSentence2(onCorrect: _nextTask),
                Task6FindExtraSuffix(onCorrect: _nextTask),
                Task7FindCorrectSyllable1(onCorrect: _nextTask),
                Task8FindCorrectSyllable2(onCorrect: _nextTask),
                // Task9MatchRootSuffix(onCorrect: _nextTask),
                // Task10BuildWord(onCorrect: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Listen and find root
class Task1FindRoot extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task1FindRoot({super.key, required this.onCorrect});

  @override
  State<Task1FindRoot> createState() => _Task1FindRootState();
}

class _Task1FindRootState extends State<Task1FindRoot> {
  final List<String> options = ['кітап', 'кітапхан', 'хана'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'кітап';
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
            'Аудионы тыңдап, сөздің түбірін тапшы',
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
                      const SnackBar(content: Text('🔊 кітапхана')),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.map((option) {
              Color backgroundColor = Colors.white;
              // borderColor removed — button now uses AnimatedButton.color

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

// Task 2: Say root (auto-skip)
class Task2SayRoot extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task2SayRoot({super.key, required this.onCorrect});

  @override
  State<Task2SayRoot> createState() => _Task2SayRootState();
}

class _Task2SayRootState extends State<Task2SayRoot> {
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
            'Экрандағы сөзге қарап, оның түбірін дауыстап айтшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            'ғарышкер',
            style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02)),
          ),
          SizedBox(height: 20),
          Text(
            'Түбірі: ғарыш',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 40),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

// Task 3: Find correct suffix
class Task3FindCorrectSuffix extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task3FindCorrectSuffix({super.key, required this.onCorrect});

  @override
  State<Task3FindCorrectSuffix> createState() => _Task3FindCorrectSuffixState();
}

class _Task3FindCorrectSuffixState extends State<Task3FindCorrectSuffix> {
  final List<String> options = ['жылқышы', 'аспазгер', 'кітапқой'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'жылқышы';
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
            'Экранда берілген түбірге дұрыс қосымша жалғанған сөзді тап',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.map((option) {
              Color backgroundColor = Colors.white;
              // borderColor removed — button now uses AnimatedButton.color

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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

// Task 4: Complete sentence 1
class Task4CompleteSentence1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task4CompleteSentence1({super.key, required this.onCorrect});

  @override
  State<Task4CompleteSentence1> createState() => _Task4CompleteSentence1State();
}

class _Task4CompleteSentence1State extends State<Task4CompleteSentence1> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer = _controller.text.toLowerCase().trim();
    setState(() {
      isCorrect = answer == 'ге';
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
            'Сөйлемде берілген түбірге дұрыс қосымша жалғап жазшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Мен үй',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 80,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text(' бардым',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
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
                borderRadius: BorderRadius.circular(12),
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

// Task 5: Complete sentence 2
class Task5CompleteSentence2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task5CompleteSentence2({super.key, required this.onCorrect});

  @override
  State<Task5CompleteSentence2> createState() => _Task5CompleteSentence2State();
}

class _Task5CompleteSentence2State extends State<Task5CompleteSentence2> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer = _controller.text.toLowerCase().trim();
    setState(() {
      isCorrect = answer == 'ды';
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
            'Сөйлемде берілген түбірге дұрыс қосымша жалғап жазшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Дана Асан',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 80,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text(' көрді',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
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
                borderRadius: BorderRadius.circular(12),
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

// Task 6: Find extra suffix
class Task6FindExtraSuffix extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6FindExtraSuffix({super.key, required this.onCorrect});

  @override
  State<Task6FindExtraSuffix> createState() => _Task6FindExtraSuffixState();
}

class _Task6FindExtraSuffixState extends State<Task6FindExtraSuffix> {
  final List<String> options = ['хана', 'та', 'шық'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'шық';
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
            'Төменде берілген қосымшалардың бірі түбірге сай келмейді, артығын тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              'кітап',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.map((option) {
              Color backgroundColor = Colors.white;
              // borderColor removed — button now uses AnimatedButton.color

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '- $option',
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

// Task 7: Find correct syllable division 1
class Task7FindCorrectSyllable1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task7FindCorrectSyllable1({super.key, required this.onCorrect});

  @override
  State<Task7FindCorrectSyllable1> createState() =>
      _Task7FindCorrectSyllable1State();
}

class _Task7FindCorrectSyllable1State extends State<Task7FindCorrectSyllable1> {
  final List<String> options = ['ойна-дық', 'ау-ылдар', 'до-стары'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'ойна-дық';
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
            'Түбір мен қосымша дұрыс буынға бөлінген қатарды тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.map((option) {
              Color backgroundColor = Colors.white;
              // borderColor removed — button now uses AnimatedButton.color

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AnimatedButton(
                  onPressed: () => _checkAnswer(option),
                  width: 250,
                  height: 60,
                  color: backgroundColor,
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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

// Task 8: Find correct syllable division 2
class Task8FindCorrectSyllable2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8FindCorrectSyllable2({super.key, required this.onCorrect});

  @override
  State<Task8FindCorrectSyllable2> createState() =>
      _Task8FindCorrectSyllable2State();
}

class _Task8FindCorrectSyllable2State extends State<Task8FindCorrectSyllable2> {
  final List<String> options = ['сөз-гер', 'мек-тепке', 'бар-ды'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'бар-ды';
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
            'Түбір мен қосымша дұрыс буынға бөлінген қатарды тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.map((option) {
              Color backgroundColor = Colors.white;
              // borderColor removed — button now uses AnimatedButton.color

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AnimatedButton(
                  onPressed: () => _checkAnswer(option),
                  width: 250,
                  height: 60,
                  color: backgroundColor,
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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

// Task 9: Match root with suffix
class Task9MatchRootSuffix extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task9MatchRootSuffix({super.key, required this.onCorrect});

  @override
  State<Task9MatchRootSuffix> createState() => _Task9MatchRootSuffixState();
}

class _Task9MatchRootSuffixState extends State<Task9MatchRootSuffix> {
  final Map<String, String> correctMatches = {
    'бар': 'ды',
    'аспаз': 'шы',
  };

  final Map<String, String?> userMatches = {
    'бар': null,
    'аспаз': null,
  };

  void _onMatch(String word, String suffix) {
    setState(() {
      userMatches[word] = suffix;
    });

    if (userMatches.values.every((v) => v != null)) {
      bool allCorrect = true;
      for (String word in correctMatches.keys) {
        if (userMatches[word] != correctMatches[word]) {
          allCorrect = false;
          break;
        }
      }

      if (allCorrect) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          widget.onCorrect();
        });
      }
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
            'Түбір сөздерді дұрыс жалғаумен сәйкестендірші',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: correctMatches.keys.map((word) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(word,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Column(
                  children: ['ды', 'шы'].map((suffix) {
                    return AnimatedButton(
                      onPressed: () {
                        for (String word in correctMatches.keys) {
                          if (correctMatches[word] == suffix &&
                              userMatches[word] == null) {
                            _onMatch(word, suffix);
                            break;
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(suffix,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Task 10: Build word from parts
class Task10BuildWord extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task10BuildWord({super.key, required this.onCorrect});

  @override
  State<Task10BuildWord> createState() => _Task10BuildWordState();
}

class _Task10BuildWordState extends State<Task10BuildWord> {
  final List<String> wordParts = ['гер', 'ды', 'кер', 'ғарыш', 'гүл'];
  final List<String> selectedParts = [];
  bool? isCorrect;

  void _selectPart(String part) {
    setState(() {
      if (selectedParts.contains(part)) {
        selectedParts.remove(part);
      } else {
        selectedParts.add(part);
      }
      isCorrect = null;
    });
  }

  void _checkAnswer() {
    String builtWord = selectedParts.join('');
    setState(() {
      isCorrect = builtWord == 'ғарышкер';
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
            'Берілген түбір мен жалғаудан сөз құрастыршы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                selectedParts.join(''),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: wordParts.map((part) {
              bool isSelected = selectedParts.contains(part);
              return AnimatedButton(
                onPressed: () => _selectPart(part),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF58CC02) : Colors.white,
                    border:
                        Border.all(color: const Color(0xFFE5E5E5), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    part,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          AnimatedButton(
            onPressed: _checkAnswer,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    );
  }
}
