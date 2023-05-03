import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/govermental_details.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:url_launcher/link.dart';

class GovermentalDetailsScreen extends StatelessWidget {
  const GovermentalDetailsScreen({super.key, required this.govermentalDetails});

  final GovermentalDetails govermentalDetails;

  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration:
                      const BoxDecoration(color: AppColor.backgroundColor),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/00.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.white,
                            suffixIcon: InkWell(
                                child: const Icon(Icons.search), onTap: () {}),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            hintText: 'البحث في netzoon.com',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                              fontSize: 8.sp,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 135.w,
                      height: 130.h,
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 202.h,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 1, bottom: 14, left: 20, right: 20),
                  height: MediaQuery.of(context).size.height - 191.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('اسم المؤسسة :', govermentalDetails.name),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed(
                            'المنطقة أو الامارة :', govermentalDetails.city),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('العنوان :', govermentalDetails.address),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('موبايل :', govermentalDetails.mobile!),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('الهاتف :', govermentalDetails.phone!),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed(
                            'البريد الالكتروني :', govermentalDetails.email),
                        SizedBox(
                          height: 20.h,
                        ),
                        customInfo(govermentalDetails.info),
                        SizedBox(
                          height: 20.h,
                        ),
                        govermentalDetails.link == null
                            ? Container()
                            : servicesInfo(url: govermentalDetails.link!),
                        Center(
                          child: Text(
                            'لا يوجد صور',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        VideoFreeZoneWidget(
                            title: 'الفيديوهات :',
                            vediourl: govermentalDetails.videourl!),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 150.h,
                child: Center(
                  child: Text(
                    govermentalDetails.govname,
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row customNamed(String title, String desc) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Text(
            desc,
            style: TextStyle(
              color: AppColor.mainGrey,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Column customInfo(String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل المؤسسة الحكومية :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 7.0.h,
        ),
        Text(
          info,
          style: TextStyle(
            color: AppColor.mainGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Row servicesInfo({required String url}) {
    return Row(
      children: [
        Text(
          'الخدمات :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Link(
          uri: Uri.parse(
            url,
          ),
          builder: ((context, followLink) => GestureDetector(
                onTap: followLink,
                child: Text(
                  'اضغط هنا',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 15.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
