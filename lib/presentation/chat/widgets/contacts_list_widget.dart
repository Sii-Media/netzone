import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../screens/chat_page_screen.dart';

class ContactsListWidget extends StatelessWidget {
  const ContactsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ChatPageScreen();
                  }));
                },
                child: SizedBox(
                  height: 65.h,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                          height: 50.h,
                          width: 45.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Programmer',
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'This is the Bio of User',
                              style: TextStyle(
                                color: AppColor.mainGrey,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
