import 'package:flutter/material.dart';

class EmptyStateWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showAnimation;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = const Color(0xFF667eea),
    this.buttonText,
    this.onButtonPressed,
    this.showAnimation = true,
  }) : super(key: key);

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _floatingAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));

    if (widget.showAnimation) {
      _mainAnimationController.forward();
      _floatingAnimationController.repeat(reverse: true);
    } else {
      _mainAnimationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainAnimationController,
        _floatingAnimationController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32, bottom: 24),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated icon with floating effect
                    Transform.translate(
                      offset: Offset(0, -8 * _floatingAnimation.value),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.iconColor.withOpacity(0.1),
                              widget.iconColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.iconColor.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1a202c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Optional button
                    if (widget.buttonText != null &&
                        widget.onButtonPressed != null) ...[
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: widget.onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.iconColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.buttonText!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Specialized empty state widgets for different scenarios
class LevelsEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const LevelsEmptyState({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Деңгейлер дайындалып жатыр',
      subtitle: 'Жақында сізге қосымша деңгейлер қол жетімді болады',
      icon: Icons.auto_stories_outlined,
      iconColor: const Color(0xFF667eea),
      buttonText: onRefresh != null ? 'Жаңарту' : null,
      onButtonPressed: onRefresh,
    );
  }
}

class NetworkErrorEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorEmptyState({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Интернет қосылымы жоқ',
      subtitle: 'Интернет байланысын тексеріп, қайталап көріңіз',
      icon: Icons.wifi_off_outlined,
      iconColor: const Color(0xFFf5576c),
      buttonText: onRetry != null ? 'Қайталау' : null,
      onButtonPressed: onRetry,
    );
  }
}

class GeneralErrorEmptyState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const GeneralErrorEmptyState({
    Key? key,
    this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Бір нәрсе дұрыс болмады',
      subtitle: message ?? 'Қате пайда болды. Қайталап көріңіз',
      icon: Icons.error_outline,
      iconColor: const Color(0xFFfee140),
      buttonText: onRetry != null ? 'Қайталау' : null,
      onButtonPressed: onRetry,
    );
  }
}

class SearchEmptyState extends StatelessWidget {
  final String searchTerm;
  final VoidCallback? onClearSearch;

  const SearchEmptyState({
    Key? key,
    required this.searchTerm,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Нәтиже табылмады',
      subtitle: '"$searchTerm" бойынша ештеңе табылмады',
      icon: Icons.search_off_outlined,
      iconColor: const Color(0xFF38f9d7),
      buttonText: onClearSearch != null ? 'Іздеуді тазарту' : null,
      onButtonPressed: onClearSearch,
    );
  }
}
