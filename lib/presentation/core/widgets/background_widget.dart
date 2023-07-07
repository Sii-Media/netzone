import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import 'custom_appbar.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget widget;

  BackgroundWidget({
    Key? key,
    required this.widget,
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
                        width: 1, color: AppColor.mainGrey.withOpacity(0.1)),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 3)),
                  ],
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
            customAppBar(context),
            Positioned(
              top: 57.h,
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
