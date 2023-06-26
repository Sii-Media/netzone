import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/start_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      // splash: Lottie.asset('assets/images/Final_Intro.mp4.lottie.json'),
      splash: Image.asset(
        "assets/images/logo.png",
        width: 400.w,
        height: 400.h,
        fit: BoxFit.cover,
      ),
      backgroundColor: AppColor.backgroundColor,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
      splashIconSize: 450,
      // duration: 1000,
      nextScreen: const StartScreen(),
    );
  }
}
