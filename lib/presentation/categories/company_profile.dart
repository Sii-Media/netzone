import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/company_category.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key, required this.companyCategory});

  final CompanyCategory companyCategory;

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
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20),
                  height: MediaQuery.of(context).size.height - 191.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        countryInfo(),
                        SizedBox(
                          height: 20.h,
                        ),
                        cityInfo(),
                        SizedBox(
                          height: 20.h,
                        ),
                        addressInfo(),
                        SizedBox(
                          height: 20.h,
                        ),
                        companyCategory.phone != null
                            ? phoneInfo()
                            : Container(),
                        companyCategory.mobile != null
                            ? mobileInfo()
                            : Container(),
                        emialInfo(),
                        SizedBox(
                          height: 20.h,
                        ),
                        companyCategory.info == ''
                            ? Container()
                            : freeZoonInfo(),
                        SizedBox(
                          height: 20.h,
                        ),
                        freeZoonCompanies(context),
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
                        VideoFreeZoneWidget(
                          title: "فيديو المنطقة الحرة : ",
                          vediourl: companyCategory.videourl!,
                        ),
                        SizedBox(
                          height: 20.h,
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
                    companyCategory.name,
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

  Column phoneInfo() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'الهاتف :',
              style: TextStyle(
                color: const Color.fromARGB(255, 96, 95, 95),
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              companyCategory.phone!,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.sp,
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

  Column mobileInfo() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'موبايل :',
              style: TextStyle(
                color: const Color.fromARGB(255, 96, 95, 95),
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              companyCategory.mobile!,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.sp,
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

  Row countryInfo() {
    return Row(
      children: [
        Text(
          'اسم المنطقة الحرة :',
          style: TextStyle(
            color: const Color.fromARGB(255, 96, 95, 95),
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.categoryName,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  Row cityInfo() {
    return Row(
      children: [
        Text(
          'المنطقة أو الإمارة :',
          style: TextStyle(
            color: const Color.fromARGB(255, 96, 95, 95),
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.city,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  Row addressInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العنوان :',
          style: TextStyle(
            color: const Color.fromARGB(255, 96, 95, 95),
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Text(
            companyCategory.address,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Row emialInfo() {
    return Row(
      children: [
        Text(
          'البريد الإلكتروني: ',
          style: TextStyle(
            color: const Color.fromARGB(255, 96, 95, 95),
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          companyCategory.email,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  ClipRRect freeZoonCompanies(BuildContext context) {
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
                'الشركات',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Center(
              child: CachedNetworkImage(
                imageUrl: companyCategory.imgurl,
                fit: BoxFit.contain,
                height: 80.h,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) {
                //     return AdvertismentDetalsScreen(
                //       ads: advertisment,
                //     );
                //   }),
                // );
              },
              child: Container(
                color: AppColor.backgroundColor,
                height: 35.h,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "اللطافة",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
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

  Column freeZoonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل المنطقة الحرة :',
          style: TextStyle(
            color: const Color.fromARGB(255, 96, 95, 95),
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 7.0.h,
        ),
        Text(
          companyCategory.info,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
