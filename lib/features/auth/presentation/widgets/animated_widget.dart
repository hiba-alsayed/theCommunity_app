import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedCircleBackground extends StatefulWidget {
  const AnimatedCircleBackground({super.key});

  @override
  State<AnimatedCircleBackground> createState() => _AnimatedCircleBackgroundState();
}

class _AnimatedCircleBackgroundState extends State<AnimatedCircleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: const Offset(0.1, 0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Stack(
          children: [
            _buildCircle(offset: _animation.value, size: 100, opacity: 0.5),
            _buildCircle(offset: -_animation.value, size: 150, opacity: 0.5),
            _buildCircle(offset: _animation.value.scale(-1.2, 0.8), size: 50, opacity: 0.5),
          ],
        );
      },
    );
  }

  Widget _buildCircle({required Offset offset, required double size, required double opacity}) {
    return Positioned(
      left: MediaQuery.of(context).size.width * (0.5 + offset.dx) - size / 2,
      top: MediaQuery.of(context).size.height * (0.3 + offset.dy) - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFF0172B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}
