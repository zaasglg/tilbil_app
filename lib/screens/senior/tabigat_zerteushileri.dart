import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import '../../widgets/animated_button.dart';
import 'dart:math';

import '../junior/sound_hunters.dart';

class TabigatZerteushileri extends StatefulWidget {
  const TabigatZerteushileri({Key? key}) : super(key: key);

  @override
  _TabigatZerteushileriState createState() => _TabigatZerteushileriState();
}

class _TabigatZerteushileriState extends State<TabigatZerteushileri> {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF0F8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.eco,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            const SizedBox(height: 20),
            const Text(
              'Сен табиғат зерттеушісісің!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '10-нан $_correctAnswers тапсырманы орындадың!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B4B4B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: const Center(
                    child: Text(
                      'Жарайсың!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                Task1FindAdjectives(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task2CategorizeWords(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task3ReadAndAnswer(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task4ExtractAdjectives(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task5DescribePlant(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task6SpringNature(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task7SpeakingPlants(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task8ComparePhenomena(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task9VerbTenses(onCorrect: _onCorrectAnswer, onNext: _nextTask),
                Task10ListenVerbs(
                    onCorrect: _onCorrectAnswer, onNext: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Find 5 adjectives in text
class Task1FindAdjectives extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task1FindAdjectives(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task1FindAdjectivesState createState() => _Task1FindAdjectivesState();
}

class _Task1FindAdjectivesState extends State<Task1FindAdjectives> {
  late ConfettiController _confettiController;
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  Set<String> correctAdjectives = {'әдемі', 'жасыл', 'ақ', 'тәтті', 'жылы'};
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _checkAnswer() {
    Set<String> enteredWords = {};
    for (var controller in _controllers) {
      String word = controller.text.trim().toLowerCase();
      if (word.isNotEmpty) {
        enteredWords.add(word);
      }
    }

    setState(() {
      isCorrect = enteredWords.length == 5 &&
          enteredWords.containsAll(correctAdjectives);
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Мәтінді оқып, ішінен 5 сын есімді тап',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B4B4B),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Көктемде бақ іші әдемі көрінеді. Жасыл жапырақтар желмен сыбдырлайды. Ақ гүлдерден тәтті иіс аңқиды. Аспанда жылы күн күлімдейді.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Сын есімдерді теріп жазыңыз:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B4B4B),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            labelText: '${index + 1}-сын есім',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _checkAnswer,
                  width: screenWidth / 1.2,
                  height: 60,
                  color: const Color(0xFF58CC02),
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

// Task 2: Categorize words
class Task2CategorizeWords extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task2CategorizeWords(
      {super.key, required this.onCorrect, required this.onNext});

  @override
  // ignore: library_private_types_in_public_api
  _Task2CategorizeWordsState createState() => _Task2CategorizeWordsState();
}

class _Task2CategorizeWordsState extends State<Task2CategorizeWords> {
  late ConfettiController _confettiController;
  Map<String, String> selections = {};
  final Map<String, String> correctAnswers = {
    'жаңбыр': 'құбылыс',
    'бәйшешек': 'өсімдік',
    'жел': 'құбылыс',
    'қарағай': 'өсімдік',
    'боран': 'құбылыс',
    'раушан': 'өсімдік',
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectCategory(String word, String category) {
    if (showNotification) return;

    setState(() {
      selections[word] = category;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String word in correctAnswers.keys) {
        if (selections[word] != correctAnswers[word]) {
          isCorrect = false;
          break;
        }
      }
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Сөздерді мағынасына қарай бөл',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: correctAnswers.keys.map((word) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectCategory(word, 'өсімдік'),
                                    width: double.infinity,
                                    height: 50,
                                    color: selections[word] == 'өсімдік'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Өсімдік',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectCategory(word, 'құбылыс'),
                                    width: double.infinity,
                                    height: 50,
                                    color: selections[word] == 'құбылыс'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Табиғи құбылыс',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: selections.length == 6 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selections.length == 6
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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

// Task 3: Read and answer questions
class Task3ReadAndAnswer extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task3ReadAndAnswer(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task3ReadAndAnswerState createState() => _Task3ReadAndAnswerState();
}

class _Task3ReadAndAnswerState extends State<Task3ReadAndAnswer> {
  late ConfettiController _confettiController;
  Map<int, String> answers = {};
  final Map<int, String> correctAnswers = {
    0: 'жаз',
    1: 'ұзақ әрі жарық',
    2: 'құстардың әні',
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (showNotification) return;

    setState(() {
      answers[questionIndex] = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = answers.length == 3;
      for (int i = 0; i < 3; i++) {
        if (answers[i] != correctAnswers[i]) {
          isCorrect = false;
          break;
        }
      }
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Мәтінді оқып, сұрақтарға жауап бер',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Жазда даланы сан түрлі гүлдер әсемдейді. Күн ұзақ әрі жарық болады. Құстардың әні көңілге қуаныш сыйлайды.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestion(0, 'Мәтінде қай мезгіл суреттелген?',
                          ['көктем', 'жаз', 'күз']),
                      _buildQuestion(1, 'Күннің қандай ерекшелігі аталды?',
                          ['ыстық', 'ұзақ әрі жарық', 'жақсы']),
                      _buildQuestion(2, 'Не көңілге қуаныш сыйлайды?',
                          ['гүлдер', 'дала', 'құстардың әні']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: answers.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: answers.length == 3
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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

  Widget _buildQuestion(int index, String question, List<String> options) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. $question',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...options.map((option) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: AnimatedButton(
                onPressed: () => _selectAnswer(index, option),
                width: double.infinity,
                height: 45,
                color: answers[index] == option
                    ? const Color(0xFF58CC02)
                    : const Color(0xFF87CEEB),
                child: Text(
                  option,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// Task 4: Extract adjectives from sentences
class Task4ExtractAdjectives extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task4ExtractAdjectives(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task4ExtractAdjectivesState createState() => _Task4ExtractAdjectivesState();
}

class _Task4ExtractAdjectivesState extends State<Task4ExtractAdjectives> {
  late ConfettiController _confettiController;
  Map<int, Set<String>> selectedAdjectives = {0: {}, 1: {}, 2: {}};
  final Map<int, Set<String>> correctAdjectives = {
    0: {'жылы'},
    1: {'таза'},
    2: {'қалың'},
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectWord(int sentenceIndex, String word) {
    if (showNotification) return;

    setState(() {
      if (selectedAdjectives[sentenceIndex]!.contains(word)) {
        selectedAdjectives[sentenceIndex]!.remove(word);
      } else {
        selectedAdjectives[sentenceIndex]!.add(word);
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (int i = 0; i < 3; i++) {
        if (!selectedAdjectives[i]!.containsAll(correctAdjectives[i]!) ||
            selectedAdjectives[i]!.length != correctAdjectives[i]!.length) {
          isCorrect = false;
          break;
        }
      }
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Сөйлемдерден сын есімдерді тауып жаз',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSentence(0, 'Жылы жел беттен сипады.',
                          ['жылы', 'жел', 'беттен', 'сипады']),
                      _buildSentence(1, 'Таудағы таза ауа өкпеңді ашады.',
                          ['таудағы', 'таза', 'ауа', 'өкпеңді', 'ашады']),
                      _buildSentence(2, 'Қалың қар тау басын жапты.',
                          ['қалың', 'қар', 'тау', 'басын', 'жапты']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _allSentencesCompleted() ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: _allSentencesCompleted()
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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

  bool _allSentencesCompleted() {
    return selectedAdjectives.values.every((set) => set.isNotEmpty);
  }

  Widget _buildSentence(int index, String sentence, List<String> words) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. $sentence',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) {
              final isSelected = selectedAdjectives[index]!.contains(word);
              return AnimatedButton(
                onPressed: () => _selectWord(index, word),
                width: 250,
                height: 35,
                color: isSelected
                    ? const Color(0xFF58CC02)
                    : const Color(0xFF87CEEB),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    word,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
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

// Task 5: Writing task - describe favorite plant
class Task5DescribePlant extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task5DescribePlant(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task5DescribePlantState createState() => _Task5DescribePlantState();
}

class _Task5DescribePlantState extends State<Task5DescribePlant> {
  late ConfettiController _confettiController;
  final TextEditingController _textController = TextEditingController();
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final text = _textController.text.trim();
    final sentences =
        text.split('.').where((s) => s.trim().isNotEmpty).toList();

    setState(() {
      isCorrect = sentences.length >= 3 && text.length >= 50;
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    widget.onCorrect(); // Always mark as correct for writing tasks
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Жазылым: Сүйікті өсімдігіңді сипатта',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Кемінде 3 сын есім қолданып, 3 сөйлем жаз.\nМысалы: әдемі, жасыл, биік, тәтті...',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText:
                          'Мысалы: Менің сүйікті өсімдігім - қызыл раушан. Ол өте әдемі әрі иісті. Оның жасыл жапырақтары...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _textController.text.trim().length > 20
                      ? _checkAnswer
                      : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: _textController.text.trim().length > 20
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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
              isCorrect: true, // Always show success for writing tasks
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 6: Writing - Spring nature
class Task6SpringNature extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task6SpringNature(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task6SpringNatureState createState() => _Task6SpringNatureState();
}

class _Task6SpringNatureState extends State<Task6SpringNature> {
  late ConfettiController _confettiController;
  final TextEditingController _textController = TextEditingController();
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    SystemSound.play(SystemSoundType.click);
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Көктемгі табиғат туралы жаз',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '5 сөйлемнен мәтін құрастыр. Кемінде 2 табиғи құбылысты ата.\nМысалы: жаңбыр, жел, күн, қар...',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Көктемде табиғат оянады. Жылы жел соғады...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: _textController.text.trim().length > 30
                      ? _checkAnswer
                      : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: _textController.text.trim().length > 30
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
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
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 7: Speaking - describe plants
class Task7SpeakingPlants extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task7SpeakingPlants(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task7SpeakingPlantsState createState() => _Task7SpeakingPlantsState();
}

class _Task7SpeakingPlantsState extends State<Task7SpeakingPlants> {
  late ConfettiController _confettiController;
  bool isRecording = false;
  bool hasRecorded = false;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
        hasRecorded = true;
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    SystemSound.play(SystemSoundType.click);
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Айтылым: Өсімдіктерді сипатта',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Досыңа өз аулаңдағы немесе ауылыңдағы өсімдіктерді сипаттап бер. Кемінде 3 сын есім қолдан.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? Colors.red
                              : const Color(0xFF58CC02),
                          shape: BoxShape.circle,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: _toggleRecording,
                            child: Icon(
                              isRecording ? Icons.stop : Icons.mic,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isRecording
                            ? 'Жазылуда...'
                            : hasRecorded
                                ? 'Жазылды!'
                                : 'Айтуды бастау',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: hasRecorded ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: hasRecorded ? const Color(0xFF58CC02) : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
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
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 8: Compare natural phenomena
class Task8ComparePhenomena extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task8ComparePhenomena(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task8ComparePhenomenaState createState() => _Task8ComparePhenomenaState();
}

class _Task8ComparePhenomenaState extends State<Task8ComparePhenomena> {
  late ConfettiController _confettiController;
  bool isRecording = false;
  bool hasRecorded = false;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
        hasRecorded = true;
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      showNotification = true;
    });

    _confettiController.play();
    SystemSound.play(SystemSoundType.click);
  }

  void _continue() {
    widget.onCorrect();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Екі табиғи құбылысты салыстыр',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Жаңбыр мен қарды салыстыр.\n"Ұқсастығы – …, айырмашылығы – …" құрылымын қолдан.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.umbrella,
                                    size: 40, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text('Жаңбыр',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Text('VS',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.ac_unit,
                                    size: 40, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text('Қар',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? Colors.red
                              : const Color(0xFF58CC02),
                          shape: BoxShape.circle,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: _toggleRecording,
                            child: Icon(
                              isRecording ? Icons.stop : Icons.mic,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isRecording
                            ? 'Жазылуда...'
                            : hasRecorded
                                ? 'Жазылды!'
                                : 'Салыстыруды бастау',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: hasRecorded ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: hasRecorded ? const Color(0xFF58CC02) : Colors.grey,
                  child: const Text(
                    'Аяқтадым',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
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
              isCorrect: true,
              onContinue: _continue,
            ),
          ),
      ],
    );
  }
}

// Task 9: Verb tenses
class Task9VerbTenses extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task9VerbTenses(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task9VerbTensesState createState() => _Task9VerbTensesState();
}

class _Task9VerbTensesState extends State<Task9VerbTenses> {
  late ConfettiController _confettiController;
  Map<String, String> selections = {};
  final Map<String, String> correctAnswers = {
    'отырғызды': 'өткен шақ',
    'әкеледі': 'келер шақ',
    'қопсытып жатыр': 'осы шақ',
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectTense(String verb, String tense) {
    if (showNotification) return;

    setState(() {
      selections[verb] = tense;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (selections[verb] != correctAnswers[verb]) {
          isCorrect = false;
          break;
        }
      }
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Етістіктерді тауып, шақ түрін анықта',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Аружан бақшада гүл отырғызды. Ертең ол жаңа көшеттер әкеледі. Қазір ол топырақты қопсытып жатыр.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verb,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'өткен шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Өткен шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'осы шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Осы шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'келер шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Келер шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: selections.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selections.length == 3
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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

// Task 10: Listen and identify verbs with tenses
class Task10ListenVerbs extends StatefulWidget {
  final VoidCallback onCorrect;
  final VoidCallback onNext;

  const Task10ListenVerbs(
      {Key? key, required this.onCorrect, required this.onNext})
      : super(key: key);

  @override
  _Task10ListenVerbsState createState() => _Task10ListenVerbsState();
}

class _Task10ListenVerbsState extends State<Task10ListenVerbs> {
  late ConfettiController _confettiController;
  Map<String, String> selections = {};
  final Map<String, String> correctAnswers = {
    'жазып отыр': 'осы шақ',
    'бардық': 'өткен шақ',
    'келеді': 'келер шақ',
  };
  bool showNotification = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playAudio() {
    // Simulate audio playback
    SystemSound.play(SystemSoundType.click);
  }

  void _selectTense(String verb, String tense) {
    if (showNotification) return;

    setState(() {
      selections[verb] = tense;
    });
  }

  void _checkAnswer() {
    setState(() {
      isCorrect = true;
      for (String verb in correctAnswers.keys) {
        if (selections[verb] != correctAnswers[verb]) {
          isCorrect = false;
          break;
        }
      }
      showNotification = true;
    });

    if (isCorrect!) {
      _confettiController.play();
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _continue() {
    if (isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            particleDrag: 0.02,
            emissionFrequency: 0.02,
            numberOfParticles: 50,
            gravity: 0.02,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Тыңдап, етістіктерді анықта',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4B4B)),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58CC02),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: _playAudio,
                      child: const Icon(Icons.volume_up,
                          size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Дыбысты тыңда',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Сөйлемдер:\n1. Данияр хат жазып отыр.\n2. Біз кеше орманға бардық.\n3. Ертең достарымыз келеді.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: correctAnswers.keys.map((verb) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verb,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'өткен шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'өткен шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Өткен шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'осы шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'осы шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Осы шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedButton(
                                    onPressed: () =>
                                        _selectTense(verb, 'келер шақ'),
                                    width: double.infinity,
                                    height: 45,
                                    color: selections[verb] == 'келер шақ'
                                        ? const Color(0xFF58CC02)
                                        : const Color(0xFF87CEEB),
                                    child: const Text(
                                      'Келер шақ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedButton(
                  onPressed: selections.length == 3 ? _checkAnswer : () {},
                  width: screenWidth / 1.2,
                  height: 60,
                  color: selections.length == 3
                      ? const Color(0xFF58CC02)
                      : Colors.grey,
                  child: const Text(
                    'Тексеру',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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
