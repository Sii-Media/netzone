import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';

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
              width: 190,
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
