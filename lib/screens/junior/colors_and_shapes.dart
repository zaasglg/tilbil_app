import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';
import '../../widgets/animated_button.dart';

class ColorsAndShapesScreen extends StatefulWidget {
  @override
  _ColorsAndShapesScreenState createState() => _ColorsAndShapesScreenState();
}

class _ColorsAndShapesScreenState extends State<ColorsAndShapesScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  bool showFeedback = false;
  bool? isCorrect;
  // Audio player for sound effects
  final AudioPlayer _audioPlayer = AudioPlayer();
  // progress animation removed; header now uses currentTask / 10.0 directly

  // Task 3 word completion state
  String task3Word = 'үш_ұр_ш';
  String task3UserInput = '';

  // Task 4 shadow matching state
  Map<String, String?> task4Matches = {
    'доп': null,
    'үй шатыр': null,
    'кітап': null,
  };
  List<String> task4Shadows = ['шеңбер', 'үшбұрыш', 'төртбұрыш'];
  Map<String, bool> task4Used = {};

  // Task 5 word building state
  List<String> task5Letters = ['с', 'қ', 'о', 'п', 'а'];
  List<String> task5UserWord = [];

  // Task 8 dictation state
  String task8UserInput = '';

  // Task 9 word building state
  List<String> task9Letters = ['ш', 'ш', 'р', 'ы', 'а'];
  List<String> task9UserWord = [];

  // Task 10 shape matching state
  List<Map<String, dynamic>> task10Shapes = [
    {'shape': 'square', 'color': Colors.red, 'matched': false, 'id': 1},
    {'shape': 'square', 'color': Colors.red, 'matched': false, 'id': 2},
    {'shape': 'circle', 'color': Colors.blue, 'matched': false, 'id': 3},
    {'shape': 'circle', 'color': Colors.blue, 'matched': false, 'id': 4},
    {'shape': 'triangle', 'color': Colors.yellow, 'matched': false, 'id': 5},
    {'shape': 'triangle', 'color': Colors.yellow, 'matched': false, 'id': 6},
  ];

  @override
  void initState() {
    super.initState();
    // header progress is calculated from currentTask; no controller needed

    // Initialize states
    task5Letters.shuffle();
    task9Letters.shuffle();
    task10Shapes.shuffle();
    for (String shadow in task4Shadows) {
      task4Used[shadow] = false;
    }
  }

  @override
  void dispose() {
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
        if (currentTask == 3) {
          task3UserInput = '';
        }
        if (currentTask == 4) {
          task4Matches = {
            'доп': null,
            'үй шатыр': null,
            'кітап': null,
          };
          task4Used = {};
          for (String shadow in task4Shadows) {
            task4Used[shadow] = false;
          }
        }
        if (currentTask == 5) {
          task5Letters.shuffle();
          task5UserWord.clear();
        }
        if (currentTask == 8) {
          task8UserInput = '';
        }
        if (currentTask == 9) {
          task9Letters.shuffle();
          task9UserWord.clear();
        }
        if (currentTask == 10) {
          task10Shapes.shuffle();
          for (var shape in task10Shapes) {
            shape['matched'] = false;
          }
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
      showFeedback = true;
    });

    bool isCorrect = false;
    switch (currentTask) {
      case 1:
        isCorrect = answer == 'жасыл жұлдыз';
        break;
      case 2:
        isCorrect = answer == 'көк шеңбер';
        break;
      case 6:
        isCorrect = answer == 'екі шеңбер';
        break;
      case 7:
        isCorrect = answer == 'дөңгелек';
        break;
    }

    if (isCorrect) {
      score += 10;
    }
    // store for notification overlay
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _playColorAudio(String color) async {
    await _audioPlayer.play(AssetSource('tasks/level1/color/$color.mp3'));
  }

  void _checkTask3() {
    bool isCorrect = task3UserInput.toLowerCase() == 'үшбұрыш';

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkTask4() {
    bool isCorrect = task4Matches['доп'] == 'шеңбер' &&
        task4Matches['үй шатыр'] == 'үшбұрыш' &&
        task4Matches['кітап'] == 'төртбұрыш';

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkWordBuilding(int taskNum) {
    String userWord = taskNum == 5
        ? task5UserWord.join('').toLowerCase()
        : task9UserWord.join('').toLowerCase();

    String correctWord = taskNum == 5 ? 'сопақ' : 'шаршы';
    bool isCorrect = userWord == correctWord;

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkTask8() {
    bool isCorrect = task8UserInput.toLowerCase() == 'сары жұлдыз';

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _checkTask10() {
    int matchedPairs = 0;
    Map<String, List<int>> groups = {};

    for (var shape in task10Shapes) {
      if (shape['matched']) {
        String key = '${shape['shape']}_${shape['color'].toString()}';
        if (groups[key] == null) groups[key] = [];
        groups[key]!.add(shape['id']);
      }
    }

    for (var group in groups.values) {
      if (group.length == 2) matchedPairs++;
    }

    bool isCorrect = matchedPairs == 3;

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
    });
    this.isCorrect = isCorrect;

    // Play sound effect
    _playSound(isCorrect);
  }

  void _onNotificationContinue() {
    setState(() {
      showFeedback = false;
      isAnswered = false;
      selectedAnswer = null;
      isCorrect = null;
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
              '10-нан $score/100 ұпай жинадың!',
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
      // replaced AppBar with custom header (matches SoundHunters header style)
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
                      color: Colors.white.withOpacity(0.2),
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
            'Жасыл жұлдызды тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildShapeOption(
                    'қызыл төртбұрыш', Colors.red, 'square', 'қызыл төртбұрыш'),
                _buildShapeOption(
                    'көк шеңбер', Colors.blue, 'circle', 'көк шеңбер'),
                _buildShapeOption(
                    'сары үшбұрыш', Colors.yellow, 'triangle', 'сары үшбұрыш'),
                _buildShapeOption(
                    'жасыл жұлдыз', Colors.green, 'star', 'жасыл жұлдыз'),
              ],
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
            'Суреттегі пішін мен оның түсін атап берші',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
              ],
            ),
          ),
          SizedBox(height: 30),
          CupertinoButton(
            color: Color(0xFF58CC02),
            borderRadius: BorderRadius.circular(15),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('🎤 Микрофонға "көк шеңбер" деп айтыңыз')),
              );
              // Simulate speech recognition
              Timer(Duration(seconds: 2), () {
                _checkAnswer('көк шеңбер');
              });
            },
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
            'Әріптерді дұрыс қойып, сөзді толықтыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Text(
            'үш_ұр_ш',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Түсіп қалған әріптер: б, ы',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  task3UserInput = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Толық сөзді жазыңыз',
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          if (task3UserInput.isNotEmpty)
            CupertinoButton(
              color: Color(0xFF58CC02),
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.all(15),
              onPressed: isAnswered ? null : _checkTask3,
              child: Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Заттардың көлеңкесін тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                // Left side - objects
                Expanded(
                  child: Column(
                    children: [
                      _buildObjectForShadow('доп', '⚽'),
                      _buildObjectForShadow('үй шатыр', '🏠'),
                      _buildObjectForShadow('кітап', '📚'),
                    ],
                  ),
                ),
                // Right side - shadows
                Expanded(
                  child: Column(
                    children: task4Shadows
                        .where((shadow) => !task4Used[shadow]!)
                        .map(
                          (shadow) => Draggable<String>(
                            data: shadow,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _buildShadowShape(shadow),
                              ),
                            ),
                            feedback: Material(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: _buildShadowShape(shadow),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (task4Matches.values.every((v) => v != null))
            CupertinoButton(
              color: Color(0xFF58CC02),
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.all(15),
              onPressed: isAnswered ? null : _checkTask4,
              child: Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Берілген әріптерден сөз құрастыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text('Мақсат: сопақ',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 30),
          // User's word
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task5UserWord
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
          // Available letters (full-width blue rows with centered white pill)
          Column(
            children: task5Letters.map((letter) {
              bool used = task5UserWord.contains(letter);
              return GestureDetector(
                onTap: used
                    ? null
                    : () {
                        setState(() {
                          task5UserWord.add(letter);
                          if (task5UserWord.length == 5) {
                            Timer(Duration(milliseconds: 500), () {
                              _checkWordBuilding(5);
                            });
                          }
                        });
                      },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: used ? Colors.grey[300] : Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (task5UserWord.isNotEmpty)
            CupertinoButton(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
              padding: EdgeInsets.all(10),
              onPressed: () {
                setState(() {
                  task5UserWord.clear();
                });
              },
              child: Text('Тазалау', style: TextStyle(color: Colors.white)),
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
            'Суретте қанша сары шеңбер бар екенін айтшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              _buildCircle(Colors.red),
              _buildCircle(Colors.blue),
              _buildCircle(Colors.yellow),
              _buildCircle(Colors.green),
              _buildCircle(Colors.black),
              _buildCircle(Colors.yellow),
            ],
          ),
          SizedBox(height: 40),
          ...['үш шеңбер', 'бір шеңбер', 'екі шеңбер']
              .map(
                (option) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: isAnswered ? null : () => _checkAnswer(option),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? (option == 'екі шеңбер'
                                ? Colors.green
                                : Colors.red)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedAnswer == option
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildTask7() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Мәтінді тыңдап, сол доптың пішінін тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          AnimatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '🔊 Мақсатқа әкесі әдемі доп әкеліп берді. Ол доп-домалақ, лақтырсаң дөңгелей жөнеледі.'),
                  duration: Duration(seconds: 4),
                ),
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
                  Text('Мәтінді тыңда',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          ...['төртбұрыш', 'дөңгелек', 'үшбұрыш']
              .map(
                (option) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: AnimatedButton(
                    onPressed: isAnswered ? () {} : () => _checkAnswer(option),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedAnswer == option
                            ? (option == 'дөңгелек' ? Colors.green : Colors.red)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedAnswer == option
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildTask8() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Дауысты тыңдап, сөзді қайталап жазшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          AnimatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🔊 "сары жұлдыз"')),
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
                  Text('Тыңда',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  task8UserInput = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Естіген сөзді жазыңыз',
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          if (task8UserInput.isNotEmpty)
            CupertinoButton(
              color: Color(0xFF58CC02),
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.all(15),
              onPressed: isAnswered ? null : _checkTask8,
              child: Text('Тексеру',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
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
            'Әріптерден сөз құрастыршы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text('Мақсат: шаршы',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 30),
          // User's word
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task9UserWord
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
          // Available letters (full-width blue rows with centered white pill)
          Column(
            children: task9Letters.map((letter) {
              bool used = task9UserWord.contains(letter);
              return GestureDetector(
                onTap: used
                    ? null
                    : () {
                        setState(() {
                          task9UserWord.add(letter);
                          if (task9UserWord.length == 5) {
                            Timer(Duration(milliseconds: 500), () {
                              _checkWordBuilding(9);
                            });
                          }
                        });
                      },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: used ? Colors.grey[300] : Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (task9UserWord.isNotEmpty)
            CupertinoButton(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
              padding: EdgeInsets.all(10),
              onPressed: () {
                setState(() {
                  task9UserWord.clear();
                });
              },
              child: Text('Тазалау', style: TextStyle(color: Colors.white)),
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
            'Бірдей пішіндерді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: task10Shapes
                  .map(
                    (shape) => GestureDetector(
                      onTap: () {
                        setState(() {
                          shape['matched'] = !shape['matched'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: shape['matched']
                              ? Colors.green[100]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: shape['matched']
                                ? Colors.green
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: _buildShapeWidget(
                              shape['shape'], shape['color'], 60),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          CupertinoButton(
            color: Color(0xFF58CC02),
            borderRadius: BorderRadius.circular(10),
            padding: EdgeInsets.all(15),
            onPressed: isAnswered ? null : _checkTask10,
            child: Text('Тексеру',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeOption(
      String label, Color color, String shape, String value) {
    return GestureDetector(
      onTap: isAnswered
          ? null
          : () {
              // Play color audio when shape is tapped
              if (color == Colors.red) {
                _playColorAudio('red');
              } else if (color == Colors.blue) {
                _playColorAudio('blue');
              } else if (color == Colors.yellow) {
                _playColorAudio('yellow');
              } else if (color == Colors.green) {
                _playColorAudio('green');
              }
              _checkAnswer(value);
            },
      child: Container(
        decoration: BoxDecoration(
          color: selectedAnswer == value
              ? (value == 'жасыл жұлдыз' ? Colors.green : Colors.red)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShapeWidget(shape, color, 60),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selectedAnswer == value ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeWidget(String shape, Color color, double size) {
    switch (shape) {
      case 'circle':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      case 'square':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case 'triangle':
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(color),
        );
      case 'star':
        return Icon(Icons.star, color: color, size: size);
      default:
        return Container();
    }
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
        ],
      ),
    );
  }

  Widget _buildObjectForShadow(String name, String emoji) {
    return DragTarget<String>(
      onAccept: (shadow) {
        setState(() {
          task4Matches[name] = shadow;
          task4Used[shadow] = true;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: task4Matches[name] != null
                ? Colors.green[100]
                : Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: candidateData.isNotEmpty ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: TextStyle(fontSize: 40)),
              Text(name, style: TextStyle(fontSize: 12)),
              if (task4Matches[name] != null)
                Text('→ ${task4Matches[name]}',
                    style: TextStyle(fontSize: 10, color: Colors.green[700])),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShadowShape(String shadow) {
    switch (shadow) {
      case 'шеңбер':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      case 'үшбұрыш':
        return CustomPaint(
          size: Size(40, 40),
          painter: TrianglePainter(Colors.grey[400]!),
        );
      case 'төртбұрыш':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      default:
        return Container();
    }
  }
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
                            widget.isCorrect ? 'Өте жақсы!' : 'Қате!',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
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
                            style: GoogleFonts.roboto(
                              color: widget.isCorrect
                                  ? const Color(0xFF58CC02)
                                  : const Color(0xFFFF4B4B),
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

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
