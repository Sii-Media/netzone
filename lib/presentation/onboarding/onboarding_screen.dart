import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/onboarding/first_intro_page.dart';
import 'package:netzoon/presentation/onboarding/second_intro_page.dart';
import 'package:netzoon/presentation/onboarding/third_intro_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  final bool fromMore;
  const OnBoardingScreen({super.key, this.fromMore = false});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (value) {
            setState(() {
              onLastPage = (value == 2);
            });
          },
          children: const [
            FirstIntroPage(),
            SecondIntroPage(),
            ThirdIntroPage(),
          ],
        ),
        Container(
          alignment: Alignment(0, 0.80.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.fromMore
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        while (context.canPop()) {
                          context.pop();
                        }
                        context.pushReplacement('/start');
                      },
                      child: const Text('Skip'),
                    ),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
              ),
              onLastPage
                  ? widget.fromMore
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            while (context.canPop()) {
                              context.pop();
                            }
                            context.pushReplacement('/start');
                          },
                          child: const Text('Done'))
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: const Text('Next')),
            ],
          ),
        ),
      ],
    ));
  }
}
