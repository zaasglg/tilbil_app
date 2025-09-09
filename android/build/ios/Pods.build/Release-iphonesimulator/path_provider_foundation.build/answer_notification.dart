import 'package:flutter/material.dart';

/// Minimal, portable AnswerNotification widget adapted from sound_hunters.dart
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
    final color =
        widget.isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B);
    final title = widget.isCorrect ? 'Дұрыс!' : 'Қате';
    final subtitle = widget.isCorrect ? 'Жарайсың' : 'Қайталап көр';

    return SlideTransition(
      position: _animation,
      child: Container(
        padding: const EdgeInsets.only(top: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Notification box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(width: 60), // space for the Lottie
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: widget.onContinue,
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            // Lottie or icon
            Positioned(
              top: -20,
              left: 36,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.isCorrect ? Icons.check : Icons.close,
                    color: color,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
