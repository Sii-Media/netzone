import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_details.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/custom_appbar.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:url_launcher/link.dart';

import '../widgets/image_free_zone_widget.dart';

class GovermentalDetailsScreen extends StatelessWidget {
  const GovermentalDetailsScreen({super.key, required this.govermentalDetails});

  final GovermentalDetails govermentalDetails;

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
            CustomAppBar(
              context: context,
              isHome: false,
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
                      customNamed(
                          '${AppLocalizations.of(context).translate('Company name')} :',
                          govermentalDetails.name),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                          '${AppLocalizations.of(context).translate('region_or_emirate')} :',
                          govermentalDetails.city),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                          '${AppLocalizations.of(context).translate('address')} :',
                          govermentalDetails.address),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                          '${AppLocalizations.of(context).translate('mobile')} :',
                          govermentalDetails.mobile!),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                          '${AppLocalizations.of(context).translate('phone')} :',
                          govermentalDetails.phone!),
                      SizedBox(
                        height: 20.h,
                      ),
                      customNamed(
                          '${AppLocalizations.of(context).translate('email')} :',
                          govermentalDetails.email),
                      SizedBox(
                        height: 20.h,
                      ),
                      customInfo(govermentalDetails.info, context),
                      SizedBox(
                        height: 20.h,
                      ),
                      govermentalDetails.link == null
                          ? Container()
                          : servicesInfo(
                              url: govermentalDetails.link!,
                              context: context,
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        '${AppLocalizations.of(context).translate('images')} :',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      govermentalDetails.images.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: govermentalDetails.images.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.94),
                              itemBuilder: (BuildContext context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: ListOfPictures(
                                    img: govermentalDetails.images[index],
                                  ),
                                );
                              })
                          : Text(
                              AppLocalizations.of(context)
                                  .translate('no_images'),
                              style: TextStyle(
                                color: AppColor.mainGrey,
                                fontSize: 15.sp,
                              ),
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      VideoFreeZoneWidget(
                          title:
                              '${AppLocalizations.of(context).translate('vedio')} :',
                          vediourl: govermentalDetails.videourl!),
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
                  govermentalDetails.name,
                  style: TextStyle(
                      fontSize: 15.sp, color: AppColor.backgroundColor),
                ),
              ),
            ),
          ],
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

  Column customInfo(String info, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context).translate('Government organization details')} :',
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

  Row servicesInfo({required String url, context}) {
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
}
