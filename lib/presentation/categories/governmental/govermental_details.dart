import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_details.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:url_launcher/link.dart';

import '../widgets/image_free_zone_widget.dart';

class GovermentalDetailsScreen extends StatelessWidget {
  const GovermentalDetailsScreen({super.key, required this.govermentalDetails});

  final GovermentalDetails govermentalDetails;

  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          prefixIcon: InkWell(
                              child: const Icon(Icons.search), onTap: () {}),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: AppLocalizations.of(context)
                              .translate('search in netzoon'),
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
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
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
