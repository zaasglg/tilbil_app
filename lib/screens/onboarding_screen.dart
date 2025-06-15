import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';

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
  late AnimationController _buttonAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Изучайте казахский язык бесплатно!',
      description: 'Присоединяйтесь к миллионам людей, изучающих языки с нами',
      backgroundColor: const Color(0xFF58CC02),
      secondaryColor: const Color(0xFF89E219),
      textColor: const Color(0xFF2B2D42),
      icon: HeroIcons.academicCap,
      iconBackgroundColor: const Color(0xFF4ADE80),
    ),
    OnboardingContent(
      title: 'Учитесь в удобном темпе',
      description: 'Персонализированные уроки, которые адаптируются под ваш график',
      backgroundColor: const Color(0xFF1CB0F6),
      secondaryColor: const Color(0xFF84D8FF),
      textColor: const Color(0xFF2B2D42),
      icon: HeroIcons.clock,
      iconBackgroundColor: const Color(0xFF60A5FA),
    ),
    OnboardingContent(
      title: 'Практикуйтесь каждый день',
      description: 'Всего 10 минут в день помогут вам освоить новый язык',
      backgroundColor: const Color(0xFFFF9600),
      secondaryColor: const Color(0xFFFFB800),
      textColor: const Color(0xFF2B2D42),
      icon: HeroIcons.fire,
      iconBackgroundColor: const Color(0xFFFB923C),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _onNextPressed() async {
    // Button press animation
    await _buttonAnimationController.forward();
    _buttonAnimationController.reverse();
    
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the main screen
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              _pages[_currentPage].backgroundColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating decorative circles
            _buildFloatingCircles(),
            
            SafeArea(
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
                        if (_currentPage < _pages.length - 1)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/main');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Пропустить',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Main content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          content: _pages[index],
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
                      children: [
                        // Progress indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              height: 8,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? _pages[_currentPage].backgroundColor
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action button
                        ScaleTransition(
                          scale: _buttonScaleAnimation,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _pages[_currentPage].backgroundColor,
                                  _pages[_currentPage].secondaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _pages[_currentPage].backgroundColor
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _onNextPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _currentPage < _pages.length - 1
                                    ? 'Продолжить'
                                    : 'Начать обучение',
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
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircles() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Large circle - top right
          Positioned(
            top: -50,
            right: -50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _pages[_currentPage].backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Medium circle - middle left
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: -30,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _pages[_currentPage].secondaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Small circle - bottom left
          Positioned(
            bottom: 100,
            left: 50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _pages[_currentPage].backgroundColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Small circle - top left
          Positioned(
            top: 120,
            left: 30,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: _pages[_currentPage].secondaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
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
                      boxShadow: [
                        BoxShadow(
                          color: content.iconBackgroundColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
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
