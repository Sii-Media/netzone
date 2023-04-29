import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class AdvertismentDetalsScreen extends StatelessWidget {
  const AdvertismentDetalsScreen({super.key, required this.ads});

  final Advertisement ads;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            widget: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: ads.advertisingImage,
                        fit: BoxFit.cover,
                      ),
                      // child: Image.network(
                      //   ads.advertisingImage,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'العنوان :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingTitle,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'تاريخ البدأ :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingStartDate,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'تاريخ الانتهاء',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  ads.advertisingEndDate,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الوصف :',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Text(
                                    ads.advertisingDescription,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
