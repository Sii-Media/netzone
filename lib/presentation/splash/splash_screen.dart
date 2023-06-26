import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/start_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = VideoPlayerController.asset(
      'assets/images/Final_intro_netzoon.mp4', // Update with your video file path
    );
    return AnimatedSplashScreen(
      // splash: Lottie.asset('assets/images/Final_Intro.mp4.lottie.json'),
      // splash: Image.asset(
      //   "assets/images/logo.png",
      //   width: 400.w,
      //   height: 400.h,
      //   fit: BoxFit.cover,
      // ),
      splash: Chewie(
        controller: ChewieController(
            videoPlayerController: videoPlayerController,
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: false,
            showControlsOnInitialize: false,
            showControls: false),
      ),
      backgroundColor: Color.fromARGB(255, 87, 121, 165),
      // splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 3),
      splashIconSize: 800,
      centered: true,
      // duration: 1000,
      nextScreen: const StartScreen(),
    );
  }
}
