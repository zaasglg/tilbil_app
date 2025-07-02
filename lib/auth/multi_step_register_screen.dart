import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' as rive;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_page.dart';

class MultiStepRegisterScreen extends StatefulWidget {
  const MultiStepRegisterScreen({super.key});

  @override
  State<MultiStepRegisterScreen> createState() =>
      _MultiStepRegisterScreenState();
}

class _MultiStepRegisterScreenState extends State<MultiStepRegisterScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _authService = AuthService();

  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Form keys for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Welcome step (no form)
    GlobalKey<FormState>(), // Age selection
    GlobalKey<FormState>(), // Username
  ];

  int _currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String _selectedGender = 'male';
  DateTime? _selectedBirthday;
  int _selectedAgeOption = -1; // Track which age option is selected

  // Mascot animation states
  bool _isWaving = false;
  bool _isJumping = false;
  bool _isSpinning = false;

  // Beautiful gradient colors for each step - Light Blue Theme
  final List<List<Color>> _stepGradients = [
    [const Color(0xFF87CEEB), const Color(0xFF4FC3F7)], // Welcome - Light Blue gradient
    [const Color(0xFF81D4FA), const Color(0xFF4FC3F7)], // Age - Light Blue gradient
    [const Color(0xFF64B5F6), const Color(0xFF42A5F5)], // Username - Medium Blue gradient
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
  late AnimationController _typingAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  
  String _displayedText = '';
  final String _fullText = 'Қош келдіңіз, ойыныңызды бастау үшін "Жалғастыру" түймесін басыңыз!';
  Timer? _typingTimer;
  


  // Rive Animation Controllers
  rive.Artboard? _riveArtboard;
  rive.RiveAnimationController? _idleController;
  rive.RiveAnimationController? _waveController;
  rive.RiveAnimationController? _jumpController;
  rive.RiveAnimationController? _celebrateController;
  rive.RiveAnimationController? _thinkController;

  bool _isRiveLoaded = false;

  // Audio player for sound effects
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    


    // Initialize Rive animation
    _loadRiveAnimation();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _mascotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
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

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _progressAnimationController.forward();
    _triggerWaveAnimation();
    _startTypingAnimation();
  }

  // Load Rive animation
  Future<void> _loadRiveAnimation() async {
    try {
      final file = await rive.RiveFile.asset('assets/rive/character_animations.riv');
      final artboard = file.mainArtboard.instance();

      // Initialize animation controllers
      _idleController = rive.SimpleAnimation('idle');
      _waveController = rive.SimpleAnimation('wave');
      _jumpController = rive.SimpleAnimation('jump');
      _celebrateController = rive.SimpleAnimation('celebrate');
      _thinkController = rive.SimpleAnimation('think');


      // Add idle animation by default
      artboard.addController(_idleController!);

      setState(() {
        _riveArtboard = artboard;
        _isRiveLoaded = true;
      });
    } catch (e) {
      print('Error loading Rive animation: $e');
      // Fallback to static image if Rive fails
      setState(() {
        _isRiveLoaded = false;
      });
    }
  }

  // Play specific Rive animation
  void _playRiveAnimation(String animationName) {
    if (!_isRiveLoaded || _riveArtboard == null) return;
    
    // Remove current animation
    _riveArtboard!.removeController(_idleController!);
    _riveArtboard!.removeController(_waveController!);
    _riveArtboard!.removeController(_jumpController!);
    _riveArtboard!.removeController(_celebrateController!);
    _riveArtboard!.removeController(_thinkController!);

    
    // Add new animation
    switch (animationName) {
      case 'wave':
        _riveArtboard!.addController(_waveController!);
        Future.delayed(const Duration(seconds: 2), () {
          if (_riveArtboard != null) {
            _riveArtboard!.removeController(_waveController!);
            _riveArtboard!.addController(_idleController!);
          }
        });
        break;
      case 'jump':
        _riveArtboard!.addController(_jumpController!);
        Future.delayed(const Duration(milliseconds: 600), () {
          if (_riveArtboard != null) {
            _riveArtboard!.removeController(_jumpController!);
            _riveArtboard!.addController(_idleController!);
          }
        });
        break;
      case 'celebrate':
        _riveArtboard!.addController(_celebrateController!);
        Future.delayed(const Duration(seconds: 3), () {
          if (_riveArtboard != null) {
            _riveArtboard!.removeController(_celebrateController!);
            _riveArtboard!.addController(_idleController!);
          }
        });
        break;
      case 'think':
        _riveArtboard!.addController(_thinkController!);
        Future.delayed(const Duration(seconds: 2), () {
          if (_riveArtboard != null) {
            _riveArtboard!.removeController(_thinkController!);
            _riveArtboard!.addController(_idleController!);
          }
        });
        break;

      case 'idle':
      default:
        _riveArtboard!.addController(_idleController!);
        break;
    }
  }



  // Process text for authentic Kazakh pronunciation
  String _processKazakhAccent(String text) {
    String processedText = text;
    
    // Add natural pauses for more authentic speech rhythm
    processedText = processedText.replaceAll(',', '... ');
    processedText = processedText.replaceAll('.', '... ');
    processedText = processedText.replaceAll('!', '! ');
    processedText = processedText.replaceAll('?', '? ');
    
    // Replace Kazakh-specific letters with phonetically similar alternatives for better TTS
    processedText = processedText.replaceAll('ә', 'а');
    processedText = processedText.replaceAll('��', 'о');
    processedText = processedText.replaceAll('ү', 'у');
    processedText = processedText.replaceAll('ұ', 'у');
    processedText = processedText.replaceAll('і', 'и');
    processedText = processedText.replaceAll('ң', 'н');
    processedText = processedText.replaceAll('ғ', 'г');
    processedText = processedText.replaceAll('қ', 'к');
    processedText = processedText.replaceAll('һ', 'х');
    
    // Add emphasis to important words
    processedText = processedText.replaceAll('Қош келдіңіз', 'Қоош келдіңіз');
    processedText = processedText.replaceAll('Жалғастыру', 'Жалғаастыру');
    
    return processedText;
  }





  void _triggerWaveAnimation() {
    _playRiveAnimation('wave');
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
    _playRiveAnimation('jump');
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

  void _triggerSpinAnimation() {
    _playRiveAnimation('think');
    setState(() {
      _isSpinning = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSpinning = false;
        });
      }
    });
  }

  void _startTypingAnimation() {
    _displayedText = '';
    int charIndex = 0;
    
    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[charIndex];
        });
        charIndex++;
      } else {
        timer.cancel();

      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _mascotAnimationController.dispose();
    _typingAnimationController.dispose();
    _progressAnimationController.dispose();
    _typingTimer?.cancel();


    // Dispose Rive controllers
    _idleController?.dispose();
    _waveController?.dispose();
    _jumpController?.dispose();
    _celebrateController?.dispose();
    _thinkController?.dispose();

    
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _audioPlayer.dispose();
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
      // Play system click sound - this works on all platforms
      SystemSound.play(SystemSoundType.click);

      // Add a slight delay for better user experience
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      // Fallback - just continue without sound
      print('Could not play sound: $e');
    }
  }

  void _nextStep() {
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
    String textToSpeak = '';
    switch (_currentStep) {
      case 1:
        textToSpeak = 'Баланың жасын таңдаңыз';
        break;
      case 2:
        textToSpeak = 'Ойында сізді қалай атайды? Керемет ат ойлап табыңыз!';
        break;
    }
    

  }

  void _previousStep() {
    
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
      _animationController.reset();
      _animationController.forward();
      

    }
  }

  Future<void> _register() async {
    _playRiveAnimation('celebrate');
    
    if (_currentStep > 0 && _currentStep < _formKeys.length && 
        _formKeys[_currentStep].currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

              // Header with character and title
              _buildHeader(),

              // Step content with beautiful card design
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Column(
                      children: [
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Minimal back button
          IconButton(
            icon: const Icon(
              IconlyLight.arrowLeft2,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              if (_currentStep > 0) {
                _previousStep();
              } else {
                Navigator.maybePop(context);
              }
            },
          ),

          const SizedBox(width: 12),

          // Duolingo-style progress bar
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimationController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentStep + 1) / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF58CC02), // Duolingo green
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Simple step counter
          Text(
            '${_currentStep + 1}/3',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: _currentStep == 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact title for first step
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _getStepTitle(),
                  key: ValueKey(_currentStep),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Compact subtitle for first step
              Text(
                _getStepSubtitle(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.2,
                ),
              ),
            ],
          )
        : Row(
            children: [
              // Smaller character avatar for steps after first
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _isRiveLoaded && _riveArtboard != null
                      ? rive.Rive(artboard: _riveArtboard!)
                      : Image.asset(
                          'assets/images/character.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Compact title and subtitle for other steps
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _getStepTitle(),
                        key: ValueKey(_currentStep),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getStepSubtitle(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }



  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Қош келдіңіз!';
      case 1:
        return 'Жас таңдау';
      case 2:
        return 'Пайдаланушы аты';
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Оқу сапарыңызды бастайық';
      case 1:
        return 'Баланың жасын таңдаңыз';
      case 2:
        return 'Ойында сізді қалай атайды?';
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
          // Large character with enhanced animations
          Hero(
              tag: 'main_character',
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, sin(_animationController.value * 2 * pi) * 8),
                    child: Transform.scale(
                      scale: 1.0 + (sin(_animationController.value * 2 * pi) * 0.02),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.identity()..scale(1.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [


                            // Min charactear container
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: _isRiveLoaded && _riveArtboard != null
                                    ? rive.Rive(artboard: _riveArtboard!)
                                    : Image.asset(
                                        'assets/images/character.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          const SizedBox(height: 40),
          
          // Typing animation text with beautiful styling
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _stepColors[_currentStep].withOpacity(0.1),
                width: 1,
              ),
            ),
            child: AnimatedBuilder(
              animation: _typingAnimationController,
              builder: (context, child) {
                return Text(
                  _displayedText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                );
              },
            ),
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
                _buildAgeOption('4 жастан кіші', IconlyLight.heart, 0),
                const SizedBox(height: 8),
                _buildAgeOption('Мектепке дейінгі, 4-5 жас', IconlyLight.game, 1),
                const SizedBox(height: 8),
                _buildAgeOption('Мектепке дейінгі, 6-7 жас', IconlyLight.home, 2),
                const SizedBox(height: 8),
                _buildAgeOption('Мектеп оқушысы, 1 сынып', IconlyLight.document, 3),
                const SizedBox(height: 8),
                _buildAgeOption('Мектеп оқушысы, 2 сынып', IconlyLight.bookmark, 4),
                
                const SizedBox(height: 40),
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

                // Step header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        IconlyLight.profile,
                        color: Colors.blue[600],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Пайдаланушы ақпараты',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ойында сізді қалай атайды?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

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
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  // Simple Button Widget
  Widget _build3DPushableButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _stepGradients[_currentStep],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _stepColors[_currentStep].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () {
          _playClickSound();
          _nextStep();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ЖАЛҒАСТЫРУ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      IconlyLight.arrowRight2,
                      color: Colors.white,
                      size: 16,
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

          const SizedBox(height: 16),

          // Login link with beautiful design
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Аккаунтыңыз бар ма? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: 'Кіру',
                      style: TextStyle(
                        color: _stepColors[_currentStep],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        double scale = isSelected ? 1.0 + (sin(_animationController.value * 4 * pi) * 0.02) : 1.0;

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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[600],
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
                          child: const Icon(
                            IconlyBold.tickSquare,
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