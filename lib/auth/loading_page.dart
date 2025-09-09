import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  late AnimationController _sparkleController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _sparkleAnimation;

  int _currentTextIndex = 0;
  final List<String> _loadingTexts = [
    'Профиліңіз дайындалуда...',
    'Сабақтар жүктелуде...',
    'Дайын!',
  ];

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for character
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Sparkle animation
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _progressController.forward();
    _sparkleController.repeat();

    // Text cycling animation
    _startTextCycling();

    // Navigate after loading completes
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            HapticFeedback.lightImpact();
            Navigator.of(context).pushReplacementNamed('/main');
          }
        });
      }
    });
  }

  void _startTextCycling() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted && _currentTextIndex < _loadingTexts.length - 1) {
        setState(() {
          _currentTextIndex++;
        });
        HapticFeedback.selectionClick();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    _sparkleController.dispose();
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
              Color(0xFF4FC3F7), // Light blue
              Color(0xFF29B6F6), // Medium blue
              Color(0xFF1976D2), // Darker blue
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating sparkles background
              _buildSparklesBackground(),
              
              // Main content
              SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Character with glow effect
                      _buildAnimatedCharacter(),

                      const SizedBox(height: 60),

                      // Progress indicator with modern design
                      _buildModernProgressIndicator(),

                      const SizedBox(height: 40),

                      // Dynamic loading text
                      _buildDynamicLoadingText(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSparklesBackground() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(15, (index) {
            final random = Random(index);
            final x = random.nextDouble() * MediaQuery.of(context).size.width;
            final y = random.nextDouble() * MediaQuery.of(context).size.height;
            final delay = random.nextDouble();
            final animationValue = (_sparkleController.value + delay) % 1.0;
            
            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: (sin(animationValue * pi * 2) + 1) / 2 * 0.6,
                child: Transform.scale(
                  scale: 0.5 + (sin(animationValue * pi * 2) + 1) / 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildAnimatedCharacter() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 180,
            height: 180,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF5F5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/character.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF58CC02),
                            Color(0xFF45A002),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 80,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernProgressIndicator() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: 280,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
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
                    color: const Color(0xFF81C784),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Progress percentage
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Text(
              '${(_progressAnimation.value * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDynamicLoadingText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ),
            ),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey<int>(_currentTextIndex),
        children: [
          Text(
            _loadingTexts[_currentTextIndex],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          if (_currentTextIndex < _loadingTexts.length - 1)
            Text(
              'Тағы сәл күте тұрыңыз...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Дайын!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
