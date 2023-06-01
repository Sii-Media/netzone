import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class ChatBottomSheet extends StatelessWidget {
  const ChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 8,
            ),
            child: Icon(
              Icons.add,
              color: AppColor.backgroundColor,
              size: 30,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: Icon(
              Icons.emoji_emotions_outlined,
              color: AppColor.backgroundColor,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              alignment: Alignment.centerRight,
              width: 250.w,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Type Something',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Icon(
              Icons.send,
              color: AppColor.backgroundColor,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
