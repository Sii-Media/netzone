import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/search/search_screen.dart';

import '../../notifications/screens/notification_screen.dart';
import '../constant/colors.dart';

SizedBox customAppBar(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.16,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150.w,
          // height: 120.h,
          padding: const EdgeInsets.only(
            left: 0,
            right: 5,
            bottom: 2,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/netzoon-logo.png"),
            ),
          ),
        ),
        Row(
          children: [
            // CountryCodePicker(
            //   searchStyle: const TextStyle(color: AppColor.black),
            //   dialogTextStyle: const TextStyle(
            //     color: AppColor.black,
            //   ),
            //   boxDecoration: BoxDecoration(
            //     color:
            //         const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
            //   ),

            //   textStyle: TextStyle(
            //     color: AppColor.white,
            //     fontSize: 10.sp,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   onChanged: (val) {},
            //   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            //   initialSelection: 'AE',
            //   favorite: const ['+971', 'AE'],
            //   // optional. Shows only country name and flag
            //   showCountryOnly: true,
            //   showFlag: true,
            //   showFlagMain: true,
            //   hideMainText: true,

            //   // optional. Shows only country name and flag when popup is closed.
            //   showOnlyCountryWhenClosed: true,
            //   // optional. aligns the flag and the Text left
            //   alignLeft: false,
            //   // backgroundColor: AppColor.backgroundColor,
            //   // barrierColor: AppColor.backgroundColor,
            // ),
            CachedNetworkImage(
              imageUrl:
                  'https://mybayutcdn.bayut.com/mybayut/wp-content/uploads/UAE-flag-history-A-06-08-1-1024x640.jpg',
              height: 30,
              width: 30,
            ),
            SizedBox(
              width: 12.w,
            ),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     'AED',
            //     style: TextStyle(
            //       color: AppColor.white,
            //     ),
            //   ),
            // ),
            const Text(
              'AED',
              style: TextStyle(
                color: AppColor.backgroundColor,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.notifications,
            //     color: AppColor.white,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const NotificatiionScreen();
                }));
              },
              child: const Icon(
                Icons.notifications,
                color: AppColor.backgroundColor,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () {
                // showSearch(context: context, delegate: DataSearch());
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (context) {
                  return const SearchPage();
                }));
              },
              child: const Icon(
                Icons.search,
                color: AppColor.backgroundColor,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ],
    ),
  );
}
