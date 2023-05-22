import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildTop(top),
            Column(
              children: [
                Center(
                  child: Text(
                    widget.user.userInfo.username,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                ),
                socialMedialRow(),
                SizedBox(
                  height: 10.h,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildInfo(value: '100', title: 'Following'),
                    SizedBox(
                      width: 15.w,
                    ),
                    buildInfo(value: '200', title: 'Followers'),
                    SizedBox(
                      width: 15.w,
                    ),
                    buildInfo(value: '50', title: 'Views'),
                  ],
                ),
                const Divider(),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 48,
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'About',
                //         style: TextStyle(
                //           fontSize: 22.sp,
                //           fontWeight: FontWeight.bold,
                //           color: AppColor.black,
                //         ),
                //       ),
                //       SizedBox(
                //         height: 10.h,
                //       ),
                //       Text(
                //         'مهندس برمجيات و مطور تطبيقات موبايل و مطور ويب',
                //         style: TextStyle(
                //           fontSize: 18.sp,
                //           fontWeight: FontWeight.w400,
                //           color: AppColor.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }

  Column buildInfo({required String value, required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: AppColor.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Row socialMedialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialIcon(icon: FontAwesomeIcons.facebook),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.instagram),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.twitter),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.linkedin),
      ],
    );
  }

  CircleAvatar buildSocialIcon({required IconData icon}) {
    return CircleAvatar(
      radius: 22,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Icon(
              icon,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Stack buildTop(double top) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: CachedNetworkImage(
            imageUrl: widget.user.userInfo.coverPhoto ?? '',
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: CachedNetworkImageProvider(
                widget.user.userInfo.profilePhoto ?? ''),
          ),
        ),
      ],
    );
  }
}
