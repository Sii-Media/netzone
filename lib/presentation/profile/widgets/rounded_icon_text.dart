import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

Padding roundedIconText(
    {required BuildContext context,
    required String text,
    required IconData icon,
    Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 55.h,
            width: 45.w,
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
                size: 25,
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
              fontSize: 13.sp,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
