import 'package:flutter/material.dart';
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

class MatinSheberhanasyScreen extends StatefulWidget {
  @override
  _MatinSheberhanasyScreenState createState() =>
      _MatinSheberhanasyScreenState();
}

class _MatinSheberhanasyScreenState extends State<MatinSheberhanasyScreen>
    with TickerProviderStateMixin {
  int currentTask = 1;
  int score = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textController3 = TextEditingController();

  // Task-specific variables
  String? selectedAnswer;
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
    _animationController.forward();
    _initializeCurrentTask();
  }

  void _initializeCurrentTask() {
    setState(() {
      selectedAnswer = null;
      _textController1.clear();
      _textController2.clear();
      _textController3.clear();
    });
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });

    // Проверяем правильность ответа
    bool isCorrect = false;
    switch (currentTask) {
      case 1:
        isCorrect = answer == 'Бүгін біз табиғатты қорғау туралы әңгімелейміз';
        break;
      case 2:
        isCorrect = answer == 'Кіріспе, негізгі бөлім, қорытынды';
        break;
      case 3:
        isCorrect = answer == 'Қыс мезгілінің қызығы жайлы';
        break;
      case 5:
        isCorrect = answer == 'Сондықтан мен мысығымды жақсы көремін';
        break;
      case 6:
        isCorrect = answer == 'Екінші';
        break;
      case 9:
        isCorrect = answer == 'екінші сөйлем';
        break;
      case 10:
        isCorrect = answer == 'үшінші сөйлем';
        break;
    }

    if (isCorrect) {
      setState(() {
        score += 10;
      });
      _showCorrectFeedback();
    } else {
      _showIncorrectFeedback();
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

  void _checkTextFields() {
    bool isCorrect = false;
    switch (currentTask) {
      case 4:
      case 7:
        isCorrect = _textController1.text.isNotEmpty &&
            _textController2.text.isNotEmpty &&
            _textController3.text.isNotEmpty;
        break;
      case 8:
        isCorrect = true; // Auto-complete for reading task
        break;
    }

    if (isCorrect) {
      setState(() {
        score += 10;
      });
      _showCorrectFeedback();
    } else {
      _showIncorrectFeedback();
    }
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
    } catch (e) {}
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
          if (_showAnswerNotification && _lastIsCorrect != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnswerNotification(
                isCorrect: _lastIsCorrect!,
                onContinue: () {
                  setState(() => _showAnswerNotification = false);
                  if (_lastIsCorrect!) {
                    _nextTask();
                  }
                },
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
            'Мәтінді тыңдап, кіріспе сөйлемді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => _playAudio('tabigat_qorgau.mp3'),
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
          ...[
            'Табиғат – біздің байлығымыз',
            'Бүгін біз табиғатты қорғау туралы әңгімелейміз',
            'Құстар орманда зиянкес жәндіктерден тазартады'
          ]
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 250.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
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
            'Мәтін құрылымы қандай болу керек, дұрыс нұсқаны таңдашы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...[
            'Кіріспе, негізгі бөлім, қорытынды',
            'Негізгі бөлім, кіріспе, қорытынды',
            'Негізгі бөлім, қорытынды'
          ]
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
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
            'Мәтінді тыңдап, не туралы екенін анықташы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => _playAudio('qys_mezgili.mp3'),
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
          ...[
            'Жаңа жыл мерекесі жайлы',
            'Қыста ауырып қалған бала жайлы',
            'Қыс мезгілінің қызығы жайлы'
          ]
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
          // Кнопка проверки удалена: переход происходит автоматически после выбора
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
            'Суретке қарап, мәтін құрастыршы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text('🌅', style: TextStyle(fontSize: 30))),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _textController1,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text('🏫👦👧', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _textController2,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text('📚✏️', style: TextStyle(fontSize: 25))),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _textController3,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _textController1.text.isNotEmpty &&
                    _textController2.text.isNotEmpty &&
                    _textController3.text.isNotEmpty
                ? _checkTextFields
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
              'Дайын',
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
            'Төмендегі сөйлемдер арасынан қорытынды сөйлемді тапшы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...[
            'Менің сүйікті жануарым – мысық',
            'Ол өте сүйкімді, ойынқұмар',
            'Сондықтан мен мысығымды жақсы көремін'
          ]
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
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
            'Мәтінді оқып, ондағы негізгі сөйлемді анықташы',
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
              'Ана – ең қымбат жан. Ол бізді бағып-қағады. Біз ананы сыйлауымыз керек.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['Бірінші', 'Екінші', 'Үшінші']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
            'Мәтінді оқып, арасындағы бос орынды толықтыршы',
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
                const Text('Көктем келді.', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _textController1,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _textController2,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _textController3,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Сондықтан көктем маған ұнайды.',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _textController1.text.isNotEmpty &&
                    _textController2.text.isNotEmpty &&
                    _textController3.text.isNotEmpty
                ? _checkTextFields
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

  Widget _buildTask8() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Мәтінді дауыстап оқып берші',
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
              'Әжем дәмді бауырсақ пісірді. Үй іші хош иіске толды. Бәріміз дастарханға жиналдық.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Берілген мәтінді дауыстап оқыңыз',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkTextFields,
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
              'Оқып бітірдім',
              style: TextStyle(color: Colors.white, fontSize: 18),
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
            'Мәтінді оқып, үйлеспейтін сөйлемді анықташы',
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
              'Көктем – әдемі мезгіл. Жазда теңізге шомыламыз. Сондықтан көктемді бәрі жақсы көреді.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['бірінші сөйлем', 'екінші сөйлем', 'үшінші сөйлем']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
            'Мәтінді оқып, үйлеспейтін сөйлемді анықташы',
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
              'Наурыз – ұлттық мереке. Наурызда адамдар дастархан жаяды. Ағаштар қыста қалың қармен жабылады. Сондықтан Наурыз бәріне қуаныш сыйлайды.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...['бірінші сөйлем', 'үшінші сөйлем', 'төртінші сөйлем']
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    super.dispose();
  }
}
