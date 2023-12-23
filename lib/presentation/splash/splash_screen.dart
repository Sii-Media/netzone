// import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:go_router/go_router.dart';
// import 'package:netzoon/presentation/start_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    _controller =
        VideoPlayerController.asset('assets/images/Final_intro_netzoon.mp4');
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(
            milliseconds: _controller.value.duration.inMilliseconds + 4000),
        () => context.go('/start'));
    // final videoPlayerController = VideoPlayerController.asset(
    //   'assets/images/Final_intro_netzoon.mp4', // Update with your video file path
    // );
    // return AnimatedSplashScreen.withScreenRouteFunction(
    //   splash: Chewie(
    //     controller: ChewieController(
    //       videoPlayerController: videoPlayerController,
    //       aspectRatio: 16 / 9,
    //       autoPlay: true,
    //       looping: false,
    //       showControlsOnInitialize: false,
    //       showControls: false,
    //     ),
    //   ),
    //   backgroundColor: const Color.fromARGB(255, 88, 120, 161),
    //   animationDuration: const Duration(seconds: 3),
    //   splashIconSize: 800,
    //   centered: true,
    //   duration: 3000,
    //   screenRouteFunction: () async {
    //     return 'start';
    //   },
    // );
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: const Color.fromARGB(255, 88, 120, 161),
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

enum SplashTransition {
  slideTransition,
  scaleTransition,
  rotationTransition,
  sizeTransition,
  fadeTransition,
  decoratedBoxTransition
}
