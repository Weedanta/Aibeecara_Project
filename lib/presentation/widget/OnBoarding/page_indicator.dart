import 'package:flutter/material.dart';
import 'package:my_project/presentation/themes/color.dart';


class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final double dotSize;
  final double activeSize;
  final double spacing;
  final Color activeDotColor;
  final Color inactiveDotColor;

  const PageIndicator({
    Key? key,
    required this.pageCount,
    required this.currentPage,
    this.dotSize = 8.0,
    this.activeSize = 12.0,
    this.spacing = 8.0,
    this.activeDotColor = AppColors.primary,
    this.inactiveDotColor = AppColors.textLight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> dots = [];

    for (int i = 0; i < pageCount; i++) {
      bool isActive = i == currentPage;
      dots.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isActive ? activeSize : dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: isActive ? activeDotColor : inactiveDotColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}