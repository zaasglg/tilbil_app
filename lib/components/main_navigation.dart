import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            'assets/icons/BookOpenText.svg',
            'Учиться',
            0,
          ),
          _buildNavItem(
            context,
            'assets/icons/Binoculars.svg',
            'Поиск',
            1,
          ),
          _buildNavItem(
            context,
            'assets/icons/Trophy.svg',
            'Достижение',
            2,
          ),
          _buildNavItem(
            context,
            'assets/icons/UserCircle.svg',
            'Профиль',
            3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String iconPath,
    String label,
    int index,
  ) {
    final bool isSelected = currentIndex == index;
    final Color activeColor = Theme.of(context).primaryColor;
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
                height: isSelected ? 30 : 28,
                width: isSelected ? 30 : 28,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected ? activeColor : inactiveColor,
                    BlendMode.srcIn,
                  ),
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
