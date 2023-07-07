import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/custom_appbar.dart';
import 'package:url_launcher/link.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key, required this.companyCategory});

  final FreeZoneCompany companyCategory;

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
            customAppBar(context),
            Positioned(
              top: 205.h,
              right: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                height: MediaQuery.of(context).size.height - 191.h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      countryInfo(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      cityInfo(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      addressInfo(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      companyCategory.phone != null
                          ? phoneInfo(context)
                          : Container(),
                      companyCategory.mobile != null
                          ? mobileInfo(context)
                          : Container(),
                      emialInfo(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      companyCategory.info == ''
                          ? Container()
                          : freeZoonInfo(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      companyCategory.link == '' || companyCategory.link == null
                          ? Container()
                          : servicesInfo(
                              url: companyCategory.link!, context: context),
                      SizedBox(
                        height: 20.h,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: companyCategory.companies?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return freeZoonCompanies(
                              companyCategory.companies![index], context);
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      companyCategory.companyimages.isEmpty
                          ? SizedBox(
                              height: 20.h,
                            )
                          : ImageFreeZoneWidget(
                              companyimages: companyCategory.companyimages,
                            ),
                      SizedBox(
                        height: 25.h,
                      ),
                      // companyCategory.videourl != null ||
                      companyCategory.videourl != ''
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 60.0),
                              child: VideoFreeZoneWidget(
                                title:
                                    "${AppLocalizations.of(context).translate('freezoon_vedio')} : ",
                                vediourl: companyCategory.videourl!,
                              ),
                            )
                          : SizedBox(
                              height: 20.h,
                            ),
                      SizedBox(
                        height: 40.h,
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
                  AppLocalizations.of(context).translate(companyCategory.name),
                  style: TextStyle(
                      fontSize: 20.sp, color: AppColor.backgroundColor),
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
            )
          ],
        ),
      ),
    );
  }

  Column phoneInfo(context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context).translate('phone')} :',
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              companyCategory.phone!,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }

  Column mobileInfo(context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context).translate('mobile')} :',
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              companyCategory.mobile!,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }

  Row countryInfo(context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context).translate('freezone_name')} :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.categoryName,
          style: TextStyle(
            color: AppColor.mainGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Row cityInfo(context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context).translate('region_or_emirate')} :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.city,
          style: TextStyle(
            color: AppColor.mainGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Row addressInfo(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context).translate('address')} :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Text(
            companyCategory.address,
            style: TextStyle(
              color: AppColor.mainGrey,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Row emialInfo(context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context).translate('email')}: ',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.email,
          style: TextStyle(
            color: AppColor.mainGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  ClipRRect freeZoonCompanies(Companies companies, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0).w,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        margin: const EdgeInsets.symmetric(vertical: 5).r,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 232, 232),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('companies'),
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Center(
              child: CachedNetworkImage(
                imageUrl: companies.image,
                fit: BoxFit.contain,
                height: 80.h,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                color: AppColor.backgroundColor,
                height: 35.h,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    companies.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column freeZoonInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context).translate('freezone_details')} :',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(
          height: 7.0.h,
        ),
        Text(
          companyCategory.info,
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
