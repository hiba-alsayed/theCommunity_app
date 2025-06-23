import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleContent;
  final double height;
  final List<Color> gradientColors;
  final BorderRadiusGeometry borderRadius;

  const GradientAppBar({
    super.key,
    this.titleContent,
    this.height = 60,
    this.gradientColors = const [Colors.black,  Color(0xFF00B4D8)],
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: borderRadius,
        ),
        child: Align(
          alignment: Alignment.center,
          child: titleContent ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
