import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      child: ElevatedButton(
                        onPressed: widget.onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: widget.isCorrect
                              ? const Color(0xFF58CC02)
                              : const Color(0xFFFF4B4B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          minimumSize: const Size(double.infinity, 60.0),
                        ),
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

class SandarySarayiScreen extends StatefulWidget {
  @override
  _SandarySarayiScreenState createState() => _SandarySarayiScreenState();
}

class _SandarySarayiScreenState extends State<SandarySarayiScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController2 = TextEditingController();

  // Task-specific variables
  String? selectedAnswer;
  Map<String, String> matchingPairs = {};
  bool _showAnswerNotification = false;
  bool? _lastIsCorrect;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _animationController.forward();
    _initializeCurrentTask();
  }

  void _initializeCurrentTask() {
    setState(() {
      selectedAnswer = null;
      matchingPairs.clear();
      _textController1.clear();
      _textController2.clear();
    });
  }

  void _checkAnswer() {
    bool isCorrect = false;

    switch (currentTask) {
      case 1:
        isCorrect = selectedAnswer == 'Төртінші';
        break;
      case 2:
        isCorrect = _textController1.text.isNotEmpty &&
            _textController2.text.isNotEmpty;
        break;
      case 3:
        isCorrect = _textController1.text.trim() == '6' ||
            _textController1.text.trim().toLowerCase() == 'алты';
        break;
      case 4:
        isCorrect = selectedAnswer == '12 ай';
        break;
      case 5:
        isCorrect = selectedAnswer == 'бесінші үй';
        break;
      case 6:
        isCorrect = true; // Auto-complete for speech task
        break;
      case 7:
        isCorrect = _textController1.text.trim().toLowerCase() == 'сегіз';
        break;
      case 8:
        isCorrect = selectedAnswer == 'Бірінші';
        break;
      case 9:
        isCorrect = matchingPairs['1'] == 'бірінші' &&
            matchingPairs['3'] == 'үшінші' &&
            matchingPairs['7'] == 'жетінші';
        break;
      case 10:
        isCorrect = selectedAnswer == 'екінші';
        break;
    }

    if (isCorrect) {
      setState(() {
        score += 10;
      });
      _showCorrectFeedback();

      Timer(const Duration(seconds: 2), () {
        setState(() {
          _showAnswerNotification = false;
        });
        _nextTask();
      });
    } else {
      _showIncorrectFeedback();

      Timer(const Duration(seconds: 2), () {
        setState(() {
          _showAnswerNotification = false;
        });
      });
    }
  }

  void _showCorrectFeedback() {
    _playFeedbackSound(true);
    setState(() {
      _lastIsCorrect = true;
      _showAnswerNotification = true;
    });
  }

  void _showIncorrectFeedback() {
    _playFeedbackSound(false);
    setState(() {
      _lastIsCorrect = false;
      _showAnswerNotification = true;
    });
  }

  void _playFeedbackSound(bool correct) async {
    try {
      final AudioPlayer player = AudioPlayer();
      await player.play(
        AssetSource(correct ? 'audio/correct.mp3' : 'audio/incorrect.mp3'),
      );
    } catch (_) {}
  }

  void _nextTask() {
    if (currentTask < 10) {
      setState(() {
        currentTask++;
      });
      _initializeCurrentTask();
      _animationController.reset();
      _animationController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Құттықтаймыз!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 10),
              const Text(
                'Сіз барлық тапсырмаларды орындадыңыз!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Ұпай: $score/100',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58CC02),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Аяқтау',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _playAudio(String audioFile) async {
    try {
      await _audioPlayer.play(AssetSource('audio/$audioFile'));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF0F8FF),
          body: Column(
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
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: _buildCurrentTask(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_showAnswerNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: _lastIsCorrect ?? false,
              onContinue: () {
                setState(() {
                  _showAnswerNotification = false;
                });
              },
            ),
          ),
      ],
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Төмендегі сөйлемді оқып, қолданылған сан есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Мен төртінші сыныпта оқимын',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['Төрт', 'Төртінші', 'Отыз']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 250.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedAnswer = option;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        option,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Тексеру',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask2() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлемді оқып, бос орындарға сан есімді қойшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Мен ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _textController1,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(' сыныпта оқимын',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text('Әжемнің ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _textController2,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(' немересі бар', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _textController1.text.isNotEmpty &&
                    _textController2.text.isNotEmpty
                ? _checkAnswer
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask3() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Төмендегі суретке қарап, қанша себетке қанша алма жиналғанын тапшы',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.brown[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '🧺\n🍎🍎🍎\n🍎🍎🍎',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Себетте қанша алма бар?',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _textController1,
              decoration: const InputDecoration(
                hintText: 'Жауапты жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _textController1.text.isNotEmpty ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask4() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлемдегі орынға дұрыс жауапты қойшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Бір жылда _____ бар',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['12 ай', '10 ай', '4 ай']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? Colors.green[100]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedAnswer == option
                              ? Colors.green
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: selectedAnswer != null ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Аудионы тыңдап, арасынан сан есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => _playAudio('besinshi_uy_aidana_balqash.mp3'),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF58CC02),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ...['бесінші үй', 'Айдананың кітабы', 'Балқаш көлі']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? Colors.green[100]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedAnswer == option
                              ? Colors.green
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: selectedAnswer != null ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask6() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Суретке қарап, қанша күшік екенін санап, дауыстап айтшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              '🐶 🐶 🐶 🐶',
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Күшіктерді санап, дауыстап айтыңыз',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Санап бітірдім',
              style: TextStyle(color: Colors.white, fontSize: 18),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'С әріпінен басталатын санды жазшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'С әріпінен басталатын сан',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _textController1,
              decoration: const InputDecoration(
                hintText: 'Санды жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _textController1.text.isNotEmpty ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Төмендегі мәтінді оқып, реттік сан есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Мен жетіде тұрдым. Бірінші сабақта математика болды. Сөмкемде бес кітап бар.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['Жетіде', 'Бірінші', 'Бес']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? Colors.green[100]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedAnswer == option
                              ? Colors.green
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: selectedAnswer != null ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask9() {
    List<String> numbers = ['1', '3', '7'];
    List<String> words = ['бірінші', 'үшінші', 'жетінші'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сандардың жазбаша нұсқасын дұрыс тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: numbers
                      .map(
                        (number) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(number,
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: words
                      .map(
                        (word) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DragTarget<String>(
                            onAccept: (number) {
                              setState(() {
                                matchingPairs[number] = word;
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              String? matchedNumber = matchingPairs.entries
                                  .firstWhere((entry) => entry.value == word,
                                      orElse: () => const MapEntry('', ''))
                                  .key;

                              return Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: matchedNumber.isNotEmpty
                                      ? Colors.green[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    if (matchedNumber.isNotEmpty)
                                      Text('$matchedNumber - ',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    Text(word,
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: matchingPairs.length == 3 ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask10() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Төмендегі мәтінді оқып, реттік сан есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Бүгін мектепте екі спорттық жарыс болды. Біздің тобымызда – жеті бала. Біз екінші орын алдық.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['Екі', 'Жеті', 'екінші']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? Colors.green[100]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedAnswer == option
                              ? Colors.green
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: selectedAnswer != null ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Тексеру',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _textController1.dispose();
    _textController2.dispose();
    super.dispose();
  }
}
