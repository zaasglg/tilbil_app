import 'package:flutter/material.dart';
import '../../widgets/animated_button.dart';

class MatinMekeniScreen extends StatefulWidget {
  const MatinMekeniScreen({super.key});

  @override
  State<MatinMekeniScreen> createState() => _MatinMekeniScreenState();
}

class _MatinMekeniScreenState extends State<MatinMekeniScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextTask() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF58CC02),
        title: const Text('Мәтін мекені'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentPage + 1) / 10,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
                ),
                const SizedBox(height: 8),
                Text('Тапсырма ${_currentPage + 1}/10'),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                Task1FindDeclarative(onCorrect: _nextTask),
                Task2AddPunctuation(onCorrect: _nextTask),
                Task3FindQuestion(onCorrect: _nextTask),
                Task4FindExclamatory(onCorrect: _nextTask),
                Task5BuildSentence(onCorrect: _nextTask),
                Task6FindWrongPunctuation(onCorrect: _nextTask),
                Task7SplitText(onCorrect: _nextTask),
                Task8ChooseEnding1(onCorrect: _nextTask),
                Task9ChooseEnding2(onCorrect: _nextTask),
                Task10ReadText(onCorrect: _nextTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Task 1: Find declarative sentence
class Task1FindDeclarative extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task1FindDeclarative({super.key, required this.onCorrect});

  @override
  State<Task1FindDeclarative> createState() => _Task1FindDeclarativeState();
}

class _Task1FindDeclarativeState extends State<Task1FindDeclarative> {
  final List<String> options = [
    'Көктем келді.',
    'Қар жауып тұр ма?',
    'Неткен әдемі гүлдер!'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Көктем келді.';
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
            'Берілген сөйлемдер ішінен хабарлы сөйлемді тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = '${index + 1}.';

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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    '$label $option',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
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

// Task 2: Add appropriate punctuation
class Task2AddPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task2AddPunctuation({super.key, required this.onCorrect});

  @override
  State<Task2AddPunctuation> createState() => _Task2AddPunctuationState();
}

class _Task2AddPunctuationState extends State<Task2AddPunctuation> {
  final List<String> options = [
    'Нүкте (.)',
    'Сұрақ белгісі (?)',
    'Леп белгісі (!)'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Леп белгісі (!)';
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
            'Сөйлемге лайықты тыныс белгісін қой',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              'Бүгін ауа райы қандай тамаша',
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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

// Task 3: Listen and find question sentence
class Task3FindQuestion extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task3FindQuestion({super.key, required this.onCorrect});

  @override
  State<Task3FindQuestion> createState() => _Task3FindQuestionState();
}

class _Task3FindQuestionState extends State<Task3FindQuestion> {
  final List<String> options = [
    'Мектепке дайынсың ба',
    'Күзгі бақ ерекше әдемі',
    'Көгалда көбелек ұшып жүр'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Мектепке дайынсың ба';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Берілген аудионы тыңдап, арасынан сұраулы сөйлемді тапшы',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B4B4B)),
            textAlign: TextAlign.center,
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
                      const SnackBar(
                          content:
                              Text('🔊 Үш сөйлем: хабарлы, сұраулы, лепті')),
                    );
                  },
                  child: const Icon(Icons.volume_up,
                      size: 50, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = '${index + 1}.';

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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$label $option',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
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

// Task 4: Listen and find exclamatory sentence
class Task4FindExclamatory extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task4FindExclamatory({super.key, required this.onCorrect});

  @override
  State<Task4FindExclamatory> createState() => _Task4FindExclamatoryState();
}

class _Task4FindExclamatoryState extends State<Task4FindExclamatory> {
  final List<String> options = [
    'Көктемде құстар келеді',
    'Сен нешеде тұрдың',
    'Неткен әдемі аспан'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Неткен әдемі аспан';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Берілген аудионы тыңдап, арасынан лепті сөйлемді тапшы',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B4B4B)),
            textAlign: TextAlign.center,
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
                      const SnackBar(
                          content:
                              Text('🔊 Үш сөйлем: хабарлы, сұраулы, лепті')),
                    );
                  },
                  child: const Icon(Icons.volume_up,
                      size: 50, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = '${index + 1}.';

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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    '$label $option',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.left,
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

// Task 5: Build sentence from words
class Task5BuildSentence extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task5BuildSentence({super.key, required this.onCorrect});

  @override
  State<Task5BuildSentence> createState() => _Task5BuildSentenceState();
}

class _Task5BuildSentenceState extends State<Task5BuildSentence> {
  final List<String> words = ['Балалар', 'ойнап', 'қар', 'жүр', 'лақтырып'];
  final List<String> selectedWords = [];
  bool? isCorrect;

  void _selectWord(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.add(word);
      }
      isCorrect = null;
    });
  }

  void _checkAnswer() {
    String sentence = selectedWords.join(' ');
    setState(() {
      isCorrect = sentence == 'Балалар қар лақтырып ойнап жүр';
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
            'Берілген сөздерден сөйлем түрін құрастыр',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            height: 80,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                selectedWords.join(' '),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: words.map((word) {
              bool isSelected = selectedWords.contains(word);
              return AnimatedButton(
                width: 250.0,
                height: 60.0,
                onPressed: () => _selectWord(word),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          AnimatedButton(
            width: 250.0,
            height: 60.0,
            onPressed: _checkAnswer,
            child: const Text(
              'Тексеру',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Task 6: Find wrong punctuation
class Task6FindWrongPunctuation extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task6FindWrongPunctuation({super.key, required this.onCorrect});

  @override
  State<Task6FindWrongPunctuation> createState() =>
      _Task6FindWrongPunctuationState();
}

class _Task6FindWrongPunctuationState extends State<Task6FindWrongPunctuation> {
  final List<String> options = [
    'Бұл алма дәмді!',
    'Кеше сен киноға бардың ба!',
    'Неткен қызық ойын.'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == 'Кеше сен киноға бардың ба!';
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
            'Тыныс белгісі қате қойылған сөйлемді тапшы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              String label = '${index + 1}.';

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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    '$label $option',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
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

// Task 7: Split text into sentences
class Task7SplitText extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task7SplitText({super.key, required this.onCorrect});

  @override
  State<Task7SplitText> createState() => _Task7SplitTextState();
}

class _Task7SplitTextState extends State<Task7SplitText> {
  final List<String> options = [
    'Күн ашық. Балалар далада ойнап жүр. Олар өте көңілді.',
    'Күн ашық, балалар далада ойнап. Жүр. Олар өте көңілді',
    'Күн ашық? Балалар далада ойнап жүр? Олар өте көңілді'
  ];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect =
          answer == 'Күн ашық. Балалар далада ойнап жүр. Олар өте көңілді.';
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
            'Мәтінді сөйлемге бөлші',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Text(
              'Күн ашық балалар далада ойнап жүр олар өте көңілді',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
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

// Task 8: Choose sentence ending 1
class Task8ChooseEnding1 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task8ChooseEnding1({super.key, required this.onCorrect});

  @override
  State<Task8ChooseEnding1> createState() => _Task8ChooseEnding1State();
}

class _Task8ChooseEnding1State extends State<Task8ChooseEnding1> {
  final List<String> options = ['. (нүкте)', '? (сұрақ)', '! (леп)'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == '! (леп)';
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
            'Сөйлемнің соңын таңда',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Text(
              'Шырша қандай әдемі ___',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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

// Task 9: Choose sentence ending 2
class Task9ChooseEnding2 extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task9ChooseEnding2({super.key, required this.onCorrect});

  @override
  State<Task9ChooseEnding2> createState() => _Task9ChooseEnding2State();
}

class _Task9ChooseEnding2State extends State<Task9ChooseEnding2> {
  final List<String> options = ['. (нүкте)', '? (сұрақ)', '! (леп)'];
  String? selectedAnswer;
  bool? isCorrect;

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == '. (нүкте)';
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
            'Сөйлемнің соңын таңда',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
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
              'Қар қалың жауды ___',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                child: AnimatedButton(
                  width: 250.0,
                  height: 60.0,
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

// Task 10: Read text (auto-skip)
class Task10ReadText extends StatefulWidget {
  final VoidCallback onCorrect;
  const Task10ReadText({super.key, required this.onCorrect});

  @override
  State<Task10ReadText> createState() => _Task10ReadTextState();
}

class _Task10ReadTextState extends State<Task10ReadText> {
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
            'Берілген мәтінді тыныс белгісіне сай оқып берші',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Жаз келді. Балалар лагерьге барды. Лагерьде өте көңілді.',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58CC02)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
