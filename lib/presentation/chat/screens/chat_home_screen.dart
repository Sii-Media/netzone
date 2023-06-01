import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../widgets/recent_chats_widget.dart';
import 'contacts_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              child: Text(
                'Messages',
                style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.secondGrey.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 250.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: AppColor.backgroundColor,
                    ),
                  ],
                ),
              ),
            ),
            const RecentChats(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const ContactsScreen();
            }),
          );
        },
        backgroundColor: AppColor.backgroundColor,
        child: const Icon(
          Icons.message,
        ),
      ),
    );
  }
}
