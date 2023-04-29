import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/widgets/background_free_zone_widget.dart';
import 'package:netzoon/presentation/categories/widgets/text_and_box.dart';

class FreeZoneDetailsScreen extends StatelessWidget {
  const FreeZoneDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundFreeZoneWidget(
          title: 'title',
          widget: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                children: [
                  const TextAndBoxWidget(
                    title: "اسم المنطقة الحرة : ",
                    subTitle: 'subTitle',
                  ),
                  const TextAndBoxWidget(
                    title: "العنوان : ",
                    subTitle: 'subTitle',
                  ),
                  const TextAndBoxWidget(
                    title: "البريد الإلكتروني : ",
                    subTitle: 'subTitle',
                  ),
                  const TextAndBoxWidget(
                    title: "رقم الهاتف  : ",
                    subTitle: 'subTitle',
                  ),
                  Text(
                    "تفاصيل المنطقة الحرة : ",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Container(
                    color: Colors.white,
                    constraints: const BoxConstraints(
                      maxHeight: 1000,
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: RichText(
                      text: const TextSpan(
                        text: 'asdasd',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  // ImageFreeZoneWidget(),
                  // VideoFreeZoneWidget(),
                  // CompaniesFreeZoneWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
