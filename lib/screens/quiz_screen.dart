import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  bool? isCorrect;
  String? selectedAnswer;
  final String correctAnswer = 'Мұрын';

  // Animation controllers
  late AnimationController _progressAnimationController;
  late AnimationController _shakeAnimationController;
  late AnimationController _bounceAnimationController;
  late AnimationController _slideInAnimationController;
  late AnimationController _fadeInAnimationController;

  // Animations
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _fadeInAnimation;

  int _currentQuestionIndex =
      3; // Assuming we're on the 4th question (0-indexed)

  @override
  void initState() {
    super.initState();

    // Progress animation
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Shake animation for wrong answers
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeAnimationController,
      curve: Curves.elasticIn,
    ));

    // Bounce animation for correct answers
    _bounceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _bounceAnimationController,
      curve: Curves.elasticInOut,
    ));

    // Slide in animation for feedback message
    _slideInAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideInAnimationController,
      curve: Curves.easeOutQuad,
    ));

    // Fade in animation for new questions
    _fadeInAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeInAnimationController,
      curve: Curves.easeIn,
    ));

    // Start with faded in content
    _fadeInAnimationController.value = 1.0;
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _shakeAnimationController.dispose();
    _bounceAnimationController.dispose();
    _slideInAnimationController.dispose();
    _fadeInAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return _buildProgressIndicator(index < _currentQuestionIndex);
                }),
              ),
            ),

            const SizedBox(height: 40),

            // Question
            FadeTransition(
              opacity: _fadeInAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Что означает эта картинка?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'AtypDisplay',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Image
            SvgPicture.asset(
              'assets/images/noise.svg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 40),

            // Answer options
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnswerOption('Ауыз'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildAnswerOption('Құлақ'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnswerOption('Бет'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildAnswerOption('Мұрын'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Result message
            if (isCorrect != null)
              SlideTransition(
                position: _slideInAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isCorrect!
                        ? const Color(0xFFEBF9DF)
                        : const Color(0xFFFBE8E8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect! ? Icons.check_circle : Icons.cancel,
                        color:
                            isCorrect! ? const Color(0xFF76B947) : Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCorrect! ? 'Amazing!' : 'Неправильно!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isCorrect!
                                    ? const Color(0xFF76B947)
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Ответ: $correctAnswer',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Next question button
            if (isCorrect != null)
              SlideTransition(
                position: _slideInAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Start fade out animation
                        _fadeInAnimationController.reverse().then((_) {
                          setState(() {
                            isCorrect = null;
                            selectedAnswer = null;
                            if (_currentQuestionIndex < 5) {
                              _currentQuestionIndex++;
                            }
                          });

                          // Reset slide animation
                          _slideInAnimationController.reset();

                          // Start fade in animation for new question
                          _fadeInAnimationController.forward();

                          // Animate progress bar
                          _progressAnimationController.forward(from: 0.0);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Следующий вопрос',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
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

  Widget _buildProgressIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 40,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isActive && _currentQuestionIndex == 3
          ? // Only animate the current progress item
          AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [Colors.blue, Colors.lightBlueAccent],
                      stops: [
                        _progressAnimationController.value,
                        _progressAnimationController.value + 0.1
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildAnswerOption(String answer) {
    final bool isSelected = selectedAnswer == answer;
    final bool isCorrectAnswer = answer == correctAnswer;

    Color backgroundColor = Colors.blue;
    if (isSelected && isCorrect != null) {
      backgroundColor = isCorrectAnswer ? const Color(0xFF8BC34A) : Colors.red;
    }

    return GestureDetector(
      onTap: () {
        if (selectedAnswer == null) {
          setState(() {
            selectedAnswer = answer;
            isCorrect = answer == correctAnswer;
          });

          // Start appropriate animation
          if (answer == correctAnswer) {
            _bounceAnimationController.forward(from: 0.0);
            _slideInAnimationController.forward(from: 0.0);
          } else {
            _shakeAnimationController.forward(from: 0.0);
            _slideInAnimationController.forward(from: 0.0);
          }
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _shakeAnimation,
          _bounceAnimation,
        ]),
        builder: (context, child) {
          // Apply shake animation for wrong answers
          double offsetX = 0.0;
          if (isSelected && !isCorrectAnswer && isCorrect != null) {
            offsetX = math.sin(_shakeAnimation.value * math.pi * 5) * 10;
          }

          // Apply bounce scale for correct answers
          double scale = 1.0;
          if (isSelected && isCorrectAnswer && isCorrect != null) {
            scale = _bounceAnimation.value;
          }

          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (isCorrectAnswer ? Colors.green : Colors.red)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        answer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'AtypDisplay',
                        ),
                      ),
                      if (isSelected && isCorrect != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            isCorrectAnswer ? Icons.check_circle : Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
