import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../app_color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [AppColors.OliveMid, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: const SpinKitChasingDots(color: Colors.white, size: 40.0),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'جارٍ التحميل...',
            style: TextStyle(
              color: AppColors.OliveMid,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
