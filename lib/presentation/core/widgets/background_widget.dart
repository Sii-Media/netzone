import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import 'custom_appbar.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget widget;
  final bool isHome;
  BackgroundWidget({
    Key? key,
    required this.widget,
    required this.isHome,
  }) : super(key: key);
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  border: Border(
                    bottom: BorderSide(
                        width: 0.7,
                        color: AppColor.backgroundColor.withOpacity(0.4)),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: AppColor.backgroundColor.withOpacity(0.5),
                  //       spreadRadius: 1,
                  //       blurRadius: 5,
                  //       offset: const Offset(0, 0.2)),
                  // ],
                ),
              ),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage("assets/images/00.png"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            CustomAppBar(context: context, isHome: isHome),
            Positioned(
              top: 65.r,
              right: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 35.h,
                child: SafeArea(child: widget),
              ),
            )
          ],
        ),
      ),
    );
  }
}
