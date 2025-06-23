import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/core/app_color.dart';

class GlowingGPSIcon extends StatefulWidget {
  final double size;
  const GlowingGPSIcon({super.key, this.size = 14});

  @override
  State<GlowingGPSIcon> createState() => _GlowingGPSIconState();
}

class _GlowingGPSIconState extends State<GlowingGPSIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Icon(
          Icons.gps_fixed,
          size: widget.size,
          color: AppColors.OliveGrove,
          shadows: [
            Shadow(
              color: AppColors.WhisperWhite.withOpacity(0.7),
              blurRadius: _glowAnimation.value,
            ),
          ],
        );
      },
    );
  }
}
