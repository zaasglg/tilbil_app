import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'package:animated_button/animated_button.dart';
import '../services/language_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _button3DAnimation;
  bool _isButtonPressed = false;

  String _selectedLanguage = 'kz';

  // Light blue color palette for consistent design
  static const Color _primaryLightBlue = Color(0xFF87CEEB); // Sky blue
  static const Color _secondaryLightBlue = Color(0xFFADD8E6); // Light blue
  static const Color _accentLightBlue = Color(0xFF6BB6FF); // Bright light blue
  static const Color _backgroundLightBlue = Color(0xFFF0F8FF); // Alice blue
  static const Color _textLightBlue = Color(0xFF4682B4); // Steel blue

  final List<LanguageOption> _languages = [
    LanguageOption(
      code: 'kk',
      name: 'Kazakh',
      nativeName: 'Қазақша',
      flag: '🇰🇿',
      color: _accentLightBlue,
      icon: SvgPicture.asset(
        'assets/icons/kz_flag.svg',
        width: 32,
        height: 32,
      ),
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
      color: _primaryLightBlue,
      icon: SvgPicture.asset(
        'assets/icons/us_flag.svg',
        width: 32,
        height: 32,
      ),
    ),
    LanguageOption(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
      color: _secondaryLightBlue,
      icon: SvgPicture.asset(
        'assets/icons/ru_flag.svg',
        width: 32,
        height: 32,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _initializeAnimations();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'kz';
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _button3DAnimation = Tween<double>(
      begin: 8.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _onLanguageSelected(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Сохраняем выбранный язык
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);

    // Обновляем язык в LanguageService
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    await languageService.setLanguage(Locale(languageCode));
  }

  Future<void> _onConfirmPressed() async {
    // Переходим на onboarding экран
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _backgroundLightBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: SvgPicture.asset(
                  'assets/icons/logo_blue.svg',
                  height: 50,
                ),
              ),

              const SizedBox(height: 60),

              // Title and description
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        localizations.selectLanguage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.chooseLanguageDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: _textLightBlue,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Language options
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ListView.builder(
                      itemCount: _languages.length,
                      itemBuilder: (context, index) {
                        final language = _languages[index];
                        final isSelected = language.code == _selectedLanguage;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _onLanguageSelected(language.code),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _primaryLightBlue.withOpacity(0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color:
                                            _primaryLightBlue.withOpacity(0.3),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Flag icon - simplified
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _primaryLightBlue.withOpacity(0.15)
                                          : _backgroundLightBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: language.icon,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Language names - simplified typography
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          language.nativeName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? _textLightBlue
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          language.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection indicator - minimalistic
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _primaryLightBlue
                                          : Colors.transparent,
                                      border: isSelected
                                          ? null
                                          : Border.all(
                                              color: Colors.black26,
                                              width: 1.5,
                                            ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Confirm button - AnimatedButton
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedButton(
                    onPressed: _onConfirmPressed,
                    color: _primaryLightBlue,
                    height: 60,
                    width: MediaQuery.of(context).size.width / 1.2,
                    shadowDegree: ShadowDegree.dark,
                    child: Center(
                      child: Text(
                        localizations.confirmLanguage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final Color color;
  final SvgPicture? icon;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.color,
    this.icon,
  });
}
