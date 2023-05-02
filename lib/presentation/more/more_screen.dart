import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/contact/screens/contact_us_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/language_screen/languages_screen.dart';
import 'package:netzoon/presentation/legal_advice/legal_advice_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SettingsCategory(
              name: 'استشارات قانونية',
              icon: Icons.gavel_rounded,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LegalAdviceScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            const SettingsCategory(
              name: 'الشواغر',
              icon: Icons.work,
            ),
            SizedBox(
              height: 10.h,
            ),
            SettingsCategory(
              name: 'البلد',
              icon: Icons.location_city,
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return const LanguagesScreen();
                //     },
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            SettingsCategory(
              name: 'اللغة',
              icon: Icons.language,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LanguagesScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            SettingsCategory(
              name: 'تواصل معنا',
              icon: Icons.email,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ContactUsScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    super.key,
    required this.name,
    this.onTap,
    this.icon,
  });
  final String name;
  final void Function()? onTap;
  final IconData? icon;
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
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 15.sp, color: AppColor.white),
                ),
              ],
            ),
          )),
    );
  }
}