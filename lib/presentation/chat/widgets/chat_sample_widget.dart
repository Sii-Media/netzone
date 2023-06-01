import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';

class ChatSample extends StatelessWidget {
  const ChatSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 80,
          ),
          child: ClipPath(
            clipper: UpperNipMessageClipper(MessageType.receive),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE1E1E2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12:40',
                    style: TextStyle(
                      color: AppColor.secondGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'Hi Developer, How are you?!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 80,
            ),
            child: ClipPath(
              clipper: LowerNipMessageClipper(MessageType.send),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 10,
                  bottom: 25,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  color: AppColor.backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '12:40',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      'Hi Programmer, I am fine, Thanks for asking, What about you ?!, I hope you will be fine',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
