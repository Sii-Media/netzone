import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../blocs/add_account/add_account_bloc.dart';

Stack buildTop(double top, String coverUrl, String profileUrl,
    double profileHeight, BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: profileHeight / 2),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            // color: AppColor.backgroundColor,
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  coverUrl,
                ),
                fit: BoxFit.fitWidth),
          ),
        ),
      ),
      Positioned(
        top: top,
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: CachedNetworkImageProvider(profileUrl),
        ),
      ),
    ],
  );
}

Widget accountWidget(
    {required GetUserAccountsSuccess accountstate,
    required int index,
    void Function()? onTap,
    required void Function(int?)? onChanged}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    accountstate.users[index].profilePhoto ??
                        'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(100)),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          accountstate.users[index].username ?? '',
          style: TextStyle(
              color: AppColor.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Radio<int>(
          value: 1,
          groupValue: 0,
          onChanged: onChanged,
          activeColor: AppColor.white,
        ),
      ],
    ),
  );
}

Padding titleAndInput({required String title, required String input}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(
              width: 190.w,
              child: Text(
                input,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
