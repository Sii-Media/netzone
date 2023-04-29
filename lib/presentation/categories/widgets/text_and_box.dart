import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextAndBoxWidget extends StatelessWidget {
  final String title;
  final String subTitle;

  const TextAndBoxWidget(
      {Key? key, required this.title, required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 30.h,
              child: Text(subTitle),
            ),
          )
        ],
      ),
    );
  }
}
