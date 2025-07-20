import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../core/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getTopLineColor(int index) {
      switch (index) {
        case 0:
          return AppColors.OceanBlue;
        case 1:
          return AppColors.SunsetOrange;
        case 2:
          return AppColors.MidGreen;
        case 3:
          return AppColors.RichBerry;
        case 4:
          return AppColors.CedarOlive;
        default:
          return AppColors.CedarOlive;
      }
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
      Positioned.fill(
      top: 0,
      child: CustomPaint(
        painter: TopLinePainter(
          color: getTopLineColor(currentIndex),
        ),
      ),
    ),
       SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: onTap,
        unselectedItemColor: AppColors.CharcoalGrey.withOpacity(0.5),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("الرئيسية"),
            selectedColor: AppColors.OceanBlue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.campaign),
            title: Text("الحملات"),
            selectedColor: AppColors.SunsetOrange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.lightbulb),
            title: Text("المبادرات"),
            selectedColor: AppColors.MidGreen,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.report_problem),
            title: Text("الشكاوى"),
            selectedColor: AppColors.RichBerry,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("حسابي"),
            selectedColor: AppColors.CedarOlive,
          ),
        ],
      ),]
    );
  }
}
class TopLinePainter extends CustomPainter {
  final Color color;

  TopLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.4),
          color.withOpacity(1.0),
          color.withOpacity(0.4),
          color.withOpacity(0.0),
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 1))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double y = 0.5;
    final path = Path()
      ..moveTo(0, y)
      ..lineTo(size.width, y);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}