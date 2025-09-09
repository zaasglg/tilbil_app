import 'package:audioplayers/audioplayers.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                padding: const EdgeInsets.fromLTRB(
                    20, 80, 20, 20), // Extra top padding for Lottie
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isCorrect ? 'Керемет!' : 'Қате!',
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isCorrect ? 'Дұрыс жауап!' : 'Қайтадан көріңіз',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
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
            // The Lottie animation that overflows above the notification
            Positioned(
              top: -10, // This makes it overflow above the container
              left: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                child: Lottie.asset(
                  widget.isCorrect
                      ? 'assets/lottie/correct.json'
                      : 'assets/lottie/incorrect.json',
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DybysPatshalygyTurleriScreen extends StatefulWidget {
  const DybysPatshalygyTurleriScreen({super.key});

  @override
  State<DybysPatshalygyTurleriScreen> createState() =>
      _DybysPatshalygyTurleriScreenState();
}

class _DybysPatshalygyTurleriScreenState
    extends State<DybysPatshalygyTurleriScreen> {
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
                    Task1ListenAndWrite(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task2FindHardSounds(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task3FindSoftSounds(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task4FindSonantSounds(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task5IdentifyStartSound(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task6CompleteWord1(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task7CompleteWord2(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task8ReadLetters(onCorrect: _onCorrectAnswer),
                    Task9ConvertToSoft(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
                    Task10FindSonantWords(
                        onCorrect: _onCorrectAnswer,
                        onIncorrect: _onIncorrectAnswer),
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

// Task 1: Listen and write consonants
class Task1ListenAndWrite extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task1ListenAndWrite(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task1ListenAndWrite> createState() => _Task1ListenAndWriteState();
}

class _Task1ListenAndWriteState extends State<Task1ListenAndWrite> {
  final TextEditingController _controller = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer =
        _controller.text.toLowerCase().replaceAll(' ', '').replaceAll(',', '');
    setState(() {
      isCorrect = answer == 'жр' || answer == 'рж';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Аудионы тыңдап, дауыссыз дыбыстарды жазшы',
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
                    soundService.playSegment(37000, 41000);
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
                hintText: 'Дауыссыз дыбыстарды жазыңыз',
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
                backgroundColor: const Color(0xFF58CC02),
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
          ),
        ],
      ),
    );
  }
}

// Task 2: Find hard sound words
class Task2FindHardSounds extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task2FindHardSounds(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task2FindHardSounds> createState() => _Task2FindHardSoundsState();
}

class _Task2FindHardSoundsState extends State<Task2FindHardSounds> {
  final List<String> options = ['тақта', 'бор', 'жібек'];
  String? selectedAnswer;
  bool? isCorrect;
  bool _answered = false;

  void _checkAnswer(String answer) {
    if (_answered) return;
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'тақта';
      _answered = true;
    });

    if (isCorrect == true) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Тек қатаң дыбыстан жасалған сөзді тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Column(
            children: options.map((option) {
              Color backgroundColor = Colors.white;

              if (selectedAnswer == option) {
                if (isCorrect!) {
                  backgroundColor = const Color(0xFF58CC02);
                } else {
                  backgroundColor = const Color(0xFFFF4B4B);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _answered ? null : () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: Colors.black,
                      fixedSize: const Size(250, 72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        option,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
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

// Task 3: Find soft sound words
class Task3FindSoftSounds extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task3FindSoftSounds(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task3FindSoftSounds> createState() => _Task3FindSoftSoundsState();
}

class _Task3FindSoftSoundsState extends State<Task3FindSoftSounds> {
  final List<String> options = ['видео', 'парта', 'зымыран'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'видео';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Тек ұяң дыбыстан құралған сөзді тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: Colors.black,
                        fixedSize: const Size(250, 56),
                        elevation: 0,
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

// Task 4: Find sonant sound words
class Task4FindSonantSounds extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task4FindSonantSounds(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task4FindSonantSounds> createState() => _Task4FindSonantSoundsState();
}

class _Task4FindSonantSoundsState extends State<Task4FindSonantSounds> {
  final List<String> options = ['күрек', 'бата', 'нар'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'нар';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Тек үнді дыбыстан құралған сөзді тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: Colors.black,
                        fixedSize: const Size(250, 56),
                        elevation: 0,
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

// Task 5: Identify starting sound type
class Task5IdentifyStartSound extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task5IdentifyStartSound(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task5IdentifyStartSound> createState() =>
      _Task5IdentifyStartSoundState();
}

class _Task5IdentifyStartSoundState extends State<Task5IdentifyStartSound> {
  final List<String> options = ['қатаң', 'үнді', 'ұяң'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'қатаң';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Төмендегі сөздер қандай дыбыстан басталатынын тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              'сағат, тақтай, сөмке',
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
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: Colors.black,
                      fixedSize: const Size(250, 50),
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
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 6: Complete word 1 (Қарлығаш)
class Task6CompleteWord1 extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task6CompleteWord1(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task6CompleteWord1> createState() => _Task6CompleteWord1State();
}

class _Task6CompleteWord1State extends State<Task6CompleteWord1> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer1 = _controller1.text.toLowerCase();
    String answer2 = _controller2.text.toLowerCase();
    setState(() {
      isCorrect = answer1 == 'р' && answer2 == 'ғ';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Түсіп қалған дыбыстарды қойып, сөзді толықтырып шықшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Қа',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  maxLength: 1,
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text('лы',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  maxLength: 1,
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text('аш',
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
              fixedSize: const Size(250, 56),
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

// Task 7: Complete word 2 (Велосипед)
class Task7CompleteWord2 extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task7CompleteWord2(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task7CompleteWord2> createState() => _Task7CompleteWord2State();
}

class _Task7CompleteWord2State extends State<Task7CompleteWord2> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool? isCorrect;

  void _checkAnswer() {
    String answer1 = _controller1.text.toLowerCase();
    String answer2 = _controller2.text.toLowerCase();
    setState(() {
      isCorrect = answer1 == 'л' && answer2 == 'п';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Түсіп қалған дыбыстарды қойып, сөзді толықтырып шықшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ве',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  maxLength: 1,
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text('оси',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  maxLength: 1,
                  onChanged: (_) => setState(() => isCorrect = null),
                ),
              ),
              const Text('ед',
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
              fixedSize: const Size(250, 56),
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

// Task 8: Read letters (auto-skip)
class Task8ReadLetters extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8ReadLetters({super.key, required this.onCorrect});

  @override
  State<Task8ReadLetters> createState() => _Task8ReadLettersState();
}

class _Task8ReadLettersState extends State<Task8ReadLetters> {
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
            'Төменде берілген әріптерді дұрыс оқып берші',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Text(
            'Ч, Ш, Щ',
            style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02)),
          ),
          SizedBox(height: 40),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

// Task 9: Convert to soft sounds
class Task9ConvertToSoft extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task9ConvertToSoft(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task9ConvertToSoft> createState() => _Task9ConvertToSoftState();
}

class _Task9ConvertToSoftState extends State<Task9ConvertToSoft> {
  final List<String> options = ['К, Д', 'Ғ, Д', 'Г, Р'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Ғ, Д';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Қ және Т дыбыстарын ұяң дыбысқа ауыстыршы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              'Қ → ?    Т → ?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: backgroundColor == Colors.white
                          ? Colors.black
                          : Colors.white,
                      fixedSize: const Size(250, 56),
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
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Task 10: Find sonant starting words
class Task10FindSonantWords extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  const Task10FindSonantWords(
      {super.key, required this.onCorrect, required this.onIncorrect});

  @override
  State<Task10FindSonantWords> createState() => _Task10FindSonantWordsState();
}

class _Task10FindSonantWordsState extends State<Task10FindSonantWords> {
  final List<String> options = ['лақ, нан', 'темір, қала', 'ғарыш, зымыран'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'лақ, нан';
    });

    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
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
            'Тек үнді дыбыстан басталған сөзді тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    fixedSize: Size(double.infinity, 56),
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
