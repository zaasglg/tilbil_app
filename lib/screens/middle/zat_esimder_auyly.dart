import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
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
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.isCorrect ? 'Дұрыс!' : 'Дұрыс емес!',
                        style: GoogleFonts.nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isCorrect
                            ? 'Жақсы жұмыс!'
                            : 'Қайтадан байқап көріңіз!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: widget.onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: widget.isCorrect
                                ? const Color(0xFF58CC02)
                                : const Color(0xFFFF4B4B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Жалғастыру',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
              top: -20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Lottie.asset(
                        widget.isCorrect
                            ? 'assets/lottie/correct.json'
                            : 'assets/lottie/incorrect.json',
                        repeat: false,
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
}

class ZatEsimderAuylyScreen extends StatefulWidget {
  @override
  _ZatEsimderAuylyScreenState createState() => _ZatEsimderAuylyScreenState();
}

class _ZatEsimderAuylyScreenState extends State<ZatEsimderAuylyScreen>
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
  String highlightedWord = '';
  bool _showAnswerNotification = false;
  bool _lastIsCorrect = false;

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
      highlightedWord = '';
      _textController1.clear();
      _textController2.clear();
    });
  }

  void _checkAnswer() {
    bool isCorrect = false;

    switch (currentTask) {
      case 1:
        isCorrect = selectedAnswer == 'Данияр';
        break;
      case 2:
        isCorrect = _textController1.text.trim().toLowerCase() == 'дос';
        break;
      case 3:
        isCorrect = highlightedWord == 'балалар';
        break;
      case 4:
        isCorrect = _textController1.text.trim().toLowerCase() == 'балалар' &&
            _textController2.text.trim().toLowerCase() == 'кітаптар';
        break;
      case 5:
        isCorrect = _textController1.text.trim().toLowerCase() == 'кітаптар';
        break;
      case 6:
        isCorrect = _textController1.text.trim().toLowerCase() == 'гүл' &&
            _textController2.text.trim().toLowerCase() == 'қоян';
        break;
      case 7:
        isCorrect = selectedAnswer == 'қыздар';
        break;
      case 8:
        isCorrect = highlightedWord == 'көзілдіріктер';
        break;
      case 9:
        isCorrect = selectedAnswer == 'алма';
        break;
      case 10:
        isCorrect = selectedAnswer == 'көйлек';
        break;
    }

    // Play sound and show notification
    if (isCorrect) {
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      setState(() {
        score += 10;
      });
      _confettiController.play();
    } else {
      _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }

    setState(() {
      _lastIsCorrect = isCorrect;
      _showAnswerNotification = true;
    });
  }

  void _hideNotificationAndAdvance() {
    setState(() {
      _showAnswerNotification = false;
    });

    // Only advance if the answer was correct
    if (_lastIsCorrect) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (currentTask < 10) {
          setState(() {
            currentTask++;
            selectedAnswer = null;
            highlightedWord = '';
            _textController1.clear();
            _textController2.clear();
          });
        } else {
          // All tasks completed, navigate back or show completion screen
          Navigator.pop(context);
        }
      });
    }
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
          if (_showAnswerNotification)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnswerNotification(
                isCorrect: _lastIsCorrect,
                onContinue: _hideNotificationAndAdvance,
              ),
            ),
        ],
      ),
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
            'Берілген сөздердің ішінен зат есімді тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...['Данияр', 'барады', 'әдемі', 'төртеу']
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
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Аудионы тыңдап, сөздердің арасынан жекеше зат есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: () => _playAudio('baru_kel_dos_ulken.mp3'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 30, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Аудионы тыңдау',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ],
              ),
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
                hintText: 'Жекеше зат есімді жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _textController1.text.isNotEmpty ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask3() {
    List<String> words = ['гүл', 'дәптер', 'балалар', 'орындық'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Артық сөзді тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: words
                  .map(
                    (word) => GestureDetector(
                      onTap: () {
                        setState(() {
                          highlightedWord = word;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: highlightedWord == word
                              ? Colors.red[100]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: highlightedWord == word
                                ? Colors.red
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          word,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: highlightedWord.isNotEmpty ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Жеке зат есімді көпшеге айналдыршы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('бала',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _textController1,
                        decoration: const InputDecoration(
                          hintText: 'көпше түрі',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    const Text('кітап',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _textController2,
                        decoration: const InputDecoration(
                          hintText: 'көпше түрі',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _textController1.text.isNotEmpty &&
                      _textController2.text.isNotEmpty
                  ? _checkAnswer
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Бос орынға сөздің көпше не жекеше түрін қой',
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
              'Менің сөмкемде үш _____ бар',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'кітап',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                hintText: 'Дұрыс түрін жазыңыз',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _textController1.text.isNotEmpty ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Көпше түрде берілген сөзді жекешеге айналдыр',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('гүлдер',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _textController1,
                        decoration: const InputDecoration(
                          hintText: 'жекеше түрі',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    const Text('қояндар',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _textController2,
                        decoration: const InputDecoration(
                          hintText: 'жекеше түрі',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _textController1.text.isNotEmpty &&
                      _textController2.text.isNotEmpty
                  ? _checkAnswer
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Төменде берілген сөздердің арасынан көпше зат есімді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...['қыздар', 'самаурын', 'үңгір']
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
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask8() {
    List<String> words = ['қарындаш', 'орындық', 'көзілдіріктер', 'қалпақ'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Артық сөзді тапшы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: words
                  .map(
                    (word) => GestureDetector(
                      onTap: () {
                        setState(() {
                          highlightedWord = word;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: highlightedWord == word
                              ? Colors.red[100]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: highlightedWord == word
                                ? Colors.red
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          word,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: highlightedWord.isNotEmpty ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask9() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Сөйлемде түсіп қалған бос орынға дұрыс сөз қойшы',
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
              'Айдос бақшадан бірнеше _______ терді',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['алма', 'алмалар', 'алмаға']
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
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Сөйлемде түсіп қалған бос орынға дұрыс сөз қойшы',
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
              'Менің анам үйге әдемі _____ әкелді',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['көйлек', 'пешті', 'жұлдыз']
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
          SizedBox(
            width: 250.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
