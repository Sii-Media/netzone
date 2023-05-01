import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/customs_category.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:url_launcher/link.dart';

class CustomsScreen extends StatelessWidget {
  const CustomsScreen({super.key, required this.customsCategory});

  final CustomsCategory customsCategory;

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
                        customsCategory.videourl != null
                            ? VideoFreeZoneWidget(
                                title: '',
                                vediourl: customsCategory.videourl!,
                              )
                            : Container(),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('اسم الجمرك', customsCategory.name),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('المنطقة أو الامارة', customsCategory.city),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('العنوان', customsCategory.address),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('موبايل', '080080080'),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('الهاتف', '080080080'),
                        SizedBox(
                          height: 20.h,
                        ),
                        customNamed('البريد الالكتروني', customsCategory.email),
                        SizedBox(
                          height: 20.h,
                        ),
                        customInfo(customsCategory.info),
                        SizedBox(
                          height: 20.h,
                        ),
                        customsCategory.link == '' ||
                                customsCategory.link == null
                            ? Container()
                            : servicesInfo(url: customsCategory.link!),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Text(
                            'لا يوجد صور',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const VideoFreeZoneWidget(
                            title: 'الفيديوهات', vediourl: 'nV8IyCsBR6k'),
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
                    customsCategory.name,
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Row customNamed(String title, String desc) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          desc,
          style: TextStyle(
            color: AppColor.mainGrey,
            fontSize: 14.sp,
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
            fontSize: 15.sp,
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
}
