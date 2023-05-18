import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController1 = TextEditingController();
    final textController2 = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 13.sp,
                      color: AppColor.backgroundColor,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'الشكاوى',
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                QuestionFormField(
                  textController: textController1,
                  hintText: 'العنوان',
                ),
                SizedBox(
                  height: 10.h,
                ),
                QuestionFormField(
                  textController: textController2,
                  hintText: 'الموضوع',
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30.h,
                          width: 130.w,
                          color: AppColor.backgroundColor,
                          child: Center(
                            child: Text(
                              'حفظ',
                              style: TextStyle(
                                  fontSize: 13.sp, color: AppColor.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30.h,
                          width: 130.w,
                          color: AppColor.backgroundColor,
                          child: Center(
                            child: Text(
                              'جديد',
                              style: TextStyle(
                                  fontSize: 13.sp, color: AppColor.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                const TitleAndNumber(
                  title: 'الرقم',
                  number: '1',
                ),
                SizedBox(
                  height: 20.h,
                ),
                const TitleAndNumber(
                  title: 'بتاريخ',
                  number: '12/09/2022',
                ),
                SizedBox(
                  height: 20.h,
                ),
                const TitleAndNumber(
                  title: 'العنوان',
                  number: 'Cancle order',
                ),
                SizedBox(
                  height: 20.h,
                ),
                const TitleAndNumber(
                  title: 'الرد',
                  number: 'Thank for order cancellation',
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAndNumber extends StatelessWidget {
  const TitleAndNumber({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
