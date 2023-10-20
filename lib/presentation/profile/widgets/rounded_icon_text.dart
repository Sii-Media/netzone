import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

Widget roundedIconText(
    {required BuildContext context,
    required String text,
    required IconData icon,
    Function()? onTap}) {
  return SizedBox(
    width: 85.w,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 35.r,
            width: 35.r,
            padding: const EdgeInsets.all(0.5),
            decoration: const BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            ),
            child: ClipOval(
              child: Icon(
                icon,
                color: AppColor.white,
                size: 16.sp,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          AppLocalizations.of(context).translate(text),
          style: TextStyle(
              color: AppColor.backgroundColor,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
