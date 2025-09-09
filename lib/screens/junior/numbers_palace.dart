import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';

// Notification shown after answer (same style as in sound_hunters.dart)
class AnswerNotification extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onContinue;

  const AnswerNotification(
      {super.key, required this.isCorrect, required this.onContinue});

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
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
        margin: const EdgeInsets.symmetric(
            horizontal: 8), // Add margin to prevent edge clipping
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
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
                        const SizedBox(width: 100), // Space for Lottie
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
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
              right: 10,
              top: -40, // Half of height 80
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Lottie.asset(
                    widget.isCorrect
                        ? 'assets/lottie/correct.json'
                        : 'assets/lottie/incorrect.json',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
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

class NumbersPalaceScreen extends StatefulWidget {
  @override
  _NumbersPalaceScreenState createState() => _NumbersPalaceScreenState();
}

class _NumbersPalaceScreenState extends State<NumbersPalaceScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  bool showFeedback = false;
  bool? lastAnswerCorrect;
  late AnimationController _progressController;

  // Audio player for sound effects
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Task 1 number completion state
  String task1UserInput = '';

  // Task 4 number ordering state
  List<int> task4Numbers = [5, 3, 1, 7];
  List<int> task4UserOrder = [];

  // Task 6 counting state
  Map<String, String> task6Counts = {
    'гүл': '',
    'шар': '',
    'сағат': '',
  };

  // Task 7 word building state
  List<String> task7Letters = ['ғ', 'о', 'з', 'ы', 'т'];
  List<String> task7UserWord = [];

  // Task 8 word building state
  List<String> task8Letters = ['с', 'з', 'е', 'г', 'і'];
  List<String> task8UserWord = [];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _progressController.forward();

    // Initialize states
    task4Numbers.shuffle();
    task7Letters.shuffle();
    task8Letters.shuffle();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _nextTask() {
    if (currentTask < 10) {
      setState(() {
        currentTask++;
        isAnswered = false;
        selectedAnswer = null;
        showFeedback = false;

        // Reset task-specific states
        if (currentTask == 1) {
          task1UserInput = '';
        }
        if (currentTask == 4) {
          task4Numbers.shuffle();
          task4UserOrder.clear();
        }
        if (currentTask == 6) {
          task6Counts = {
            'гүл': '',
            'шар': '',
            'сағат': '',
          };
        }
        if (currentTask == 7) {
          task7Letters.shuffle();
          task7UserWord.clear();
        }
        if (currentTask == 8) {
          task8Letters.shuffle();
          task8UserWord.clear();
        }
      });

      // progress header updates automatically from currentTask
    } else {
      _showCompletionDialog();
    }
  }

  void _checkAnswer(String answer) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      // determine correctness and show notification overlay
      bool isCorrect = false;
      switch (currentTask) {
        case 2:
          isCorrect = answer == '5 алма';
          break;
        case 3:
          isCorrect = answer == '15';
          break;
        case 5:
          isCorrect = answer == '3';
          break;
        case 9:
          isCorrect = answer == 'бес шар';
          break;
        case 10:
          isCorrect = answer == 'бес, жеті, сегіз';
          break;
      }
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
      if (isCorrect) score += 10;

      // Play sound effect
      _playSound(isCorrect);
    });
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkTask1() {
    bool isCorrect = task1UserInput == '4';
    if (isCorrect) score += 10;
    setState(() {
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
    });

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkTask4() {
    bool isCorrect = task4UserOrder.toString() == '[1, 3, 5, 7]';
    if (isCorrect) score += 10;
    setState(() {
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
    });

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkTask6() {
    bool isCorrect = task6Counts['гүл'] == '3' &&
        task6Counts['шар'] == '2' &&
        task6Counts['сағат'] == '1';
    if (isCorrect) score += 10;
    setState(() {
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
    });

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkWordBuilding(int taskNum) {
    String userWord = taskNum == 7
        ? task7UserWord.join('').toLowerCase()
        : task8UserWord.join('').toLowerCase();

    String correctWord = taskNum == 7 ? 'тоғыз' : 'сегіз';
    bool isCorrect = userWord == correctWord;

    if (isCorrect) score += 10;
    setState(() {
      isAnswered = true;
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
    });

    // Play sound effect
    _playSound(isCorrect);
  }

  void _onNotificationContinue() {
    // hide notification and move to next task
    setState(() {
      showFeedback = false;
      lastAnswerCorrect = null;
      isAnswered = false;
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
              'Жинаған ұпайыңыз: $score/100',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
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
                      widthFactor: currentTask / 10.0,
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
            child: Stack(
              children: [
                _buildCurrentTask(),
                if (showFeedback)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnswerNotification(
                      isCorrect: lastAnswerCorrect ?? false,
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Сандарды толықтыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildNumberBox('1'),
              _buildNumberBox('2'),
              _buildNumberBox('3'),
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '?',
                  ),
                  onChanged: (value) {
                    setState(() {
                      task1UserInput = value;
                    });
                  },
                ),
              ),
              _buildNumberBox('5'),
              _buildNumberBox('6'),
            ],
          ),
          SizedBox(height: 30),
          if (task1UserInput.isNotEmpty)
            GestureDetector(
              onTap: isAnswered ? null : _checkTask1,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask2() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Алма көп пе әлде алмұрт көп пе?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Алма',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Wrap(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('🍎', style: TextStyle(fontSize: 30)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: isAnswered ? null : () => _checkAnswer('5 алма'),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedAnswer == '5 алма'
                            ? Colors.green
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '5 алма',
                        style: TextStyle(
                          color: selectedAnswer == '5 алма'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Алмұрт',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Wrap(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('🍐', style: TextStyle(fontSize: 30)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: isAnswered ? null : () => _checkAnswer('3 алмұрт'),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedAnswer == '3 алмұрт'
                            ? Colors.red
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '3 алмұрт',
                        style: TextStyle(
                          color: selectedAnswer == '3 алмұрт'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask3() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Артық санды тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: ['2', '4', '6', '8', '15']
                .map(
                  (number) => GestureDetector(
                    onTap: isAnswered ? null : () => _checkAnswer(number),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: selectedAnswer == number
                            ? (number == '15' ? Colors.green : Colors.red)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: selectedAnswer == number
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
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

  Widget _buildTask4() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Сандарды өсу ретімен қойшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          // User's ordered numbers
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task4UserOrder
                  .map(
                    (number) => Container(
                      margin: EdgeInsets.all(5),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Center(
                        child: Text('$number',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 30),
          // Available numbers
          Wrap(
            spacing: 15,
            children: task4Numbers
                .where((num) => !task4UserOrder.contains(num))
                .map(
                  (number) => GestureDetector(
                    onTap: () {
                      setState(() {
                        task4UserOrder.add(number);
                        if (task4UserOrder.length == 4) {
                          Timer(Duration(milliseconds: 500), () {
                            _checkTask4();
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Text('$number',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20),
          if (task4UserOrder.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  task4UserOrder.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Тазалау', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask5() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Қанша дыбыс естідің?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🔔 Дыбыс: дың-дың-дың (3 рет)')),
              );
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF58CC02),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volume_up, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text('Дыбысты тыңда',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['3', '1', '4']
                .map(
                  (option) => GestureDetector(
                    onTap: isAnswered ? null : () => _checkAnswer(option),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? (option == '3' ? Colors.green : Colors.red)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: selectedAnswer == option
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Суретте қанша зат көргеніңді жазып қойшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                _buildCountingItem('гүл', '🌸', 3),
                _buildCountingItem('шар', '🎈', 2),
                _buildCountingItem('сағат', '⏰', 1),
              ],
            ),
          ),
          if (task6Counts.values.every((v) => v.isNotEmpty))
            GestureDetector(
              onTap: isAnswered ? null : _checkTask6,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Тексеру',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask7() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Әріптерден сөз құрастыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text('Мақсат: тоғыз',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 30),
          // User's word
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task7UserWord
                  .map(
                    (letter) => Container(
                      margin: EdgeInsets.all(2),
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Center(
                        child: Text(letter,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 30),
          // Available letters
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: task7Letters
                .map(
                  (letter) => GestureDetector(
                    onTap: task7UserWord.contains(letter)
                        ? null
                        : () {
                            setState(() {
                              task7UserWord.add(letter);
                              if (task7UserWord.length == 5) {
                                Timer(Duration(milliseconds: 500), () {
                                  _checkWordBuilding(7);
                                });
                              }
                            });
                          },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: task7UserWord.contains(letter)
                            ? Colors.grey[300]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: task7UserWord.contains(letter)
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20),
          if (task7UserWord.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  task7UserWord.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Тазалау', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask8() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Әріптерден сөз құрастыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text('Мақсат: сегіз',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 30),
          // User's word
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task8UserWord
                  .map(
                    (letter) => Container(
                      margin: EdgeInsets.all(2),
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Center(
                        child: Text(letter,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 30),
          // Available letters
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: task8Letters
                .map(
                  (letter) => GestureDetector(
                    onTap: task8UserWord.contains(letter)
                        ? null
                        : () {
                            setState(() {
                              task8UserWord.add(letter);
                              if (task8UserWord.length == 5) {
                                Timer(Duration(milliseconds: 500), () {
                                  _checkWordBuilding(8);
                                });
                              }
                            });
                          },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: task8UserWord.contains(letter)
                            ? Colors.grey[300]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: task8UserWord.contains(letter)
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20),
          if (task8UserWord.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  task8UserWord.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Тазалау', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTask9() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Бес шар салынған қорапты таңдашы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Column(
            children: [
              _buildBoxOption('үш шар', 3, 'үш шар'),
              SizedBox(height: 20),
              _buildBoxOption('төрт шар', 4, 'төрт шар'),
              SizedBox(height: 20),
              _buildBoxOption('бес шар', 5, 'бес шар'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTask10() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Суреттегі сандарды атап берші',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberDisplay('5'),
              _buildNumberDisplay('7'),
              _buildNumberDisplay('8'),
            ],
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('🎤 Микрофонға "бес, жеті, сегіз" деп айтыңыз')),
              );
              // Simulate speech recognition
              Timer(Duration(seconds: 2), () {
                _checkAnswer('бес, жеті, сегіз');
              });
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF58CC02),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text('Айту',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBox(String number) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCountingItem(String name, String emoji, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Wrap(
                  children: List.generate(
                    count,
                    (index) => Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(emoji, style: TextStyle(fontSize: 25)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '?',
                ),
                onChanged: (value) {
                  setState(() {
                    task6Counts[name] = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxOption(String label, int ballCount, String value) {
    return GestureDetector(
      onTap: isAnswered ? null : () => _checkAnswer(value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selectedAnswer == value
              ? (value == 'бес шар' ? Colors.green : Colors.red)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Wrap(
                  children: List.generate(
                    ballCount,
                    (index) => Text('⚽', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selectedAnswer == value ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberDisplay(String number) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[300]!, width: 2),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800]),
        ),
      ),
    );
  }
}
