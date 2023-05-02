import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/core/widgets/background_two_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class AdvertisingScreen extends StatelessWidget {
  const AdvertisingScreen({super.key, required this.advertisment});

  final List<Advertisement> advertisment;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundTwoWidget(
          title: "الإعلانات",
          widget: Container(
            padding: const EdgeInsets.only(bottom: 60).r,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: advertisment.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 240.h,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20).w),
                  child: Advertising(advertisment: advertisment[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Advertising extends StatelessWidget {
  const Advertising({
    Key? key,
    required this.advertisment,
  }) : super(key: key);
  final Advertisement advertisment;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0).w,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          margin: const EdgeInsets.symmetric(vertical: 5).r,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1,
            )
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: CachedNetworkImage(
                  imageUrl: advertisment.advertisingImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.14,
                ),
              ),
              Text(
                advertisment.advertisingTitle,
                style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                advertisment.advertisingDescription,
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 12.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AdvertismentDetalsScreen(
                        ads: advertisment,
                      );
                    }),
                  );
                },
                child: Container(
                  color: AppColor.backgroundColor,
                  height: 30.h,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "تفاصيل الإعلان",
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
