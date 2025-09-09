import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// AnswerNotification widget from sound_hunters.dart
/// Usage: show this widget inside a Stack or overlay. Provide `isCorrect` and
/// `onContinue` callback.
class AnswerNotification extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onContinue;

  const AnswerNotification({
    super.key,
    required this.isCorrect,
    required this.onContinue,
  });

  @override
  State<AnswerNotification> createState() => _AnswerNotificationState();
}

class _AnswerNotificationState extends State<AnswerNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SlideTransition(
        position: _animation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              top: 40), // Space for the overflowing Lottie
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // This is the colored notification box
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.isCorrect
                      ? const Color(0xFF58CC02)
                      : const Color(0xFFFF4B4B),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.isCorrect
                                  ? 'Өте жақсы!'.toUpperCase()
                                  : 'Қате!'.toUpperCase(),
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 80), // Space for Lottie
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ChicletAnimatedButton(
                            width: double.infinity,
                            height: 60.0,
                            backgroundColor: Colors.white,
                            buttonColor: Colors.grey,
                            onPressed: widget.onContinue,
                            // borderRadius: BorderRadius.circular(24),
                            child: Center(
                              child: Text(
                                'Жалғастыру',
                                style: TextStyle(
                                  color: widget.isCorrect
                                      ? const Color(0xFF58CC02)
                                      : const Color(0xFFFF4B4B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
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
              // Positioned Lottie
              Positioned(
                right: 20,
                top: -40, // Half of height 80
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    widget.isCorrect
                        ? 'assets/lottie/correct.json'
                        : 'assets/lottie/incorrect.json',
                    width: 150,
                    height: 150,
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
