import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_button/animated_button.dart';
import 'package:til_bil_app/widgets/answer_notification.dart';
import 'package:audioplayers/audioplayers.dart';

class BirinshiOyinScreen extends StatefulWidget {
  @override
  _BirinshiOyinScreenState createState() => _BirinshiOyinScreenState();
}

class _BirinshiOyinScreenState extends State<BirinshiOyinScreen> {
  PageController _pageController = PageController();
  int currentTaskIndex = 0;
  late ConfettiController _confettiController;

  void _nextTask() {
    if (currentTaskIndex < 9) {
      setState(() {
        currentTaskIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onCorrectAnswer() {
    _confettiController.play();
    // Auto advance after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _nextTask();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF8BC34A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Құттықтаймыз!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Барлық тапсырмаларды орындадыңыз!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedButton(
                  width: 200,
                  height: 50,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Жалғастыру',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header with progress
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
                          widthFactor: (currentTaskIndex + 1) / 10,
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
              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Task1ReadingAnalysis(onCorrectAnswer: _onCorrectAnswer),
                    Task2ListenAndFind(onCorrectAnswer: _onCorrectAnswer),
                    Task3BuildWords(onCorrectAnswer: _onCorrectAnswer),
                    Task4WordTypes(onCorrectAnswer: _onCorrectAnswer),
                    Task5AnalyzeWord(onCorrectAnswer: _onCorrectAnswer),
                    Task6FindWordType(onCorrectAnswer: _onCorrectAnswer),
                    Task7AnalyzeWord2(onCorrectAnswer: _onCorrectAnswer),
                    Task8AnalyzeWords(onCorrectAnswer: _onCorrectAnswer),
                    Task9SpeakWordTypes(onCorrectAnswer: _onCorrectAnswer),
                    Task10FinalAnalysis(onCorrectAnswer: () {
                      _confettiController.play();
                      Future.delayed(const Duration(seconds: 2), () {
                        _showCompletionDialog();
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Reading Analysis
class Task1ReadingAnalysis extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task1ReadingAnalysis({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task1ReadingAnalysisState createState() => _Task1ReadingAnalysisState();
}

class _Task1ReadingAnalysisState extends State<Task1ReadingAnalysis> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "өс - түбір, іп - жұрнақ";
      showNotification = true;
    });
    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мәтінді оқы:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Қарлы таулардың баурайында әдемі гүлдер өсіп тұр."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "өсіп" сөзін құрамына бөл.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                "өс - түбір, іп - жұрнақ",
                "өсі - түбір, п - жұрнақ",
                "өсіп - түбір"
              ]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}

// Task 3: Build Words
class Task3BuildWords extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task3BuildWords({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task3BuildWordsState createState() => _Task3BuildWordsState();
}

class _Task3BuildWordsState extends State<Task3BuildWords> {
  Map<String, String> answers = {};
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = answers.length == 3 &&
          answers.containsKey("ой") &&
          answers.containsKey("жаз") &&
          answers.containsKey("жер");
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Берілген түбірлерден сөз құрап жаз:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '(Кемінде біреуінде жұрнақ, біреуінде жалғау болсын)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              ...["ой", "жаз", "жер"]
                  .map(
                    (root) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$root →',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Сөз жазыңыз...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF4CAF50), width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    answers[root] = value;
                                  } else {
                                    answers.remove(root);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Үлгі:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ой-шы, жаз-дық, жер-лер',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              if (answers.length == 3 && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }
}

// Task 2: Listen and Find
class Task2ListenAndFind extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task2ListenAndFind({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task2ListenAndFindState createState() => _Task2ListenAndFindState();
}

class _Task2ListenAndFindState extends State<Task2ListenAndFind> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "жайқа";
      showNotification = true;
    });
    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _playTaskAudio() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('audio/main_audio.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Аудионы тыңда:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  width: 120,
                  height: 120,
                  color: const Color(0xFF2196F3),
                  onPressed: _playTaskAudio,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Біздің ауылда алма ағаштары жайқалып тұр."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "жайқалып" сөзінің түбірін тап.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...["жайқа", "жайқал", "жайқалы"]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}

// Task 6: Find Word Type
class Task6FindWordType extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task6FindWordType({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task6FindWordTypeState createState() => _Task6FindWordTypeState();
}

class _Task6FindWordTypeState extends State<Task6FindWordType> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _playTaskAudio() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('audio/main_audio.mp3'));
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "сын есім";
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Тыңда:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  width: 120,
                  height: 120,
                  color: const Color(0xFF2196F3),
                  onPressed: _playTaskAudio,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Орман ішінде қалың ағаштар жайқалып өседі."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "қалың" сөзінің сөз табын тап.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...["зат есім", "сын есім", "етістік"]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}

// Task 7: Analyze Word 2
class Task7AnalyzeWord2 extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task7AnalyzeWord2({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task7AnalyzeWord2State createState() => _Task7AnalyzeWord2State();
}

class _Task7AnalyzeWord2State extends State<Task7AnalyzeWord2> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "түбір – жүз, жұрнақ – іп, жалғау – жоқ";
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мәтін:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Теңізде түрлі балықтар жүзіп жүр."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "жүзіп" сөзін құрамына бөл.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                "түбір – жүз, жұрнақ – іп, жалғау – жоқ",
                "түбір – жүзі, жұрнақ – п, жалғау – жоқ",
                "түбір – жүзіп, жұрнақ – жоқ, жалғау – жоқ"
              ]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}

// Task 8: Analyze Words
class Task8AnalyzeWords extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task8AnalyzeWords({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task8AnalyzeWordsState createState() => _Task8AnalyzeWordsState();
}

class _Task8AnalyzeWordsState extends State<Task8AnalyzeWords> {
  Map<String, String> analyses = {};
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = analyses.length == 3 &&
          analyses.containsKey("балалар") &&
          analyses.containsKey("үйшік") &&
          analyses.containsKey("көктем");
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Келесі сөздерді құрамына бөл де, қайсысында жұрнақ бар екенін белгіле:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Text(
                  'балалар, үйшік, көктем',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ...["балалар", "үйшік", "көктем"]
                  .map(
                    (word) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$word →',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Құрамын жазыңыз...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF4CAF50), width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    analyses[word] = value;
                                  } else {
                                    analyses.remove(word);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Жауап үлгісі:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'балалар: бала – түбір, -лар – жалғау.\nүйшік: үй – түбір, -шік – жұрнақ.\nкөктем: көк – түбір, -тем – жұрнақ.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              if (analyses.length == 3 && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }
}

// Task 9: Speak Word Types
class Task9SpeakWordTypes extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task9SpeakWordTypes({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task9SpeakWordTypesState createState() => _Task9SpeakWordTypesState();
}

class _Task9SpeakWordTypesState extends State<Task9SpeakWordTypes> {
  Map<String, String> wordTypes = {};
  bool showNotification = false;
  bool isCorrect = false;
  bool hasSpeakingCompleted = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = wordTypes["қарлы"] == "сын есім" &&
          wordTypes["ойнау"] == "етістік" &&
          wordTypes["жолдар"] == "зат есім" &&
          hasSpeakingCompleted;
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  void _startSpeaking() {
    setState(() {
      hasSpeakingCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '"қарлы", "ойнау", "жолдар" сөздерін дауыстап айтып, сөз табын жаз.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              if (!hasSpeakingCompleted)
                Center(
                  child: Column(
                    children: [
                      AnimatedButton(
                        width: 120,
                        height: 120,
                        color: const Color(0xFF2196F3),
                        onPressed: _startSpeaking,
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Сөздерді дауыстап айтыңыз',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                ...["қарлы", "ойнау", "жолдар"]
                    .map(
                      (word) => Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                word,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: ["зат есім", "етістік", "сын есім"]
                                  .map(
                                    (type) => Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: AnimatedButton(
                                          width: 90,
                                          height: 40,
                                          color: wordTypes[word] == type
                                              ? const Color(0xFF4CAF50)
                                              : Colors.grey[200]!,
                                          onPressed: () {
                                            setState(() {
                                              wordTypes[word] = type;
                                            });
                                          },
                                          child: Text(
                                            type,
                                            style: TextStyle(
                                              color: wordTypes[word] == type
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
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
                      ),
                    )
                    .toList(),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'Жауабы: қарлы – сын есім, ойнау – етістік, жолдар – зат есім.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (hasSpeakingCompleted &&
                  wordTypes.length == 3 &&
                  !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }
}

// Task 10: Final Analysis
class Task10FinalAnalysis extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task10FinalAnalysis({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task10FinalAnalysisState createState() => _Task10FinalAnalysisState();
}

class _Task10FinalAnalysisState extends State<Task10FinalAnalysis> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "түбір – тол, жұрнақ – ып, жалғау – жоқ";
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мәтін:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Жазда өзендер толып ағады."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "толып" сөзінің құрамын анықта.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                "түбір – тол, жұрнақ – ып, жалғау – жоқ",
                "түбір – толы, жұрнақ – п, жалғау – жоқ",
                "түбір – толып, жұрнақ – жоқ, жалғау – жоқ"
              ]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Соңғы тапсырма!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Аяқтау',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}

// Task 4: Word Types
class Task4WordTypes extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task4WordTypes({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task4WordTypesState createState() => _Task4WordTypesState();
}

class _Task4WordTypesState extends State<Task4WordTypes> {
  Map<String, String> wordTypes = {};
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = wordTypes["күн"] == "зат есім" &&
          wordTypes["жүгіру"] == "етістік" &&
          wordTypes["әдемі"] == "сын есім";
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Экранда көрсетілген 3 сөзді дауыстап айтып, әрқайсының сөз табын белгіле:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              ...["күн", "жүгіру", "әдемі"]
                  .map(
                    (word) => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  word,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedButton(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF2196F3),
                                onPressed: () {
                                  // Play pronunciation
                                },
                                child: const Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: ["зат есім", "етістік", "сын есім"]
                                .map(
                                  (type) => Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: AnimatedButton(
                                        width: 90,
                                        height: 40,
                                        color: wordTypes[word] == type
                                            ? const Color(0xFF4CAF50)
                                            : Colors.grey[200]!,
                                        onPressed: () {
                                          setState(() {
                                            wordTypes[word] = type;
                                          });
                                        },
                                        child: Text(
                                          type,
                                          style: TextStyle(
                                            color: wordTypes[word] == type
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
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
                    ),
                  )
                  .toList(),
              if (wordTypes.length == 3 && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }
}

// Task 5: Analyze Word
class Task5AnalyzeWord extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const Task5AnalyzeWord({Key? key, required this.onCorrectAnswer})
      : super(key: key);

  @override
  _Task5AnalyzeWordState createState() => _Task5AnalyzeWordState();
}

class _Task5AnalyzeWordState extends State<Task5AnalyzeWord> {
  String? selectedAnswer;
  bool showNotification = false;
  bool isCorrect = false;

  void _playSound(bool correct) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (correct) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/incorrect.mp3'));
    }
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = selectedAnswer == "түбір - жау, жұрнақ - а, жалғау - ды";
      showNotification = true;
    });

    _playSound(isCorrect);

    if (isCorrect) {
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мәтін:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '"Көктемде жаңбыр жиі жауады."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Тапсырма: "жауады" сөзінің құрамындағы түбір, жұрнақ, жалғауды жаз.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                "түбір - жау, жұрнақ - а, жалғау - ды",
                "түбір - жауа, жұрнақ - жоқ, жалғау - ды",
                "түбір - жауады, жұрнақ - жоқ, жалғау - жоқ"
              ]
                  .map(
                    (answer) => Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedButton(
                          width: 300,
                          height: 60,
                          color: _getButtonColor(answer),
                          onPressed: () {
                            setState(() {
                              selectedAnswer = answer;
                            });
                          },
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: selectedAnswer == answer
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (selectedAnswer != null && !showNotification)
                Center(
                  child: AnimatedButton(
                    width: 200,
                    height: 50,
                    color: const Color(0xFF4CAF50),
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Тексеру',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showNotification)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnswerNotification(
              isCorrect: isCorrect,
              onContinue: () => setState(() => showNotification = false),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String answer) {
    if (selectedAnswer == answer) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey[200]!;
  }
}
