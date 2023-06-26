import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tender_item.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

class TenderInfoScreen extends StatelessWidget {
  const TenderInfoScreen({super.key, required this.tender});

  final TenderItem tender;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackgroundWidget(
        widget: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              height: size.height * 0.30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: CachedNetworkImage(
                  imageUrl: tender.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            titleAndInput(
              title:
                  "${AppLocalizations.of(context).translate("اسم المناقصة")} : ",
              input: tender.nameAr,
            ),
            titleAndInput(
              title:
                  "${AppLocalizations.of(context).translate('company_name')} : ",
              input: tender.companyName,
            ),
            titleAndInput(
              title:
                  "${AppLocalizations.of(context).translate('تاريخ بدء المناقصة')} : ",
              input: convertDateToString(tender.startDate),
            ),
            titleAndInput(
              title:
                  "${AppLocalizations.of(context).translate('تاريخ انتهاء المناقصة')}: ",
              input: convertDateToString(tender.endDate),
            ),
            titleAndInput(
              title:
                  "${AppLocalizations.of(context).translate('السعر يبدأ')} : ",
              input: tender.price.toString(),
            ),
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
                  child: Text(
                      AppLocalizations.of(context).translate('شراء المناقصة'))),
            ),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }

  Padding titleAndInput({required String title, required String input}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 40.h,
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
                    color: AppColor.backgroundColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 190,
                child: Text(
                  input,
                  style: TextStyle(
                    color: AppColor.mainGrey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
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
