import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            HugeIcons.strokeRoundedBookOpen02,
            'Оқу',
            0,
            const Color(0xFF58CC02),
          ),
          _buildNavItem(
            context,
            HugeIcons.strokeRoundedMusicNote01,
            'Материалдар',
            1,
            const Color(0xFF1CB0F6),
          ),
          _buildNavItem(
            context,
            HugeIcons.strokeRoundedChampion,
            'Жетістік',
            2,
            const Color(0xFFFF9600),
          ),
          _buildNavItem(
            context,
            HugeIcons.strokeRoundedUser,
            'Кабинет',
            3,
            const Color(0xFFFF4B4B),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    Color iconColor,
  ) {
    final bool isSelected = currentIndex == index;
    final Color activeColor = iconColor;
    final Color inactiveColor = Colors.grey.shade400;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: activeColor.withOpacity(0.1),
        highlightColor: activeColor.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isSelected ? 32 : 28,
                width: isSelected ? 32 : 28,
                child: HugeIcon(
                  icon: icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: isSelected ? 28 : 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              // Indicator line
              // AnimatedContainer(
              //   duration: const Duration(milliseconds: 200),
              //   height: 2,
              //   width: isSelected ? 30 : 0,
              //   decoration: BoxDecoration(
              //     color: isSelected ? activeColor : Colors.transparent,
              //     borderRadius: BorderRadius.circular(1),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
