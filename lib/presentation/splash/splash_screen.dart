import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/start_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/images/logo.png",
        width: 400,
        height: 400,
        fit: BoxFit.cover,
      ),
      backgroundColor: AppColor.backgroundColor,
      splashTransition: SplashTransition.slideTransition,
      animationDuration: const Duration(seconds: 2),
      nextScreen: const StartScreen(),
    );
  }
}
