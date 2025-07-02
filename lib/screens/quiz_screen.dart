import 'package:flutter/material.dart';
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
  late AnimationController _rayAnimationController;

  // Animations
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _rayAnimation;

  int _currentQuestionIndex = 3; // Assuming we're on the 4th question (0-indexed)

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

    // Ray animation for background rays
    _rayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _rayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rayAnimationController);

    // Start with faded in content
    _fadeInAnimationController.value = 1.0;
    
    // Start ray animation
    _rayAnimationController.repeat();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _shakeAnimationController.dispose();
    _bounceAnimationController.dispose();
    _slideInAnimationController.dispose();
    _fadeInAnimationController.dispose();
    _rayAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2), // Blue
              Color(0xFF50C878), // Green
              Color(0xFF87CEEB), // Light blue
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Rays
            AnimatedBuilder(
              animation: _rayAnimation,
              builder: (context, child) {
                return Stack(
                  children: List.generate(12, (index) {
                    final angle = (index * 30.0) + (_rayAnimation.value * 360);
                    return Positioned(
                      top: MediaQuery.of(context).size.height * 0.3,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: Transform.rotate(
                        angle: angle * math.pi / 180,
                        child: Transform.translate(
                          offset: const Offset(-300, 0),
                          child: Container(
                            width: 600,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            
            // Decorative circles
            Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Что означает эта картинка?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'AtypDisplay',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.face_retouching_natural,
                          size: 80,
                          color: Colors.blue[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'НОС',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
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
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(15),
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
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isCorrect! 
                                    ? const Color(0xFF58CC02) 
                                    : const Color(0xFFFF4B4B),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCorrect! ? Icons.check : Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCorrect! ? 'Отлично!' : 'Неправильно!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect! 
                                          ? const Color(0xFF58CC02) 
                                          : const Color(0xFFFF4B4B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ответ: $correctAnswer',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF777777),
                                      fontWeight: FontWeight.w500,
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
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF58CC02), Color(0xFF89E219)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF58CC02).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
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
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'ПРОДОЛЖИТЬ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isActive && _currentQuestionIndex == 3
          ? AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [Colors.white, Colors.white],
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

    Color backgroundColor = Colors.white.withOpacity(0.9);
    Color textColor = const Color(0xFF3C4043);
    Color borderColor = Colors.white.withOpacity(0.3);
    
    if (isSelected && isCorrect != null) {
      if (isCorrectAnswer) {
        backgroundColor = const Color(0xFF58CC02);
        textColor = Colors.white;
        borderColor = const Color(0xFF58CC02);
      } else {
        backgroundColor = const Color(0xFFFF4B4B);
        textColor = Colors.white;
        borderColor = const Color(0xFFFF4B4B);
      }
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (isCorrectAnswer ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B))
                                .withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        answer,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
