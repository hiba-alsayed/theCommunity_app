import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import '../features/auth/presentation/pages/login_page.dart';



class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SplashContent(),
      nextScreen: LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: Colors.transparent,
      duration: 5000,
      splashIconSize: double.infinity,
    );
  }
}

class SplashContent extends StatefulWidget {
  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with TickerProviderStateMixin {
  late final AnimationController spinController;
  late final AnimationController slideController;
  late final Animation<Alignment> alignAnimation;

  @override
  void initState() {
    super.initState();
    final _audioPlayer = AudioPlayer();

    spinController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    alignAnimation = AlignmentTween(
      begin: Alignment.center,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(seconds: 2), () async {
      spinController.stop();
      await _audioPlayer.play(AssetSource('magic-spell.mp3'));
      slideController.forward();
    });
  }

  @override
  void dispose() {
    spinController.dispose();
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Text behind the logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "أثر",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    .animate(delay: 4000.ms)
                    .fadeIn(duration: 700.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOut),
                SizedBox(height: 10),
                Text(
                  "لأثرٍ يبقى...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                )
                    .animate(delay: 4200.ms)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 1, curve: Curves.easeOut),
              ],
            ),
          ),

          // Foreground spinning and sliding logo
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AnimatedBuilder(
              animation: alignAnimation,
              builder: (context, child) {
                return Align(
                  alignment: alignAnimation.value,
                  child: RotationTransition(
                    turns: spinController,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/athar_white.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}