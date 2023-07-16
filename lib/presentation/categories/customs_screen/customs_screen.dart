import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/customs_category.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/custom_appbar.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:url_launcher/link.dart';

class CustomsScreen extends StatelessWidget {
  const CustomsScreen({super.key, required this.customsCategory});

  final CustomsCategory customsCategory;

  @override
  Widget build(BuildContext context) {
    // final TextEditingController search = TextEditingController();

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
                height: MediaQuery.of(context).size.height * 0.30,
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
            CustomAppBar(context: context),
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
                      customNamed(
                          'اسم الجمرك',
                          AppLocalizations.of(context)
                              .translate(customsCategory.name),
                          context),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                        'region_or_emirate',
                        AppLocalizations.of(context)
                            .translate(customsCategory.city),
                        context,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                        'address',
                        customsCategory.address,
                        context,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                        'mobile',
                        '080080080',
                        context,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                        'phone',
                        '080080080',
                        context,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                        'email',
                        customsCategory.email,
                        context,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customsCategory.info == ''
                          ? const SizedBox()
                          : customInfo(
                              customsCategory.info,
                              context,
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      customsCategory.link == '' || customsCategory.link == null
                          ? Container()
                          : servicesInfo(
                              url: customsCategory.link!,
                              context: context,
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate('no_images'),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      VideoFreeZoneWidget(
                          title:
                              AppLocalizations.of(context).translate('vedio'),
                          vediourl: 'nV8IyCsBR6k'),
                      SizedBox(
                        height: 60.h,
                      ),
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
                  AppLocalizations.of(context).translate(customsCategory.name),
                  style: TextStyle(
                      fontSize: 22.sp, color: AppColor.backgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row servicesInfo({required String url, required BuildContext context}) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context).translate('services')} :',
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
                  AppLocalizations.of(context).translate('click_here'),
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

  Row customNamed(String title, String desc, BuildContext context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context).translate(title)} :',
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

  Column customInfo(String info, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context).translate('Government organization details')} :',
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
