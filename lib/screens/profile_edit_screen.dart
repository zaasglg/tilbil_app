import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import '../auth/auth_service.dart';
import '../models/app_models.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _animation;

  late User? _user;
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Form formatters
  final MaskTextInputFormatter _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Form keys
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  // Mascot animation states
  bool _isWaving = false;
  bool _isJumping = false;
  bool _isSpinning = false;

  // Character colors for each step
  final List<Color> _characterColors = [
    const Color(0xFF58CC02), // Green for name (Duolingo primary)
    const Color(0xFFFFC800), // Yellow for age
    const Color(0xFF1CB0F6), // Blue for phone
    const Color(0xFFFF4B4B), // Red for password
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start with a welcoming wave animation
    _triggerWaveAnimation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    // _user = _authService.currentUser;

    if (_user != null) {
      _nameController.text = _user!.name;
      _birthdayController.text = _user!.birthday;
      _phoneController.text = _user!.phone;

      // Format phone with mask
      if (_user!.phone.isNotEmpty) {
        _phoneController.text = _phoneMaskFormatter.maskText(_user!.phone);
      }

      setState(() {});
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
        _isJumping = true; // Trigger jump animation
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      // Reset jump animation after a delay
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isJumping = false;
          });
        }
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context); // Exit if we're at the first step
    }
  }

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

  void _triggerSpinAnimation() {
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

  void _validateAndSaveStep() {
    switch (_currentStep) {
      case 0: // Name
        if (_nameFormKey.currentState?.validate() ?? false) {
          _nameFormKey.currentState?.save();
          _nextStep();
          _triggerWaveAnimation();
        }
        break;
      case 1: // Age/Birthday
        if (_ageFormKey.currentState?.validate() ?? false) {
          _ageFormKey.currentState?.save();
          _nextStep();
          _triggerWaveAnimation();
        }
        break;
      case 2: // Phone
        if (_phoneFormKey.currentState?.validate() ?? false) {
          _phoneFormKey.currentState?.save();
          _nextStep();
          _triggerWaveAnimation();
        }
        break;
      case 3: // Password
        if (_passwordFormKey.currentState?.validate() ?? false) {
          _passwordFormKey.currentState?.save();
          _saveAllChanges();
        }
        break;
    }
  }

  Future<void> _saveAllChanges() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: _characterColors[_currentStep],
        ),
      ),
    );

    // Here you would normally call your API to save changes
    // For demo purposes, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Pop the loading dialog
      Navigator.of(context).pop();

      // Show success dialog with celebration
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Ура! Всё готово! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF58CC02),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMascot(isSuccess: true),
              const SizedBox(height: 16),
              const Text(
                'Твой профиль успешно обновлен!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Return to profile screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Супер!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE082),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.deepOrange,
              size: 24,
            ),
          ),
          onPressed: _previousStep,
        ),
        title: Text(
          _getScreenTitle(),
          style: const TextStyle(
            color: Color(0xFF4B4B4B),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _buildProgressIndicator(),
          ),

          // Main content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameStep(),
                _buildAgeStep(),
                _buildPhoneStep(),
                _buildPasswordStep(),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildNextButton(),
          ),
        ],
      ),
    );
  }

  String _getScreenTitle() {
    switch (_currentStep) {
      case 0:
        return 'Изменить имя';
      case 1:
        return 'Изменить возраст';
      case 2:
        return 'Изменить телефон';
      case 3:
        return 'Изменить пароль';
      default:
        return 'Редактировать профиль';
    }
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          children: List.generate(
            _totalSteps,
            (index) => Expanded(
              child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _currentStep >= index
                      ? _characterColors[_currentStep]
                      : const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _currentStep == index
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 8,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Шаг ${_currentStep + 1} из $_totalSteps',
          style: TextStyle(
            color: _characterColors[_currentStep],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMascot({bool isSuccess = false}) {
    double size = isSuccess ? 120 : 100;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _characterColors[_currentStep].withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isJumping ? size * 1.1 : size * 0.8,
          height: _isJumping ? size * 1.1 : size * 0.8,
          transform: _isSpinning
              ? Matrix4.rotationZ(0.1)
              : (_isWaving ? Matrix4.rotationZ(-0.05) : Matrix4.rotationZ(0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                isSuccess ? Icons.emoji_events : Icons.face_rounded,
                size: size * 0.6,
                color: _characterColors[_currentStep],
              ),
              if (_isWaving)
                Positioned(
                  top: 10,
                  right: 5,
                  child: Icon(
                    Icons.waving_hand,
                    size: size * 0.3,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastStep = _currentStep == _totalSteps - 1;

    return ElevatedButton(
      onPressed: _validateAndSaveStep,
      style: ElevatedButton.styleFrom(
        backgroundColor: _characterColors[_currentStep],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 5,
        shadowColor: _characterColors[_currentStep].withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLastStep ? 'Сохранить' : 'Дальше',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isLastStep ? Icons.check_circle : Icons.arrow_forward_rounded,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // Step 1: Name editing
  Widget _buildNameStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _nameFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMascot(),
            const SizedBox(height: 24),

            // Fun instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF58CC02), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.edit_rounded,
                    color: Color(0xFF58CC02),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Как тебя зовут? Расскажи мне свое имя!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF58CC02),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name input
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Твое имя',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Напиши свое имя здесь',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFF58CC02).withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF58CC02),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF58CC02),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => _nameController.clear(),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста, введи свое имя';
                }
                if (value.trim().length < 2) {
                  return 'Имя должно содержать минимум 2 буквы';
                }
                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 24),

            // Fun fact about names
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Знаешь ли ты?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58CC02),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Твое имя уникально! Оно помогает твоим друзьям узнавать тебя в игре!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

  // Step 2: Age editing
  Widget _buildAgeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _ageFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMascot(),
            const SizedBox(height: 24),

            // Fun instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFC800), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cake_rounded,
                    color: Color(0xFFFFC800),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Сколько тебе лет? Расскажи мне о своем дне рождения!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Birthday input
            TextFormField(
              controller: _birthdayController,
              decoration: InputDecoration(
                labelText: 'Дата рождения',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'ГГГГ-ММ-ДД',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFFFFC800).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFC800),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.cake_rounded,
                  color: Color(0xFFFFC800),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 10)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFFFC800),
                              onPrimary: Colors.white,
                              onSurface: Color(0xFF4B4B4B),
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFFFFC800),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      _birthdayController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    }
                  },
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введи свою дату рождения';
                }

                try {
                  final date = DateTime.parse(value);
                  final now = DateTime.now();
                  final age = now.year -
                      date.year -
                      (now.month > date.month ||
                              (now.month == date.month && now.day >= date.day)
                          ? 0
                          : 1);

                  if (date.isAfter(now)) {
                    return 'Дата рождения не может быть в будущем';
                  }
                  if (age < 5) {
                    return 'Кажется, ты ещё слишком маленький!';
                  }
                  if (age > 120) {
                    return 'Ого! Проверь дату еще раз';
                  }
                } catch (e) {
                  return 'Неверный формат даты (ГГГГ-ММ-ДД)';
                }

                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 24),

            // Fun fact about birthdays
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Знаешь ли ты?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFC800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'В твой день рождения мы подготовим для тебя специальный сюрприз в игре!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

  // Step 3: Phone editing
  Widget _buildPhoneStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _phoneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMascot(),
            const SizedBox(height: 24),

            // Fun instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1CB0F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1CB0F6), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.phone_android_rounded,
                    color: Color(0xFF1CB0F6),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Какой у тебя номер телефона? Так мы сможем защитить твой аккаунт!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1CB0F6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Phone input
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Номер телефона',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: '+7 (777) 123-45-67',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFF1CB0F6).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF1CB0F6),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.phone_android_rounded,
                  color: Color(0xFF1CB0F6),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneMaskFormatter],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введи свой номер телефона';
                }

                // Check if phone format is complete
                if (!value.contains(')') || value.length < 18) {
                  return 'Введи полный номер телефона';
                }

                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 24),

            // Fun fact about phone security
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: Color(0xFF1CB0F6),
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Безопасность прежде всего!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1CB0F6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Твой телефон поможет защитить твой аккаунт. Мы отправим тебе код, если кто-то попытается войти в твой аккаунт.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

  // Step 4: Password editing
  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMascot(),
            const SizedBox(height: 24),

            // Fun instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4B4B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF4B4B), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFFFF4B4B),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Давай создадим новый секретный пароль! Он должен быть надежным!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF4B4B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current password
            TextFormField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Текущий пароль',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: '••••••••',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF4B4B).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF4B4B),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFFF4B4B),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility would go here
                    _triggerSpinAnimation();
                  },
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введи текущий пароль';
                }
                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 16),

            // New password
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: '••••••••',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF4B4B).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF4B4B),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFFFF4B4B),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility would go here
                    _triggerSpinAnimation();
                  },
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введи новый пароль';
                }
                if (value.length < 6) {
                  return 'Пароль должен содержать минимум 6 символов';
                }
                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 16),

            // Confirm password
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Подтверди пароль',
                labelStyle: const TextStyle(
                  color: Color(0xFF4B4B4B),
                  fontWeight: FontWeight.w500,
                ),
                hintText: '••••••••',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF4B4B).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF4B4B),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFFFF4B4B),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility would go here
                    _triggerSpinAnimation();
                  },
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, подтверди пароль';
                }
                if (value != _newPasswordController.text) {
                  return 'Пароли не совпадают';
                }
                return null;
              },
              onTap: _triggerWaveAnimation,
            ),

            const SizedBox(height: 24),

            // Password strength tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    color: Color(0xFFFF4B4B),
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Советы для безопасного пароля:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF4B4B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Используй не менее 6 символов\n'
                    '• Добавь цифры и специальные символы\n'
                    '• Не используй своё имя или дату рождения\n'
                    '• Используй разные пароли для разных сайтов',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
}
