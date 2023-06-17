import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class TitleAndButton extends StatelessWidget {
  final String title;
  final Function()? onPress;
  final bool icon;
  const TitleAndButton({
    super.key,
    required this.title,
    this.onPress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
          child: Text(
            title,
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
          ),
        ),
        InkWell(
          onTap: onPress,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            width: 100.w,
            height: 30.h,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.backgroundColor)),
              child: Text(
                AppLocalizations.of(context).translate('show_all'),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: AppColor.backgroundColor, fontSize: 13.sp),
              ),
            ),
          ),
        )
      ],
    );
  }
}
