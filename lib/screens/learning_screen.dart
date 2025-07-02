import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:til_bil_app/auth/loading_page.dart';
import '../services/language_service.dart';
import '../services/language_level_service.dart';
import '../models/language_level.dart';
import 'language_level_screen.dart';
import 'beginner_level_screen.dart'; // Import the BeginnerLevelScreen

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with TickerProviderStateMixin {
  final LanguageLevelService _languageLevelService = LanguageLevelService();
  List<LanguageLevel> _languageLevels = [];
  Map<String, double> _userProgress = {};
  bool _isLoading = true;
  String? _error;

  // Animation controllers
  late AnimationController _bounceController;
  late AnimationController _streakController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadLanguageLevels();
  }

  void _initializeAnimations() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _streakController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguageLevels() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load levels and user progress in parallel
      final results = await Future.wait([
        _languageLevelService.getLanguageLevels(),
        _languageLevelService.getUserLevelProgress(),
      ]);

      final levels = results[0] as List<LanguageLevel>;
      final progress = results[1] as Map<String, double>;

      setState(() {
        _languageLevels = levels;
        _userProgress = progress;
        _isLoading = false;
      });

      // Start animations after loading
      _bounceController.forward();
      _streakController.forward();
      _progressController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light, clean background
      appBar: _isLoading || _error != null ? null : _buildAppBar(),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _error != null
                ? _buildErrorState()
                : _buildMainContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated mascot placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          // Loading text
          const Text(
            '🌟 Оқу жолыңыз жүктелуде...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 24),
          // Animated progress indicator
          Container(
            width: 200,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error mascot
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF6B6B).withOpacity(0.1),
                    const Color(0xFFFF6B6B).withOpacity(0.2),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF6B6B).withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied_rounded,
                size: 60,
                color: Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '😔 Қате! Бірдеңе дұрыс болмады',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Retry button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _loadLanguageLevels,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Қайта көру',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 7),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Тіл Біл',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3748),
                fontFamily: "AtypDisplay",
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Language selector
        GestureDetector(
          onTap: () => _showLanguageSelector(context),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            child: Center(
              child: SvgPicture.asset(
                _getCurrentLanguageFlagAsset(context),
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Ensure these methods exist
  String _getCurrentLanguageFlagAsset(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    switch (languageService.currentLocale.languageCode) {
      case 'kk':
        return 'assets/icons/kz_flag.svg';
      case 'ru':
        return 'assets/icons/ru_flag.svg';
      case 'en':
      default:
        return 'assets/icons/us_flag.svg';
    }
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF718096).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Тілді таңдаңыз',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 20),
              // Language options
              _buildLanguageOption(context, 'kk', 'assets/icons/kz_flag.svg', 'Қазақша'),
              const SizedBox(height: 12),
              _buildLanguageOption(context, 'ru', 'assets/icons/ru_flag.svg', 'Орысша'),
              const SizedBox(height: 12),
              _buildLanguageOption(context, 'en', 'assets/icons/us_flag.svg', 'Ағылшынша'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageCode, String flagAsset, String name) {
    final languageService = Provider.of<LanguageService>(context);
    final isSelected = languageService.currentLocale.languageCode == languageCode;
    return GestureDetector(
      onTap: () async {
        await languageService.setLanguage(Locale(languageCode));
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3371B9).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3371B9) : const Color(0xFF718096).withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              flagAsset,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF3371B9) : const Color(0xFF2D3748),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF3371B9),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Learning Journey
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _progressAnimation.value,
                child: _buildLearningJourney(),
              );
            },
          ),
        ),
        // Progress Section
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - _progressAnimation.value)),
                child: _buildEnhancedProgressSection(),
              );
            },
          ),
        ),
        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildLearningJourney() {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final currentLanguageCode = languageService.currentLocale.languageCode;
    final levels = _languageLevels.where((level) => !level.isLocked).toList();
    final List<List<Color>> levelColors = [
      [const Color(0xFF4ECDC4), const Color(0xFF45B7D1)],
      [const Color(0xFFFFB020), const Color(0xFFFFDE59)],
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF3371B9), const Color(0xFF45B7D1)],
      [const Color(0xFF7F53AC), const Color(0xFF647DEE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
    ];
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Оқу жоспар',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Enhanced level cards
          if (levels.isNotEmpty)
            Column(
              children: List.generate(levels.length, (index) {
                final level = levels[index];
                final colors = levelColors[index % levelColors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildColorfulLevelCardNoIcon(level, currentLanguageCode, colors),
                );
              }),
            )
          else
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hourglass_empty_rounded, color: Color(0xFF45B7D1), size: 48),
                  SizedBox(height: 18),
                  Text(
                    'Қазіргі уақытта деңгейлер жоқ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorfulLevelCardNoIcon(LanguageLevel level, String languageCode, List<Color> colors) {
    final progress = _userProgress[level.code] ?? 0.0;
    return GestureDetector(
      onTap: () {
        if (level.getName(languageCode) == 'Бастапқы деңгей') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeginnerLevelScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageLevelScreen(level: level.code),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors[0].withOpacity(0.85),
              colors[1].withOpacity(0.80),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level.getName(languageCode),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              level.getDescription(languageCode),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.13),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(colors[0], colors[1], 0.5) ?? Colors.white,
                      ),
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedProgressSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Сіздің прогресс',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 24),
          // Progress cards
          _buildProgressCard(
            title: '🔤 Әліпби меңгеру',
            subtitle: 'Тамаша!',
            progress: 0.8,
            color: const Color(0xFF4ECDC4),
            encouragement: 'Аз қалды! 🌟',
          ),
          const SizedBox(height: 16),
          _buildProgressCard(
            title: '📚 Грамматика',
            subtitle: 'Жақсы жұмыс!',
            progress: 0.6,
            color: const Color(0xFFFF6B6B),
            encouragement: 'Сіз дамып жатырсыз! 💪',
          ),
          const SizedBox(height: 16),
          _buildProgressCard(
            title: '🗣️ Айтылым',
            subtitle: 'Керемет бастама!',
            progress: 0.4,
            color: const Color(0xFF45B7D1),
            encouragement: 'Жаттығуды жалғастырыңыз! 🎯',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
    required String encouragement,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Animated progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress * _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            encouragement,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌅 Қайырлы таң!';
    } else if (hour < 17) {
      return '☀️ Қайырлы күн!';
    } else {
      return '🌙 Қайырлы кеш!';
    }
  }

  IconData _getLevelIcon(String levelCode) {
    switch (levelCode.toUpperCase()) {
      case 'A1':
        return Icons.emoji_people_rounded;
      case 'A2':
        return Icons.menu_book_rounded;
      case 'B1':
        return Icons.chat_bubble_rounded;
      case 'B2':
        return Icons.school_rounded;
      case 'C1':
        return Icons.trending_up_rounded;
      case 'C2':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.lightbulb_rounded;
    }
  }
}
