import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonAuthWidget extends StatelessWidget {
  final String text;
  final Color colorText;
  final Color color;
  final void Function()? onPressed;

  const ButtonAuthWidget(
      {Key? key,
      required this.text,
      this.onPressed,
      required this.colorText,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10).h,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 50.w),
        onPressed: onPressed,
        color: color,
        textColor: colorText,
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
      ),
    );
  }
}
