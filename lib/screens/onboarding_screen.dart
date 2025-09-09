import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';
import '../l10n/app_localizations.dart';
import 'package:animated_button/animated_button.dart';
import '../auth/auth_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final AuthService _authService = AuthService();

  List<OnboardingContent> _getLocalizedPages(AppLocalizations localizations) {
    return [
      OnboardingContent(
        title: localizations.learnKazakhFree,
        description: localizations.joinMillions,
        backgroundColor: const Color(0xFF58CC02),
        secondaryColor: const Color(0xFF89E219),
        textColor: const Color(0xFF2B2D42),
        icon: HeroIcons.academicCap,
        iconBackgroundColor: const Color(0xFF4ADE80),
      ),
      OnboardingContent(
        title: localizations.learnAtYourPace,
        description: localizations.personalizedLessons,
        backgroundColor: const Color(0xFF1CB0F6),
        secondaryColor: const Color(0xFF84D8FF),
        textColor: const Color(0xFF2B2D42),
        icon: HeroIcons.clock,
        iconBackgroundColor: const Color(0xFF60A5FA),
      ),
      OnboardingContent(
        title: localizations.practiceDaily,
        description: localizations.tenMinutesDaily,
        backgroundColor: const Color(0xFFFF9600),
        secondaryColor: const Color(0xFFFFB800),
        textColor: const Color(0xFF2B2D42),
        icon: HeroIcons.fire,
        iconBackgroundColor: const Color(0xFFFB923C),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _initializeAnimations();
  }

  Future<void> _checkAuthStatus() async {
    // Проверяем авторизацию при загрузке экрана
    // await _authService.initialize();
    
    if (_authService.isAuthenticated) {
      // Если пользователь уже авторизован, переходим на главный экран
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      });
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _onNextPressed(List<OnboardingContent> pages) async {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Инициализируем AuthService и проверяем авторизацию
      // await _authService.initialize();

      if (_authService.isAuthenticated) {
        // Пользователь уже авторизован - переходим на главный экран
        if (mounted) Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Пользователь не авторизован - переходим на логин
        if (mounted) Navigator.pushReplacementNamed(context, '/register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final pages = _getLocalizedPages(localizations);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF), // Alice blue - светло-синий фон
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo_blue.svg',
                    height: 35,
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    content: pages[index],
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? pages[_currentPage].backgroundColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action button - AnimatedButton
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      key: ValueKey('button_$_currentPage'),
                      height: 60,
                      child: AnimatedButton(
                        onPressed: () => _onNextPressed(pages),
                        color: pages[_currentPage].backgroundColor,
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 60,
                        shadowDegree: ShadowDegree.light,
                        child: Text(
                          _currentPage < pages.length - 1
                              ? localizations.continueButton
                              : localizations.startLearning,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
}

class OnboardingContent {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color secondaryColor;
  final Color textColor;
  final HeroIcons icon;
  final Color iconBackgroundColor;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.secondaryColor,
    required this.textColor,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const OnboardingPage({
    super.key,
    required this.content,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Illustration
          Expanded(
            flex: 3,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          content.iconBackgroundColor,
                          content.iconBackgroundColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: HeroIcon(
                      content.icon,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content section
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: content.textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Text(
                      content.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: content.textColor.withOpacity(0.7),
                        fontSize: 16,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
