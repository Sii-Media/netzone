import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final dynamic vehicle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 7,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: vehicle.imageUrl,
                          width: 700.w,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    vehicle.price,
                                    style: TextStyle(
                                        color: AppColor.colorOne,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Icon(
                                        Icons.share,
                                        color: AppColor.backgroundColor,
                                      ),
                                      Icon(
                                        Icons.favorite_border,
                                        color: AppColor.backgroundColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                vehicle.name,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 7,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفاصيل',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'الفئة',
                            input: 'S-line',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'السنة',
                            input: vehicle.year,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'كيلومترات',
                            input: vehicle.kilometers,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'المواصفات الاقليمية',
                            input: 'مواصفات خليجية',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          titleAndInput(
                            title: 'الضمان',
                            input: 'لا ينطبق',
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 7,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وصف',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 17.sp,
                          ),
                        ),
                        Text(
                          vehicle.description,
                          style: TextStyle(
                            color: AppColor.mainGrey,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container titleAndInput({
    required String title,
    required String input,
  }) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            Text(
              input,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
