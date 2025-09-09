import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_button/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';

// Helper function to get button colors based on state
Color _getButtonColor(
    bool isSelected, bool isCorrect, bool isIncorrect, Color? backgroundColor) {
  if (isCorrect) return const Color(0xFF58CC02);
  if (isIncorrect) return const Color(0xFFFF4B4B);
  if (isSelected) return const Color(0xFF4A90E2);
  return backgroundColor ?? const Color(0xFFF8F9FA);
}

// Helper function to get text color based on state
Color _getTextColor(
    bool isSelected, bool isCorrect, bool isIncorrect, Color? textColor) {
  if (isCorrect || isIncorrect || isSelected) {
    return Colors.white;
  }
  return textColor ?? const Color(0xFF2C3E50);
}

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
            // Positioned Lottie
            Positioned(
              right: 20,
              top: -40, // Half of height 80
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

class SozstanJauanJinishkeScreen extends StatefulWidget {
  const SozstanJauanJinishkeScreen({super.key});

  @override
  State<SozstanJauanJinishkeScreen> createState() =>
      _SozstanJauanJinishkeScreenState();
}

class _SozstanJauanJinishkeScreenState
    extends State<SozstanJauanJinishkeScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 0;
  int _correctAnswers = 0;
  bool _showNotification = false;
  bool? _isCorrect;

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

  void _onCorrectAnswer() async {
    // Показываем уведомление
    setState(() {
      _showNotification = true;
      _isCorrect = true;
    });

    // Проигрываем звук правильного ответа
    await _audioPlayer.play(AssetSource('audio/correct.mp3'));

    setState(() {
      _correctAnswers++;
    });

    // Ждем анимацию
    await Future.delayed(const Duration(milliseconds: 1500));

    // Скрываем уведомление и переходим к следующей задаче
    setState(() {
      _showNotification = false;
    });

    _nextTask();
  }

  void _onIncorrectAnswer() async {
    // Показываем уведомление
    setState(() {
      _showNotification = true;
      _isCorrect = false;
    });

    // Проигрываем звук неправильного ответа
    await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));

    // Ждем анимацию
    await Future.delayed(const Duration(milliseconds: 1500));

    // Скрываем уведомление
    setState(() {
      _showNotification = false;
    });
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
                child: const Text(
                  'Артқа',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58CC02),
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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 50, left: 16, right: 16, bottom: 16),
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
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    Task1ListenAndFind(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task3AddSuffix1(onCorrect: _onCorrectAnswer),
                    Task4AddSuffix2(onCorrect: _onCorrectAnswer),
                    Task5FindThinWords(onCorrect: _onCorrectAnswer),
                    Task6SayWords(onCorrect: _onCorrectAnswer),
                    Task7MatchSuffixes1(onCorrect: _onCorrectAnswer),
                    Task8MatchSuffixes2(onCorrect: _onCorrectAnswer),
                    Task9FindExtra(onCorrect: _onCorrectAnswer),
                    Task10ListenAndFindThin(onCorrect: _onCorrectAnswer),
                  ],
                ),
              ),
            ],
          ),
          if (_showNotification && _isCorrect != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnswerNotification(
                isCorrect: _isCorrect!,
                onContinue: () {
                  setState(() {
                    _showNotification = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Task 1: Listen and find sounds
class Task1ListenAndFind extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task1ListenAndFind(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task1ListenAndFind> createState() => _Task1ListenAndFindState();
}

class _Task1ListenAndFindState extends State<Task1ListenAndFind> {
  final List<String> options = ['а, ы, о', 'а, о, ы, і', 'а, ы, і, ө'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) async {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'а, о, ы, і';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
      // Ждем немного и сбрасываем ответ
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Сөздегі жуан дауыстыларды табыңыз:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'ҚАБЫРҒА',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Жауапты таңдаңыз:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: ChicletAnimatedButton(
                        width: 230.0,
                        height: 60.0,
                        onPressed: selectedAnswer != null
                            ? () {}
                            : () {
                                HapticFeedback.lightImpact();
                                _checkAnswer(option);
                              },
                        backgroundColor: _getButtonColor(
                            selectedAnswer == option,
                            selectedAnswer == option && isCorrect == true,
                            selectedAnswer == option && isCorrect == false,
                            null),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _getTextColor(
                                selectedAnswer == option,
                                selectedAnswer == option && isCorrect == true,
                                selectedAnswer == option && isCorrect == false,
                                null),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Simplified implementations for other tasks using AnimatedButton
class Task2FindThickWords extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task2FindThickWords({super.key, required this.onCorrect});
  @override
  State<Task2FindThickWords> createState() => _Task2FindThickWordsState();
}

class _Task2FindThickWordsState extends State<Task2FindThickWords> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ChicletAnimatedButton(
      width: 200.0,
      height: 60.0,
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onCorrect();
      },
      backgroundColor: const Color(0xFF58CC02),
      child: const Text('Task 2 - Continue',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    ));
  }
}

class Task3AddSuffix1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task3AddSuffix1({super.key, required this.onCorrect});
  @override
  State<Task3AddSuffix1> createState() => _Task3AddSuffix1State();
}

class _Task3AddSuffix1State extends State<Task3AddSuffix1> {
  String selected = '';
  final List<String> options = ['Лар', 'Лер', 'Дар'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Берілген сөз: қала',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const Text('Қай жалғау дұрыс?'),
          const SizedBox(height: 12),
          ...options.map((opt) {
            final isSelected = selected == opt;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: AnimatedButton(
                  width: 230.0,
                  height: 56,
                  color: _getButtonColor(isSelected, isSelected && opt == 'Лар',
                      isSelected && opt != 'Лар', null),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => selected = opt);
                    if (opt == 'Лар') {
                      Future.delayed(const Duration(milliseconds: 240),
                          () => widget.onCorrect());
                    }
                  },
                  child: Text(opt,
                      style: TextStyle(
                          color: _getTextColor(
                              isSelected,
                              isSelected && opt == 'Лар',
                              isSelected && opt != 'Лар',
                              null),
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class Task4AddSuffix2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task4AddSuffix2({super.key, required this.onCorrect});
  @override
  State<Task4AddSuffix2> createState() => _Task4AddSuffix2State();
}

class _Task4AddSuffix2State extends State<Task4AddSuffix2> {
  String selected = '';
  final List<String> options = ['лер', 'дер', 'лар'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Берілген сөз: гүл',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const Text('Қай жалғау дұрыс?'),
          const SizedBox(height: 12),
          ...options.map((opt) {
            final isSelected = selected == opt;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: AnimatedButton(
                  width: 230.0,
                  height: 56,
                  color: _getButtonColor(isSelected, isSelected && opt == 'дер',
                      isSelected && opt != 'дер', null),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => selected = opt);
                    if (opt == 'дер') {
                      Future.delayed(const Duration(milliseconds: 240),
                          () => widget.onCorrect());
                    }
                  },
                  child: Text(opt,
                      style: TextStyle(
                          color: _getTextColor(
                              isSelected,
                              isSelected && opt == 'дер',
                              isSelected && opt != 'дер',
                              null),
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class Task5FindThinWords extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task5FindThinWords({super.key, required this.onCorrect});
  @override
  State<Task5FindThinWords> createState() => _Task5FindThinWordsState();
}

class _Task5FindThinWordsState extends State<Task5FindThinWords> {
  String selected = '';
  final List<String> options = [
    'қасық, тіс, нан',
    'кеме, тау, көл',
    'тіс, береке, кеме'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Тек жіңішке дыбыстан құралған сөзді тапшы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...options.map((opt) {
            final isSelected = selected == opt;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: AnimatedButton(
                  width: 230.0,
                  height: 56,
                  color: _getButtonColor(
                      isSelected,
                      isSelected && opt == 'тіс, береке, кеме',
                      isSelected && opt != 'тіс, береке, кеме',
                      null),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => selected = opt);
                    if (opt == 'тіс, береке, кеме') {
                      Future.delayed(const Duration(milliseconds: 240),
                          () => widget.onCorrect());
                    }
                  },
                  child: Text(opt,
                      style: TextStyle(
                          color: _getTextColor(
                              isSelected,
                              isSelected && opt == 'тіс, береке, кеме',
                              isSelected && opt != 'тіс, береке, кеме',
                              null),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class Task6SayWords extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6SayWords({super.key, required this.onCorrect});
  @override
  State<Task6SayWords> createState() => _Task6SayWordsState();
}

class _Task6SayWordsState extends State<Task6SayWords> {
  bool recorded = false;

  // NOTE: full speech recognition is not implemented here. We provide a simple
  // placeholder where the child can press 'Record' then 'Тексеру' to confirm.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Берілген сөздер:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Text('қалам, өрік, гүл, көл', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                AnimatedButton(
                  width: 160,
                  height: 48,
                  color: recorded
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFFFFFFFF),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => recorded = !recorded);
                  },
                  child: Text(recorded ? 'Тыңдалды' : 'Жазу',
                      style: TextStyle(
                          color:
                              recorded ? Colors.white : const Color(0xFF4A90E2),
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  width: 160,
                  height: 48,
                  color: const Color(0xFF58CC02),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // We assume the child spoke the words; mark as correct.
                    widget.onCorrect();
                  },
                  child: const Text('Тексеру',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Task7MatchSuffixes1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task7MatchSuffixes1({super.key, required this.onCorrect});
  @override
  State<Task7MatchSuffixes1> createState() => _Task7MatchSuffixes1State();
}

class _Task7MatchSuffixes1State extends State<Task7MatchSuffixes1> {
  // Simple drag & drop matching implementation
  final List<String> roots = ['алма', 'кітап', 'бесік'];
  final List<String> suffixes = ['лар', 'тар', 'тер'];
  final Map<String, String> correct = {
    'алма': 'лар',
    'кітап': 'тар',
    'бесік': 'тер',
  };

  Map<String, String?> assigned = {};

  @override
  void initState() {
    super.initState();
    for (var r in roots) assigned[r] = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Сәйкестендіріп қойыңыз',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: roots.map((r) {
                    return DragTarget<String>(
                      builder: (context, candidate, rejected) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: assigned[r] != null
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r,
                                  style: TextStyle(
                                      color: assigned[r] != null
                                          ? Colors.white
                                          : const Color(0xFF2C3E50),
                                      fontSize: 16)),
                              Text(assigned[r] ?? '',
                                  style: TextStyle(
                                      color: assigned[r] != null
                                          ? Colors.white
                                          : const Color(0xFF9AA3AD))),
                            ],
                          ),
                        );
                      },
                      onAccept: (data) {
                        setState(() => assigned[r] = data);
                        // Check if all matched correctly
                        if (assigned.values.every((v) => v != null)) {
                          var ok = true;
                          for (var key in assigned.keys) {
                            if (correct[key] != assigned[key]) ok = false;
                          }
                          if (ok)
                            Future.delayed(const Duration(milliseconds: 200),
                                () => widget.onCorrect());
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: suffixes.map((s) {
                  return Draggable<String>(
                    data: s,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(s,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    childWhenDragging: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF0F3F6),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(s,
                          style: const TextStyle(color: Color(0xFF9AA3AD))),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDEE6EB))),
                      child: Text(s,
                          style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w700)),
                    ),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Task8MatchSuffixes2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8MatchSuffixes2({super.key, required this.onCorrect});
  @override
  State<Task8MatchSuffixes2> createState() => _Task8MatchSuffixes2State();
}

class _Task8MatchSuffixes2State extends State<Task8MatchSuffixes2> {
  final List<String> roots = ['кеме', 'қыз', 'ұл'];
  final List<String> suffixes = ['лер', 'дар', 'дар'];
  final Map<String, String> correct = {
    'кеме': 'лер',
    'қыз': 'дар',
    'ұл': 'дар',
  };

  Map<String, String?> assigned = {};

  @override
  void initState() {
    super.initState();
    for (var r in roots) assigned[r] = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Сәйкестендіріп қойыңыз',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: roots.map((r) {
                    return DragTarget<String>(
                      builder: (context, candidate, rejected) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: assigned[r] != null
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r,
                                  style: TextStyle(
                                      color: assigned[r] != null
                                          ? Colors.white
                                          : const Color(0xFF2C3E50),
                                      fontSize: 16)),
                              Text(assigned[r] ?? '',
                                  style: TextStyle(
                                      color: assigned[r] != null
                                          ? Colors.white
                                          : const Color(0xFF9AA3AD))),
                            ],
                          ),
                        );
                      },
                      onAccept: (data) {
                        // place the suffix into the first empty slot that expects this value
                        setState(() {
                          // find a root that is empty and expects this suffix
                          for (var key in roots) {
                            if (assigned[key] == null && correct[key] == data) {
                              assigned[key] = data;
                              break;
                            }
                          }
                        });
                        if (assigned.values.every((v) => v != null)) {
                          var ok = true;
                          for (var key in assigned.keys) {
                            if (correct[key] != assigned[key]) ok = false;
                          }
                          if (ok)
                            Future.delayed(const Duration(milliseconds: 200),
                                () => widget.onCorrect());
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: suffixes.map((s) {
                  return Draggable<String>(
                    data: s,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(s,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    childWhenDragging: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF0F3F6),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(s,
                          style: const TextStyle(color: Color(0xFF9AA3AD))),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDEE6EB))),
                      child: Text(s,
                          style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w700)),
                    ),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Task9FindExtra extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task9FindExtra({super.key, required this.onCorrect});
  @override
  State<Task9FindExtra> createState() => _Task9FindExtraState();
}

class _Task9FindExtraState extends State<Task9FindExtra> {
  String selected = '';
  final List<String> options = ['бала', 'нан', 'тас', 'тіс', 'тау'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Артық сөзді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...options.map((o) {
          final isSelected = selected == o;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: AnimatedButton(
                width: 230.0,
                height: 52,
                color: _getButtonColor(isSelected, isSelected && o == 'тіс',
                    isSelected && o != 'тіс', null),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => selected = o);
                  if (o == 'тіс')
                    Future.delayed(const Duration(milliseconds: 200),
                        () => widget.onCorrect());
                },
                child: Text(o,
                    style: TextStyle(
                        color: _getTextColor(
                            isSelected,
                            isSelected && o == 'тіс',
                            isSelected && o != 'тіс',
                            null),
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          );
        })
      ]),
    );
  }
}

class Task10ListenAndFindThin extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task10ListenAndFindThin({super.key, required this.onCorrect});
  @override
  State<Task10ListenAndFindThin> createState() =>
      _Task10ListenAndFindThinState();
}

class _Task10ListenAndFindThinState extends State<Task10ListenAndFindThin> {
  String selected = '';
  bool playing = false;
  final List<String> options = ['ауа', 'алма', 'тау', 'бесік'];

  void _playAudio() {
    // Placeholder: actual audio playback should be implemented with assets or TTS
    setState(() => playing = true);
    Future.delayed(const Duration(milliseconds: 800),
        () => setState(() => playing = false));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Аудионы тыңдап, жіңішке дыбыстағы сөзді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              AnimatedButton(
                width: 160,
                height: 48,
                color:
                    playing ? const Color(0xFF4A90E2) : const Color(0xFFFFFFFF),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _playAudio();
                },
                child: Text(playing ? 'Ойнап жатыр...' : 'Тыңдау',
                    style: TextStyle(
                        color: playing ? Colors.white : const Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              ...options.map((o) {
                final isSelected = selected == o;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AnimatedButton(
                    width: 230.0,
                    height: 52,
                    color: _getButtonColor(
                        isSelected,
                        isSelected && o == 'бесік',
                        isSelected && o != 'бесік',
                        null),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() => selected = o);
                      if (o == 'бесік')
                        Future.delayed(const Duration(milliseconds: 200),
                            () => widget.onCorrect());
                    },
                    child: Text(o,
                        style: TextStyle(
                            color: _getTextColor(
                                isSelected,
                                isSelected && o == 'бесік',
                                isSelected && o != 'бесік',
                                null),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                );
              })
            ],
          ),
        )
      ]),
    );
  }
}
