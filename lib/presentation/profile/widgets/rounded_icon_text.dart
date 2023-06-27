import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

Widget roundedIconText(
    {required BuildContext context,
    required String text,
    required IconData icon,
    Function()? onTap}) {
  return Container(
    width: 70.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 35.h,
            width: 35.w,
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
                size: 20,
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
