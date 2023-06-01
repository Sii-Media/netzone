import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import '../widgets/chat_bottom_sheet.dart';
import '../widgets/chat_sample_widget.dart';

class ChatPageScreen extends StatelessWidget {
  const ChatPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          leadingWidth: 30,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg',
                  height: 35.h,
                  width: 35.w,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Programmer',
                  style: TextStyle(
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.call,
                size: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.video_call,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 80,
          right: 20,
          left: 20,
        ),
        children: const [
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
        ],
      ),
      bottomSheet: const ChatBottomSheet(),
    );
  }
}
