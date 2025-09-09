import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_button/animated_button.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:til_bil_app/services/sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_page.dart';

// Custom clipper for triangle pointer in speech bubbles
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MultiStepRegisterScreen extends StatefulWidget {
  const MultiStepRegisterScreen({super.key});

  @override
  State<MultiStepRegisterScreen> createState() =>
      _MultiStepRegisterScreenState();
}

class _MultiStepRegisterScreenState extends State<MultiStepRegisterScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  // Controllers for used fields only
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Form keys for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Welcome step (no form)
    GlobalKey<FormState>(), // Age selection
    GlobalKey<FormState>(), // Username
  ];

  int _currentStep = 0;
  bool _isLoading = false;
  int _selectedAgeOption = -1; // Track which age option is selected

  // Mascot animation states
  bool _isWaving = false;
  bool _isJumping = false;

  // Beautiful gradient colors for each step - Light Blue Theme
  final List<List<Color>> _stepGradients = [
    [
      const Color(0xFF87CEEB),
      const Color(0xFF4FC3F7)
    ], // Welcome - Light Blue gradient
    [
      const Color(0xFF81D4FA),
      const Color(0xFF4FC3F7)
    ], // Age - Light Blue gradient
    [
      const Color(0xFF64B5F6),
      const Color(0xFF42A5F5)
    ], // Username - Medium Blue gradient
  ];

  // Step colors for UI elements - Light Blue Theme
  final List<Color> _stepColors = [
    const Color(0xFF87CEEB), // Light Blue (Sky Blue)
    const Color(0xFF81D4FA), // Light Blue (Light Sky Blue)
    const Color(0xFF64B5F6), // Medium Light Blue
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _mascotAnimationController;
  late AnimationController _progressAnimationController;

  String _displayedText = '';
  final String _fullText =
      'Cәлем, досым. Менің есімім Барыс. Танысқаныма өте қуаныштымын! Кел, бірге қазақ тілін үйренейік!';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _mascotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _progressAnimationController.forward();
    _triggerWaveAnimation();
    _startTypingAnimation();

    soundService.playSegment(0, 9000);
  }

  // Simplified animation trigger for non-Rive animations
  void _playRiveAnimation(String animationName) {
    // This method is kept for compatibility but simplified
    // since Rive animations are not currently loaded
  }

  // Process text for authentic Kazakh pronunciation

  void _triggerWaveAnimation() {
    setState(() {
      _isWaving = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isWaving = false;
        });
      }
    });
  }

  void _triggerJumpAnimation() {
    setState(() {
      _isJumping = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isJumping = false;
        });
      }
    });
  }

  void _startTypingAnimation() {
    _displayedText = '';
    int charIndex = 0;
    final random = Random();

    void typeNextChar() {
      if (charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[charIndex];

          // Шевеление персонажа время от времени во время печати
          if (_fullText[charIndex] == '.' ||
              _fullText[charIndex] == '!' ||
              _fullText[charIndex] == '?' ||
              _fullText[charIndex] == ',' ||
              charIndex % 15 == 0) {
            // Небольшое движение персонажа при важных символах или через каждые 15 символов
            _triggerJumpAnimation();
          }
        });

        // Добавляем вибрацию при печатании с разной интенсивностью,
        // но не при каждой букве, чтобы избежать слишком частой вибрации
        if (charIndex % 3 == 0) {
          HapticFeedback
              .lightImpact(); // Легкая вибрация для большинства символов
        } else if (charIndex % 12 == 0) {
          HapticFeedback
              .mediumImpact(); // Средняя вибрация для выделения некоторых символов
        } else if (_fullText[charIndex] == '.' ||
            _fullText[charIndex] == '!' ||
            _fullText[charIndex] == '?') {
          HapticFeedback
              .heavyImpact(); // Сильная вибрация для знаков препинания

          // Небольшая задержка после знаков препинания
          Future.delayed(const Duration(milliseconds: 300), () {
            charIndex++;
            if (charIndex < _fullText.length) {
              // Случайная пауза между 60-120 мс для естественной печати
              int delay = 60 + random.nextInt(60);
              Future.delayed(Duration(milliseconds: delay), typeNextChar);
            }
          });
          return;
        }

        charIndex++;

        // Случайная пауза между 60-120 мс для естественной печати
        int delay = 60 + random.nextInt(60);

        // Более длинная пауза на запятых для естественного ритма
        if (charIndex > 0 && _fullText[charIndex - 1] == ',') {
          delay += 150;
        }

        // Планируем следующий символ
        Future.delayed(Duration(milliseconds: delay), typeNextChar);
      } else {
        // Финальная вибрация и анимация по окончании печатания
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 500), () {
          _triggerWaveAnimation(); // Персонаж машет рукой, когда закончил говорить
        });
      }
    }

    // Запускаем процесс печати
    typeNextChar();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _mascotAnimationController.dispose();
    _progressAnimationController.dispose();

    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Play button click sound effect
  Future<void> _playClickSound() async {
    try {
      // Haptic feedback for tactile response
      HapticFeedback.lightImpact();

      // Play a pleasant UI sound effect
      // We'll use a system sound or create a custom one
      await _playUISound();
    } catch (e) {
      // Fallback to just haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  // Play UI sound effect
  Future<void> _playUISound() async {
    try {
      SystemSound.play(SystemSoundType.click);

      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {}
  }

  void _nextStep() {
    if (_currentStep < 1) {
      soundService.stopAudio();
    }

    _playRiveAnimation('celebrate');

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
        _isJumping = true;
      });

      // Animate progress
      _progressAnimationController.reset();
      _progressAnimationController.forward();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
      _animationController.reset();
      _animationController.forward();

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isJumping = false;
          });
        }
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _triggerWaveAnimation();
          _speakStepText();
        }
      });
    } else {
      if (_currentStep == 2 && _formKeys[2].currentState?.validate() == true) {
        _register();
      } else {
        _register();
      }
    }
  }

  void _speakStepText() {
    // Метод для будущей реализации озвучивания текста шага
    // Сейчас используется как заглушка для будущего функционала
  }

  Future<void> _register() async {
    _playRiveAnimation('celebrate');

    if (_currentStep > 0 &&
        _currentStep < _formKeys.length &&
        _formKeys[_currentStep].currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Clear all existing data in SharedPreferences first
      await prefs.clear();

      // Now set the new user data
      await prefs.setString('username', _usernameController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());

      // Convert _selectedAgeOption to actual age value and save it
      int userAge;
      switch (_selectedAgeOption) {
        case 0:
          userAge = 5; // 4-5 years
          break;
        case 1:
          userAge = 7; // 6-9 years
          break;
        case 2:
          userAge = 12; // 9-14 years
          break;
        default:
          userAge = 5; // Default age if not selected
      }

      // Save the user age to SharedPreferences
      await prefs.setInt('userAge', userAge);

      await Future.delayed(const Duration(seconds: 2));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoadingPage()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Қате орын алды: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Build sparkle effect for decorative purposes
  Widget _buildSparkle(int index) {
    final colors = [
      const Color(0xFFFCD34D), // Yellow
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF8B5CF6), // Purple
    ];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final rotation =
            (_animationController.value * 2 * pi) + (index * pi / 3);
        return Transform.rotate(
          angle: rotation,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.star,
                size: 8,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _stepGradients[_currentStep],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Duolingo progress bar
              _buildCustomAppBar(),

              // Step content with beautiful card design
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Column(
                      children: [
                        // Header with character and title - moved inside
                        _buildHeader(),

                        // Page content
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildWelcomeStep(),
                              _buildPersonalInfoStep(),
                              _buildContactInfoStep(),
                            ],
                          ),
                        ),

                        // Navigation buttons with enhanced design
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimationController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentStep + 1) / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0), // Темно-синий цвет
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ), // Добавляем пространство справа
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Простой заголовок без лишних элементов
          Text(
            _getStepTitle(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _stepColors[_currentStep],
            ),
          ),
        ],
      ),
    );
  }

  // Speech bubble message widget
  Widget _buildBubbleMessage(String message, bool isLarge) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Add subtle bounce animation
        final bounce = sin(_animationController.value * pi * 2) * 3;

        return Transform.translate(
          offset: Offset(0, bounce),
          child: Stack(
            children: [
              // Speech bubble
              Container(
                margin: EdgeInsets.only(
                  left: isLarge ? 0 : 12,
                  bottom: 15,
                ),
                padding: EdgeInsets.all(isLarge ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message,
                  key: ValueKey(message),
                  style: TextStyle(
                    fontSize: isLarge ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: _stepColors[_currentStep],
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Қош келдің, балақай!';
      case 1:
        return 'Сенің жасын қаншада?';
      case 2:
        return 'Сенің атың кім?';
      default:
        return '';
    }
  }

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large character with enhanced animations and decorations
            Hero(
              tag: 'main_character',
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  // Более выразительная анимация "плавания"
                  final float = sin(_animationController.value * 2 * pi) * 8;
                  // Легкий наклон из стороны в сторону
                  final tilt =
                      sin(_animationController.value * 1.5 * pi) * 0.05;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Декоративные круги позади персонажа
                      Positioned(
                        right: 30,
                        top: 20,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _stepColors[_currentStep].withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      Positioned(
                        left: 20,
                        bottom: 10,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _stepColors[_currentStep].withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Анимированный персонаж
                      Transform.translate(
                        offset: Offset(0, float),
                        child: Transform.rotate(
                          angle: tilt,
                          child: Transform.scale(
                            scale: 1.0 +
                                (sin(_animationController.value * 2 * pi) *
                                    0.03),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: Image.asset(
                                  'assets/images/character.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Typing animation in a speech bubble
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Добавим эффект покачивания для пузырька сообщения
                final bounce = sin(_animationController.value * pi * 1.5) * 5;

                return Transform.translate(
                  offset: Offset(0, bounce),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _stepColors[_currentStep].withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Typing animation text with enhanced visual effects
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _stepColors[_currentStep],
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: _displayedText,
                                  ),
                                  // Мигающий курсор в конце текста
                                  WidgetSpan(
                                    child: AnimatedOpacity(
                                      opacity: sin(_animationController.value *
                                                  pi *
                                                  8) >
                                              0
                                          ? 1.0
                                          : 0.0,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 2, bottom: 2),
                                        height: 18,
                                        width: 2,
                                        color: _stepColors[_currentStep],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Form(
          key: _formKeys[1],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Age options with minimal design
                _buildAgeOption('4-5 жас аралығы', IconlyLight.heart, 0),
                const SizedBox(height: 8),
                _buildAgeOption('6-9 жас аралығы', IconlyLight.game, 1),
                const SizedBox(height: 8),
                _buildAgeOption('9-14 жас аралығы', IconlyLight.home, 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Form(
          key: _formKeys[2],
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Username field with minimalist design
                _buildMinimalTextField(
                  label: 'Пайдаланушы аты',
                  controller: _usernameController,
                  hint: 'Мысалы: Айдос123',
                  icon: IconlyLight.profile,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пайдаланушы атын енгізіңіз';
                    }
                    if (value.length < 3) {
                      return 'Пайдаланушы аты кемінде 3 таңбадан тұруы керек';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Minimalist text field design
  Widget _buildMinimalTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clean label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Minimalist input field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: suffixIcon,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.grey[500],
                  size: 18,
                ),
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              _playClickSound(); // Add sound effect when tapping input
            },
          ),
        ),
      ],
    );
  }

  // AnimatedButton Widget
  Widget _build3DPushableButton() {
    return SizedBox(
      height: 60,
      child: AnimatedButton(
        width: MediaQuery.of(context).size.width / 1.2,
        height: 60.0,
        onPressed: _isLoading
            ? () {}
            : () {
                _playClickSound();
                _nextStep();
              },
        color: _stepColors[_currentStep],
        shadowDegree: ShadowDegree.light,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ЖАЛҒАСТЫРУ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3D Pushable Button
          _build3DPushableButton(),
        ],
      ),
    );
  }

  Widget _buildAgeOption(String label, IconData icon, int index) {
    bool isSelected = _selectedAgeOption == index;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Pulse animation when selected
        double scale = isSelected
            ? 1.0 + (sin(_animationController.value * 4 * pi) * 0.02)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _playClickSound(); // Add sound effect
                  setState(() {
                    _selectedAgeOption = index;
                  });
                  _triggerJumpAnimation();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _stepColors[_currentStep].withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? _stepColors[_currentStep]
                          : Colors.grey.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Minimal icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _stepColors[_currentStep]
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Compact text
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? _stepColors[_currentStep]
                                : Colors.grey[700],
                          ),
                        ),
                      ),

                      // Simple check indicator
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _stepColors[_currentStep],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.check_mark,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
