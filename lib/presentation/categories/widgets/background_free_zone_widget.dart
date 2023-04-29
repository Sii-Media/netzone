import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class BackgroundFreeZoneWidget extends StatelessWidget {
  final Widget widget;
  final String title;

  const BackgroundFreeZoneWidget(
      {Key? key, required this.widget, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.96,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration:
                          const BoxDecoration(color: AppColor.backgroundColor),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/abraj.png"),
                            fit: BoxFit.fill,
                            // fit: BoxFit.,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Get.back();
                                    },
                                    icon: Icon(
                                      color: Colors.white,
                                      Icons.arrow_back_ios_outlined,
                                      size: 25.h,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 5),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.sp),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.61,
                child: Stack(
                  children: [
                    Container(
                      // height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/00.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(height: size.height * 0.6, child: widget),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.04,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.backgroundColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
