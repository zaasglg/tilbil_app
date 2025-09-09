import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/animated_button.dart';
import 'sound_hunters.dart';
import 'package:chiclet/chiclet.dart';
import 'package:til_bil_app/services/sound_service.dart';

class HumanSecretScreen extends StatefulWidget {
  @override
  _HumanSecretScreenState createState() => _HumanSecretScreenState();
}

class _HumanSecretScreenState extends State<HumanSecretScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  bool showFeedback = false;
  bool? isCorrect;
  bool _notificationProceeding = false;
  bool _micPressed = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Timer? _autoProceedTimer;

  // Audio player for sound effects
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Task 3 word completion state
  Map<String, String> task3Words = {
    'құл_қ': 'а',
    '_уыз': 'а',
    '_яқ': 'а',
  };
  Map<String, String> task3UserAnswers = {};

  // Task 6 word building state
  List<String> task6Letters = ['р', 'н', 'қ', 'ы', 'а', 'т'];
  List<String> task6UserWord = [];

  // Task 7 word building state
  List<String> task7Letters = ['т', 'н', 'б', 'а', 'а'];
  List<String> task7UserWord = [];

  // Task 9 sentence building state
  List<String> task9Words = ['тарады', 'шашын', 'Дана', 'тарақпен'];
  List<String> task9UserSentence = [];

  // Task 10 matching state
  Map<String, String?> task10Matches = {
    'көз': null,
    'ауыз': null,
    'құлақ': null,
  };
  List<String> task10Items = ['алыстағы зат', 'лимон', 'қатты дыбыс'];
  Map<String, bool> task10Used = {};

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: currentTask / 10.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward();

    // Initialize states
    task6Letters.shuffle();
    task7Letters.shuffle();
    task9Words.shuffle();
    for (String item in task10Items) {
      task10Used[item] = false;
    }
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
        if (currentTask == 3) {
          task3UserAnswers.clear();
        }
        if (currentTask == 6) {
          task6Letters.shuffle();
          task6UserWord.clear();
        }
        if (currentTask == 7) {
          task7Letters.shuffle();
          task7UserWord.clear();
        }
        if (currentTask == 9) {
          task9Words.shuffle();
          task9UserSentence.clear();
        }
        if (currentTask == 10) {
          task10Matches = {
            'көз': null,
            'құлақ': null,
          };
          task10Used = {};
          for (String item in task10Items) {
            task10Used[item] = false;
          }
        }
      });

      _progressAnimation = Tween<double>(
        begin: (currentTask - 1) / 10.0,
        end: currentTask / 10.0,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
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

    bool result = false;
    switch (currentTask) {
      case 1:
        result = answer == 'мұрын';
        break;
      case 2:
        result = answer == 'көз';
        break;
      case 4:
        result = answer == 'ауыз';
        break;
      case 5:
        result = answer == 'ашу';
        break;
      case 8:
        result = answer == 'аяқ';
        break;
    }

    // store result for notification
    setState(() {
      isCorrect = result;
      if (result) score += 10;
    });

    // Play sound effect
    _playSound(result);

    // schedule automatic proceed, but also allow user to press Continue
    _autoProceedTimer =
        Timer(const Duration(seconds: 2), _proceedAfterFeedback);
  }

  void _checkTask3() {
    if (isAnswered) return;
    bool result = task3UserAnswers['құл_қ'] == 'а' &&
        task3UserAnswers['_уыз'] == 'а' &&
        task3UserAnswers['_яқ'] == 'а';

    if (result) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
      isCorrect = result;
    });

    // Play sound effect
    _playSound(result);

    _autoProceedTimer =
        Timer(const Duration(seconds: 2), _proceedAfterFeedback);
  }

  void _checkWordBuilding(int taskNum) {
    String userWord = taskNum == 6
        ? task6UserWord.join('').toLowerCase()
        : task7UserWord.join('').toLowerCase();

    String correctWord = taskNum == 6 ? 'тырнақ' : 'табан';
    bool isCorrect = userWord == correctWord;

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
      this.isCorrect = isCorrect;
    });

    // Play sound effect
    _playSound(isCorrect);

    _autoProceedTimer =
        Timer(const Duration(seconds: 2), _proceedAfterFeedback);
  }

  void _checkTask9() {
    String userSentence = task9UserSentence.join(' ');
    bool isCorrect = userSentence == 'Дана тарақпен шашын тарады';

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
      this.isCorrect = isCorrect;
    });

    // Play sound effect
    _playSound(isCorrect);

    _autoProceedTimer =
        Timer(const Duration(seconds: 2), _proceedAfterFeedback);
  }

  void _checkTask10() {
    bool isCorrect = task10Matches['көз'] == 'алыстағы зат' &&
        task10Matches['ауыз'] == 'лимон' &&
        task10Matches['құлақ'] == 'қатты дыбыс';

    if (isCorrect) {
      score += 10;
    }

    setState(() {
      isAnswered = true;
      showFeedback = true;
      this.isCorrect = isCorrect;
    });

    // Play sound effect
    _playSound(isCorrect);

    Timer(const Duration(seconds: 2), () {
      _proceedAfterFeedback();
    });
  }

  void _proceedAfterFeedback() {
    // cancel any scheduled automatic proceed to avoid double progression
    _autoProceedTimer?.cancel();
    _autoProceedTimer = null;
    if (_notificationProceeding) return;
    _notificationProceeding = true;
    // small delay to allow animation to finish if needed
    Future.delayed(const Duration(milliseconds: 100), () {
      _nextTask();
      _notificationProceeding = false;
      setState(() {
        showFeedback = false;
        isAnswered = false;
        isCorrect = null;
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Табыс!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Сіз барлық тапсырмаларды орындадыңыз!'),
              const SizedBox(height: 10),
              Text('Жинаған ұпайыңыз: $score/100'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Жақсы'),
            ),
          ],
        );
      },
    );
  }

  void _playSound(bool correct) async {
    if (correct) {
      await _audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
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
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildCurrentTask(),
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Мұрынның суретін тапшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildBodyPartOption('көз', '👁️', 'көз'),
                    _buildBodyPartOption('қол', '✋', 'қол'),
                    _buildBodyPartOption('мұрын', '👃', 'мұрын'),
                    _buildBodyPartOption('аяқ', '🦶', 'аяқ'),
                    _buildBodyPartOption('ауыз', '👄', 'ауыз'),
                    _buildBodyPartOption('құлақ', '👂', 'құлақ'),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask2() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Көздің суретін тапшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildBodyPartOption('көз', '👁️', 'көз'),
                    _buildBodyPartOption('құлақ', '👂', 'құлақ'),
                    _buildBodyPartOption('мұрын', '👃', 'мұрын'),
                    _buildBodyPartOption('ауыз', '👄', 'ауыз'),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask3() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Берілген сөзді толықтыршы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  children: task3Words.keys
                      .map(
                        (word) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...word
                                  .split('')
                                  .map(
                                    (char) => Container(
                                      margin: const EdgeInsets.all(2),
                                      width: 40,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: char == '_'
                                            ? Colors.white
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey[400]!),
                                      ),
                                      child: Center(
                                        child: char == '_'
                                            ? DropdownButton<String>(
                                                value: task3UserAnswers[word],
                                                hint: const Text('?'),
                                                underline: Container(),
                                                items: ['а', 'ә', 'о', 'ө']
                                                    .map(
                                                      (letter) =>
                                                          DropdownMenuItem(
                                                        value: letter,
                                                        child: Text(letter,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18)),
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    task3UserAnswers[word] =
                                                        value!;
                                                  });
                                                },
                                              )
                                            : Text(char,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              if (task3UserAnswers.length == 3)
                AnimatedButton(
                  onPressed: isAnswered ? () {} : _checkTask3,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF58CC02),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4),
                      ],
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 28),
                  ),
                ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask4() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Берілген суретті атап айтшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3), blurRadius: 10)
                  ],
                ),
                child: const Center(
                    child: Text('👄', style: TextStyle(fontSize: 80))),
              ),
              const SizedBox(height: 30),
              ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ChicletAnimatedButton(
                    onPressed: (isAnswered || _micPressed)
                        ? () {}
                        : () {
                            setState(() {
                              _micPressed = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('🎤 Микрофонға "ауыз" деп айтыңыз')),
                            );
                            // Simulate speech recognition
                            Timer(const Duration(seconds: 2), () {
                              _checkAnswer('ауыз');
                              // Reset pressed state a bit later to allow feedback
                              Future.delayed(const Duration(milliseconds: 250),
                                  () {
                                if (mounted) {
                                  setState(() {
                                    _micPressed = false;
                                  });
                                }
                              });
                            });
                          },
                    width: 80,
                    height: 80,
                    backgroundColor: _micPressed
                        ? Colors.green[700]!
                        : const Color(0xFF58CC02),
                    child: const Text('🎤',
                        style: TextStyle(color: Colors.white, fontSize: 36)),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask5() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Суретте ашуланған эмоцияны тапшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEmotionOption('ашу', '😠', 'ашу'),
                  _buildEmotionOption('күлкі', '😄', 'күлкі'),
                  _buildEmotionOption('жылау', '😢', 'жылау'),
                ],
              ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask6() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Берілген әріптерден сөз құрастыршы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Мақсат: тырнақ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 30),

              // Drag targets (slots)
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    final String? letter =
                        i < task6UserWord.length ? task6UserWord[i] : null;
                    return DragTarget<String>(
                      onWillAccept: (data) =>
                          !isAnswered && (task6UserWord.length < 6),
                      onAccept: (data) {
                        setState(() {
                          task6UserWord.add(data);
                          if (task6UserWord.length == 6) {
                            Timer(const Duration(milliseconds: 500), () {
                              _checkWordBuilding(6);
                            });
                          }
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            // allow removing a placed letter by tapping its slot
                            if (letter != null && !isAnswered) {
                              setState(() {
                                task6UserWord.removeAt(i);
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color: letter != null
                                  ? Colors.green[100]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Center(
                              child: Text(
                                letter ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // Draggable letters pool
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: task6Letters
                    .where((l) => !task6UserWord.contains(l))
                    .map((letter) => Draggable<String>(
                          data: letter,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[400]!),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6),
                                ],
                              ),
                              child: Center(
                                  child: Text(letter,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),
              if (task6UserWord.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      task6UserWord.clear();
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.clear, color: Colors.white, size: 28),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask7() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Берілген әріптерден сөз құрастыршы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Мақсат: табан',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 30),

              // Drag targets (5 slots)
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final String? letter =
                        i < task7UserWord.length ? task7UserWord[i] : null;
                    return DragTarget<String>(
                      onWillAccept: (data) =>
                          !isAnswered && (task7UserWord.length < 5),
                      onAccept: (data) {
                        setState(() {
                          task7UserWord.add(data);
                          if (task7UserWord.length == 5) {
                            Timer(const Duration(milliseconds: 500), () {
                              _checkWordBuilding(7);
                            });
                          }
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            if (letter != null && !isAnswered) {
                              setState(() {
                                task7UserWord.removeAt(i);
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color: letter != null
                                  ? Colors.green[100]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Center(
                              child: Text(
                                letter ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // Draggable letters pool
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: (() {
                  // create a mutable copy of original letters and remove one
                  // occurrence for each placed letter so duplicates are
                  // handled correctly (e.g. two 'а' letters can both appear)
                  final pool = List<String>.from(task7Letters);
                  for (final placed in task7UserWord) {
                    pool.remove(placed);
                  }

                  return pool
                      .map((letter) => Draggable<String>(
                            data: letter,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[400]!),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6),
                                  ],
                                ),
                                child: Center(
                                    child: Text(letter,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                            ),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ))
                      .toList();
                })(),
              ),

              const SizedBox(height: 20),
              if (task7UserWord.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      task7UserWord.clear();
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.clear, color: Colors.white, size: 28),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask8() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Мәтінді тыңдап, қандай дене мүшесі жайлы екенін тапшы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              AnimatedButton(
                onPressed: () {
                  // Play audio segment instead of showing snackbar
                  // Assuming the audio file has the text at certain timestamps
                  // You may need to adjust the timestamps based on your audio file
                  soundService.playSegment(0, 4000); // Play first 4 seconds
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
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
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBodyPartOption('қол', '✋', 'қол'),
                  _buildBodyPartOption('бас', '👤', 'бас'),
                  _buildBodyPartOption('аяқ', '🦶', 'аяқ'),
                ],
              ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask9() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Сөздерді ретімен орналастырып, сөйлем құрастыршы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Slots for the user's sentence (2x2 grid)
              Container(
                height: 160,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _task9DragSlot(0),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _task9DragSlot(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _task9DragSlot(2),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _task9DragSlot(3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Draggable pool of available words
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: (() {
                  final pool = List<String>.from(task9Words);
                  for (final placed in task9UserSentence) {
                    pool.remove(placed);
                  }

                  return pool
                      .map((word) => Draggable<String>(
                            data: word,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[400]!),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6),
                                  ],
                                ),
                                child: Text(word,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            childWhenDragging: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: Text(word,
                                  style: const TextStyle(fontSize: 16)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: Text(word,
                                  style: const TextStyle(fontSize: 16)),
                            ),
                          ))
                      .toList();
                })(),
              ),

              const SizedBox(height: 20),
              if (task9UserSentence.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      task9UserSentence.clear();
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.clear, color: Colors.white, size: 28),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  Widget _buildTask10() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Дене мүшелері және олардың әрекетін байланыстыршы',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    // Left side - body parts
                    Expanded(
                      child: Column(
                        children: task10Matches.keys
                            .map((bodyPart) => DragTarget<String>(
                                  onWillAccept: (data) => !isAnswered,
                                  onAccept: (data) {
                                    setState(() {
                                      // free previous item if any
                                      final prev = task10Matches[bodyPart];
                                      if (prev != null) {
                                        task10Used[prev] = false;
                                      }
                                      // assign new
                                      task10Matches[bodyPart] = data;
                                      task10Used[data] = true;
                                    });
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return GestureDetector(
                                      onTap: () {
                                        // allow clearing the assigned item
                                        if (!isAnswered &&
                                            task10Matches[bodyPart] != null) {
                                          setState(() {
                                            final prev =
                                                task10Matches[bodyPart];
                                            if (prev != null)
                                              task10Used[prev] = false;
                                            task10Matches[bodyPart] = null;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(_getBodyPartEmoji(bodyPart),
                                                style: const TextStyle(
                                                    fontSize: 30)),
                                            const SizedBox(width: 10),
                                            Text(bodyPart,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            if (task10Matches[bodyPart] != null)
                                              Text(
                                                  ' → ${task10Matches[bodyPart]}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.green[700])),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    // Right side - draggable items
                    Expanded(
                      child: Column(
                        children: task10Items
                            .where((item) => !task10Used[item]!)
                            .map(
                              (item) => Draggable<String>(
                                data: item,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14)),
                                ),
                                feedback: Material(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(item,
                                        style: const TextStyle(fontSize: 14)),
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
              if (task10Matches.values.every((v) => v != null))
                AnimatedButton(
                  onPressed: isAnswered ? () {} : _checkTask10,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF58CC02),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Тексеру',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
            ],
          ),
        ),
        if (showFeedback && isCorrect != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect!,
              onContinue: _proceedAfterFeedback,
            ),
          ),
      ],
    );
  }

  String _getBodyPartEmoji(String bodyPart) {
    switch (bodyPart) {
      case 'көз':
        return '👁️';
      case 'ауыз':
        return '👄';
      case 'құлақ':
        return '👂';
      default:
        return '❓';
    }
  }

  Widget _buildBodyPartOption(String label, String emoji, String value) {
    final bool isSelected = selectedAnswer == value;
    final Color bgColor = isSelected
        ? (value == 'мұрын' && currentTask == 1 ||
                value == 'көз' && currentTask == 2 ||
                value == 'аяқ' && currentTask == 8
            ? Colors.green
            : Colors.red)
        : Colors.white;

    return ChicletAnimatedButton(
      onPressed: isAnswered ? () {} : () => _checkAnswer(value),
      width: 100,
      height: 100,
      backgroundColor: bgColor,
      child: Text('$emoji\n$label',
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, fontSize: 16)),
    );
  }

  Widget _buildEmotionOption(String label, String emoji, String value) {
    final bool isSelected = selectedAnswer == value;
    final Color bgColor = isSelected
        ? (value == 'ашу' ? Colors.green : Colors.red)
        : Colors.white;

    return ChicletAnimatedButton(
      onPressed: isAnswered ? () {} : () => _checkAnswer(value),
      width: 100,
      height: 100,
      backgroundColor: bgColor,
      child: Text('$emoji\n$label',
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, fontSize: 18)),
    );
  }

  // helper for Task 9 slot (index 0..3)
  Widget _task9DragSlot(int i) {
    final String? word =
        i < task9UserSentence.length ? task9UserSentence[i] : null;
    return DragTarget<String>(
      onWillAccept: (data) =>
          !isAnswered && (task9UserSentence.length < 4 || word != null),
      onAccept: (data) {
        setState(() {
          if (i <= task9UserSentence.length) {
            task9UserSentence.insert(i, data);
          } else {
            task9UserSentence.add(data);
          }

          for (int j = task9UserSentence.length - 1; j >= 0; j--) {
            if (j != i && task9UserSentence[j] == data) {
              task9UserSentence.removeAt(j);
            }
          }

          if (task9UserSentence.length > 4) {
            task9UserSentence = task9UserSentence.sublist(0, 4);
          }

          if (task9UserSentence.length == 4) {
            Timer(const Duration(milliseconds: 500), () {
              _checkTask9();
            });
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (word != null && !isAnswered) {
              setState(() {
                task9UserSentence.removeAt(i);
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            height: 60,
            decoration: BoxDecoration(
              color: word != null ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Center(
              child: Text(
                word ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
