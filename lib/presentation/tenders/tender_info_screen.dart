import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/tenders/entities/tender.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class TenderInfoScreen extends StatelessWidget {
  const TenderInfoScreen({super.key, required this.tender});

  final Tender tender;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                height: size.height * 0.30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: CachedNetworkImage(
                    imageUrl: tender.imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              myspec(context, "اسم المناقصة : ", tender.name,
                  AppColor.backgroundColor, Colors.black),
              myspec(context, "اسم الشركة : ", tender.companyName,
                  AppColor.backgroundColor, Colors.black),
              myspec(context, "تاريخ بدء المناقصة : ", tender.startDate,
                  AppColor.backgroundColor, Colors.black),
              myspec(context, "تاريخ انتهاء المناقصة: ", tender.endDate,
                  AppColor.backgroundColor, Colors.black),
              SizedBox(
                height: 5.h,
              ),
              myspec(context, 'قيمة المناقصة', tender.tenderValue,
                  AppColor.backgroundColor, Colors.black),
              SizedBox(
                height: 5.h,
              ),
              myspec(context, "السعر يبدأ : ", tender.startPrice,
                  AppColor.backgroundColor, Colors.black),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.h),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      // Get.to(ViewDetailsDeals(dealsModel: dealsModel));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        //shadowColor: Colors.black,
                        //  elevation: 5
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textStyle: const TextStyle(fontSize: 15)),
                    child: const Text("شراء المناقصة")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

myspec(context, String feature, String details, Color colorbackground,
    Color colortext) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(
      bottom: 5,
      top: 5,
      right: 10,
      left: 10,
    ),
    child: RichText(
      text: TextSpan(
          style: TextStyle(fontSize: 17.sp, color: colorbackground),
          children: <TextSpan>[
            TextSpan(text: feature),
            TextSpan(
              text: details,
              style: TextStyle(color: colortext, fontSize: 13.sp),
            )
          ]),
    ),
  );
}
