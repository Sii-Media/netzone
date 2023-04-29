import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/deals_info.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class DealDetails extends StatelessWidget {
  const DealDetails({super.key, required this.dealsInfo});

  final DealsInfo dealsInfo;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BackgroundWidget(
                widget: ListView(
              children: [
                myspec(context, "اسم الصفقة : ", dealsInfo.name,
                    AppColor.backgroundColor, Colors.black),
                myspec(context, "اسم البائع : ", dealsInfo.companyName,
                    AppColor.backgroundColor, Colors.black),
                myspec(context, "منتجات الصفقة : ", 'قطع غيار',
                    AppColor.backgroundColor, Colors.black),
                Container(
                  margin: const EdgeInsets.all(8),
                  height: size.height * 0.30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: CachedNetworkImage(
                      imageUrl: dealsInfo.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                myspec(context, "تاريخ بدء الصفقة : ", dealsInfo.startDate,
                    AppColor.backgroundColor, Colors.black),
                myspec(context, "تاريخ انتهاء الصفقة: ", dealsInfo.endDate,
                    AppColor.backgroundColor, Colors.black),
                SizedBox(
                  height: 5.h,
                ),
                myspec(context, "السعر قبل:", dealsInfo.prepeice,
                    AppColor.backgroundColor, Colors.black),
                SizedBox(
                  height: 5.h,
                ),
                myspec(context, "السعر بعد : ", dealsInfo.currpeice,
                    AppColor.backgroundColor, Colors.black),
                SizedBox(
                  height: 20.h,
                )
              ],
            )),
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
    padding: const EdgeInsets.all(10),
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
