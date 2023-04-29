import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/contact/screens/add_complaint_screen.dart';
import 'package:netzoon/presentation/contact/screens/complaints_screen.dart';
import 'package:netzoon/presentation/contact/screens/opinion_screen.dart';
import 'package:netzoon/presentation/contact/screens/question_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تواصل معنا',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ContactCategory(
                  title: 'الآراء',
                  icon: Icons.people,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const OpinionScreen();
                    }));
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                ContactCategory(
                  title: 'الشكاوى',
                  icon: Icons.note_alt_outlined,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const ComplaintsScreen();
                    }));
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                ContactCategory(
                  title: 'اترك سؤالك',
                  icon: Icons.question_mark_sharp,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const QuestionScreen();
                    }));
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                ContactCategory(
                  title: 'طلب خاص',
                  icon: Icons.note_add_sharp,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const AddComplaintScreen();
                    }));
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                const ContactCategory(
                  title: 'البحث عن المنتجات',
                  icon: Icons.search_sharp,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60.h,
                        width: 200.w,
                        color: AppColor.backgroundColor,
                        child: Center(
                          child: Text(
                            'الدردشة مع تطبيق (NetZoon)',
                            style: TextStyle(
                                fontSize: 15.sp, color: AppColor.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60.h,
                        width: 200.w,
                        color: AppColor.backgroundColor,
                        child: Center(
                          child: Text(
                            'إرسال بريد إلكتروني',
                            style: TextStyle(
                                fontSize: 15.sp, color: AppColor.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ContactCategory extends StatelessWidget {
  const ContactCategory({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60.h,
          width: double.infinity,
          color: AppColor.backgroundColor,
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColor.white,
              ),
              SizedBox(
                width: 7.w,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 15.sp, color: AppColor.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
